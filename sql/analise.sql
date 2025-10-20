-- Análise de dados das viagens. Aqui estarão todas as queries utilizadas para a construção da análise.
-- As queries serão separadas por slides, para facilitar a organização e entendimento do raciocínio.



-- Slide 3 e 5: Clusterização de Status das Corridas | Impacto Financeiro das Corridas

-- Realizando a clusterização das viagens por status
-- e calculando a receita total, ticket médio, total de corridas e percentual de corridas por cluster.
-- Utilizando a função de janela SUM() OVER() para calcular o percentual de corridas

SELECT CASE WHEN booking_status = 'Completed' THEN 'Concluídas'
            WHEN booking_status = 'Incomplete' THEN 'Incompletas' ELSE 'Canceladas' END AS 'status_cluster'
    ,SUM(booking_value) AS 'receita'
    ,COUNT(*) AS 'total_de_corridas'
    ,REPLACE(CONVERT(VARCHAR, ROUND(((CONVERT(FLOAT, COUNT(*)) / SUM(COUNT(*)) OVER()) * 100),2)), '.', ',') + '%' AS 'percentual_de_corridas' -- Formato adaptado para pt-BR
    ,AVG(booking_value) AS 'ticket_medio'
FROM dbo.tb_uber_ride_analytics
GROUP BY CASE WHEN booking_status = 'Completed' THEN 'Concluídas'
            WHEN booking_status = 'Incomplete' THEN 'Incompletas' ELSE 'Canceladas' END
ORDER BY COUNT(*) DESC;
GO



-- Slide 4: Impacto Financeiro das Corridas

-- Análise detalhada das viagens incompletas
-- Agrupando pelo motivo da incompletude
-- Levantando diversos indicadores como receita, ticket médio, percentual de corridas e percentual de receita

SELECT incomplete_rides_reason
    ,COUNT(*) AS 'total_de_corridas'
    ,SUM(booking_value) AS 'receita'
    ,REPLACE(CONVERT(VARCHAR, ROUND(((CONVERT(FLOAT, COUNT(*)) / SUM(COUNT(*)) OVER()) * 100),2)), '.', ',') + '%' AS 'percentual_de_corridas'
    ,REPLACE(CONVERT(VARCHAR, ROUND(((CONVERT(FLOAT, SUM(booking_value)) / SUM(SUM(booking_value)) OVER()) * 100),2)), '.', ',') + '%' AS 'percentual_de_receita'
    ,AVG(booking_value) AS 'ticket_medio'
    ,AVG(avg_vtat) AS 'avg_vtat'
    ,AVG(avg_ctat) AS 'avg_ctat'
FROM dbo.tb_uber_ride_analytics
WHERE booking_status = 'Incomplete'
GROUP BY incomplete_rides_reason
ORDER BY COUNT(*) DESC;
GO


-- Slide 6: Motivo de Corridas Incompletas

-- Análise do percentual de corridas por status em intervalos de 1 hora
-- Levantando o percentual de corridas concluídas, incompletas e canceladas por intervalo de 1 hora
-- Adicionando uma flag para o intervalo entre 16h e 19h

-- Criação da CTE para facilitar a leitura e organização da query
WITH  cte AS (
SELECT CONVERT(TIME, DATEADD(HOUR, DATEPART(HOUR, intervalo), '00:00:00')) AS 'intervalo_1h'
    ,SUM(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END) AS 'concluidas'
    ,SUM(CASE WHEN booking_status = 'Incomplete' THEN 1 ELSE 0 END) AS 'incompletas'
    ,SUM(CASE WHEN booking_status NOT IN('Completed', 'Incomplete') THEN 1 ELSE 0 END) AS 'canceladas'
FROM dbo.tb_uber_ride_analytics
GROUP BY CONVERT(TIME, DATEADD(HOUR, DATEPART(HOUR, intervalo), '00:00:00'))
)
SELECT intervalo_1h
    ,concluidas / CONVERT(FLOAT, (concluidas + Incompletas + Canceladas)) AS 'perc_concluidas'
    ,incompletas / CONVERT(FLOAT, (concluidas + Incompletas + Canceladas)) AS 'perc_incompletas'
    ,canceladas / CONVERT(FLOAT, (concluidas + Incompletas + Canceladas)) AS 'perc_canceladas'
    ,CASE WHEN intervalo_1h BETWEEN '16:00:00' AND '19:00:00' THEN 1 ELSE NULL END AS 'flag_intervalo'
FROM cte
ORDER BY intervalo_1h;
GO



-- Slide 7: Nem sempre mais corridas significam mais receita

-- Análise mensal das viagens concluídas
-- Levantando o total de corridas e a receita por mês, afim de entender a sazonalidade do negócio

SELECT CASE WHEN MONTH(data) = 1 THEN 'Jan'
            WHEN MONTH(data) = 2 THEN 'Fev'
            WHEN MONTH(data) = 3 THEN 'Mar'
            WHEN MONTH(data) = 4 THEN 'Abr'
            WHEN MONTH(data) = 5 THEN 'Mai'
            WHEN MONTH(data) = 6 THEN 'Jun'
            WHEN MONTH(data) = 7 THEN 'Jul'
            WHEN MONTH(data) = 8 THEN 'Ago'
            WHEN MONTH(data) = 9 THEN 'Set'
            WHEN MONTH(data) = 10 THEN 'Out'
            WHEN MONTH(data) = 11 THEN 'Nov'
            WHEN MONTH(data) = 12 THEN 'Dez' END AS 'mes'
    ,COUNT(*) AS 'total_de_corridas'
    ,SUM(booking_value) AS 'receita'
