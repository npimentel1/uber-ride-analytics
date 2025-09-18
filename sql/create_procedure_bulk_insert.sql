SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_uber_ride_analytics] AS 

SET NOCOUNT ON

-- Criando a tabela temporária que vai receber os dados
IF OBJECT_ID('tempdb..#base') IS NOT NULL DROP TABLE #base
    CREATE TABLE #base (
         [Date]                              VARCHAR(300)
        ,[Time]                              VARCHAR(300)
        ,[Booking ID]                        VARCHAR(300)
        ,[Booking Status]                    VARCHAR(300)
        ,[Customer ID]                       VARCHAR(300)
        ,[Vehicle Type]                      VARCHAR(300)
        ,[Pickup Location]                   VARCHAR(300)
        ,[Drop Location]                     VARCHAR(300)
        ,[Avg VTAT]                          VARCHAR(300)
        ,[Avg CTAT]                          VARCHAR(300)
        ,[Cancelled Rides by Customer]       VARCHAR(300)
        ,[Reason for cancelling by Customer] VARCHAR(300)
        ,[Cancelled Rides by Driver]         VARCHAR(300)
        ,[Driver Cancellation Reason]        VARCHAR(300)
        ,[Incomplete Rides]                  VARCHAR(300)
        ,[Incomplete Rides Reason]           VARCHAR(300)
        ,[Booking Value]                     VARCHAR(300)
        ,[Ride Distance]                     VARCHAR(300)
        ,[Driver Ratings]                    VARCHAR(300)
        ,[Customer Rating]                   VARCHAR(300)
        ,[Payment Method]                    VARCHAR(300)
    )
BULK INSERT #base
FROM 'C:\Estudos\Portfolio\Github\uber-ride-analytics\data\base_uber.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Criando colunas auxiliares e tratando os dados para inserir na tabela final
IF OBJECT_ID('tempdb..#base_tratada') IS NOT NULL DROP TABLE #base_tratada
SELECT CONVERT(DATE, Date) AS 'data'
    , CONVERT(TIME, Time) AS 'hora'
    , DATEPART(ISO_WEEK, date) AS 'semana_iso'
    , MONTH(date) AS 'mes'
    , YEAR(date) AS 'ano'
    , CONVERT(TIME, DATEADD(MINUTE, CASE WHEN DATEPART(MINUTE, time) BETWEEN 0 AND 29 THEN 0 ELSE 30 END, DATEADD(HOUR, DATEPART(HOUR, time), '00:00:00'))) AS 'intervalo'
    , REPLACE([Booking ID], '"', '') AS 'booking_id'
    , [Booking Status] AS 'booking_status'
    , REPLACE([Customer ID], '"', '') AS 'customer_id'
    , [Vehicle Type] AS 'vehicle_type'
    , [Pickup Location] AS 'pickup_location'
    , [Drop Location] AS 'drop_location'
    , CONVERT(FLOAT, [Avg VTAT]) AS 'avg_vtat'
    , CONVERT(FLOAT, [Avg CTAT]) AS 'avg_ctat'
    , CONVERT(INT, CONVERT(FLOAT, [Cancelled Rides by Customer])) AS 'cancelled_rides_by_customer'
    , [Reason for cancelling by Customer] AS 'reason_for_cancelling_by_customer'
    , CONVERT(INT, CONVERT(FLOAT, [Cancelled Rides by Driver])) AS 'cancelled_rides_by_driver'
    , [Driver Cancellation Reason] AS 'driver_cancellation_reason'
    , CONVERT(INT, CONVERT(FLOAT, [Incomplete Rides])) AS 'incomplete_rides'
    , [Incomplete Rides Reason] AS 'incomplete_rides_reason'
    , CONVERT(FLOAT, [Booking Value]) AS 'booking_value'
    , CONVERT(FLOAT, [Ride Distance]) AS 'ride_distance'
    , CONVERT(FLOAT, [Driver Ratings]) AS 'driver_ratings'
    , CONVERT(FLOAT, [Customer Rating]) AS 'customer_rating'
    , [Payment Method] AS 'payment_method'
INTO #base_tratada
FROM #base

-- Iniciando uma transação para inserir os dados na tabela final
BEGIN TRANSACTION

    BEGIN TRY
        -- Deletando registros já existentes na tabela (processo criado para reprocessar a carga, se necessário)
        DELETE a
        FROM [dbo].[tb_uber_ride_analytics] AS a
        INNER JOIN #base_tratada AS b
            ON b.data = a.data
                AND b.hora = a.hora
                AND b.booking_id = a.booking_id

        -- Inserindo os dados tratados na tabela final
        INSERT [dbo].[tb_uber_ride_analytics]
        SELECT data
            ,hora
            ,semana_iso
            ,mes
            ,ano
            ,intervalo
            ,booking_id
            ,booking_status
            ,customer_id
            ,vehicle_type
            ,pickup_location
            ,drop_location
            ,avg_vtat
            ,avg_ctat
            ,cancelled_rides_by_customer
            ,reason_for_cancelling_by_customer
            ,cancelled_rides_by_driver
            ,driver_cancellation_reason
            ,incomplete_rides
            ,incomplete_rides_reason
            ,booking_value
            ,ride_distance
            ,driver_ratings
            ,customer_rating
            ,payment_method
        FROM #base_tratada

        COMMIT

    END TRY

    BEGIN CATCH

        PRINT 'Processo não executado. Ocorreu um erro na carga dos dados.'
        ROLLBACK
    
    END CATCH