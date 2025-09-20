-- Algumas estatísticas sobre a tabela
WITH vehicle_mvp AS (
    SELECT vehicle_type
        ,COUNT(*) AS total_corridas
    FROM dbo.tb_uber_ride_analytics
    GROUP BY vehicle_type
)

, payment_method_mvp AS (
    SELECT payment_method
        ,COUNT(*) AS total_corridas
    FROM dbo.tb_uber_ride_analytics
    WHERE payment_method IS NOT NULL
    GROUP BY payment_method
)

SELECT COUNT(*) AS total_corridas
    , COUNT(DISTINCT booking_id) AS corridas_unicas
    , SUM(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END) / CONVERT(FLOAT, COUNT(*)) * 100 AS perc_concluidas
    , SUM(CASE WHEN booking_status IN('Cancelled by Driver', 'Cancelled by Customer') THEN 1 ELSE 0 END) / CONVERT(FLOAT, COUNT(*)) * 100 AS perc_canceladas
    , (SELECT TOP 1 vehicle_type FROM vehicle_mvp ORDER BY total_corridas DESC) AS vehicle_mvp
    , (SELECT TOP 1 payment_method FROM payment_method_mvp ORDER BY total_corridas DESC) AS payment_method_mvp
FROM dbo.tb_uber_ride_analytics