FROM dbo.tb_uber_ride_analytics
WHERE booking_status = 'Completed'
GROUP BY MONTH(data) -- Não se faz necessário aplicar o CASE WHEN pois só precisa do mês
ORDER BY MONTH(data); -- Não se faz necessário aplicar o CASE WHEN pois só precisa do mês
GO



-- Análise mensal das viagens concluídas
-- Levantando o ticket médio, a distância média percorrida por mês e a distância média total
-- A distância média total é calculada utilizando a função de janela AVG() OVER()
SELECT CASE WHEN MONTH(data) = 1 THEN 'Jan'
            WHEN MONTH(data) = 2 THEN 'Fev'
            WHEN MONTH(data) = 3 THEN 'Mar'
            WHEN MONTH(data) = 4 THEN 'Abr'
            WHEN MONTH(data) = 5 THEN 'Mai'
            WHEN MONTH(data) = 6 THEN 'Jun'
            WHEN MONTH(data) = 7 THEN 'Jul'
            WHEN MONTH(data) = 8 THEN 'Ago'
            WHEN MONTH(data) = 9 THEN 'Set'
            WHEN MONTH(data) = 10 THEN 'Out'
            WHEN MONTH(data) = 11 THEN 'Nov'
            WHEN MONTH(data) = 12 THEN 'Dez' END AS 'mes'
    ,AVG(booking_value) AS 'ticket_medio_mes'
    ,AVG(ride_distance) AS 'distancia_media_percorrida_mes'
    ,AVG(AVG(ride_distance)) OVER() AS 'distancia_media_percorrida_ano'
    ,AVG(AVG(booking_value)) OVER() AS 'ticket_medio_ano'
FROM dbo.tb_uber_ride_analytics
WHERE booking_status = 'Completed'
GROUP BY MONTH(data) -- Não se faz necessário aplicar o CASE WHEN pois só precisa do mês
ORDER BY MONTH(data); -- Não se faz necessário aplicar o CASE WHEN pois só precisa do mês
GO


-- Slide 8: Análise de Corridas por Tipo de Veículo

-- Análise de corridas por tipo de veículo
-- Levantando o total de corridas, receita, ticket médio e percentual de corridas por tipo de veículo
SELECT vehicle_type
    ,COUNT(*) AS 'total_de_corridas'
    ,SUM(booking_value) AS 'receita'
    ,AVG(booking_value) AS 'ticket_medio'
    ,REPLACE(CONVERT(VARCHAR, ROUND(((CONVERT(FLOAT, COUNT(*)) / SUM(COUNT(*)) OVER()) * 100),2)), '.', ',') + '%' AS 'percentual_de_corridas'
FROM dbo.tb_uber_ride_analytics
GROUP BY vehicle_type
ORDER BY COUNT(*) DESC;

-- Calculando o ticket médio geral e distância média geral nos meses de Janeiro, Julho e Outubro
WITH base AS (
SELECT CASE WHEN MONTH(data) = 1 THEN 'Jan'
            WHEN MONTH(data) = 2 THEN 'Fev'
            WHEN MONTH(data) = 3 THEN 'Mar'
            WHEN MONTH(data) = 4 THEN 'Abr'
            WHEN MONTH(data) = 5 THEN 'Mai'
            WHEN MONTH(data) = 6 THEN 'Jun'
            WHEN MONTH(data) = 7 THEN 'Jul'
            WHEN MONTH(data) = 8 THEN 'Ago'
            WHEN MONTH(data) = 9 THEN 'Set'
            WHEN MONTH(data) = 10 THEN 'Out'
            WHEN MONTH(data) = 11 THEN 'Nov'
            WHEN MONTH(data) = 12 THEN 'Dez' END AS 'mes'
    ,SUM(booking_value) AS 'receita_total'
    ,COUNT(*) AS 'total_de_corridas'
    ,SUM(ride_distance) AS 'ride_distance'
    ,AVG(AVG(booking_value)) OVER() 'ticket_medio'
    ,AVG(AVG(ride_distance)) OVER() 'distancia_media'
FROM dbo.tb_uber_ride_analytics
WHERE booking_status = 'Completed'
GROUP BY MONTH(data) -- Não se faz necessário aplicar o CASE WHEN pois só precisa do mês
)

,base_final AS (
SELECT 'Jan, Jul, Out' AS 'meses'
,SUM(receita_total) / SUM(total_de_corridas) AS 'ticket_medio_meses'
,SUM(ride_distance) / SUM(total_de_corridas) AS 'distancia_media_meses'
,ticket_medio AS 'ticket_medio_ano'
,distancia_media AS 'distancia_media_ano'
FROM base
WHERE mes IN('Jan', 'Jul', 'Out')
GROUP BY ticket_medio
    ,distancia_media
)
SELECT meses
    ,REPLACE(CONVERT(VARCHAR, ROUND(((ticket_medio_meses / ticket_medio_ano) - 1) * 100,2)), '.', ',') + '%' AS 'dif_ticket_medio'
    ,REPLACE(CONVERT(VARCHAR, ROUND(((distancia_media_meses / distancia_media_ano) - 1) * 100,2)), '.', ',') + '%' AS 'dif_distancia_media'
FROM base_final