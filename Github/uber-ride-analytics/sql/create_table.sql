SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_uber_ride_analytics](
    data DATE NOT NULL,
    hora TIME NOT NULL,
    semana_iso TINYINT NULL,
    mes TINYINT NULL,
    ano SMALLINT NULL,
    intervalo TIME NULL,
    booking_id VARCHAR(10) NOT NULL,
    booking_status VARCHAR(25) NULL,
    customer_id VARCHAR(10) NULL,
    vehicle_type VARCHAR(15) NULL,
    pickup_location VARCHAR(30) NULL,
    drop_location VARCHAR(30) NULL,
    avg_vtat FLOAT NULL,
    avg_ctat FLOAT NULL,
    cancelled_rides_by_customer INT NULL,
    reason_for_cancelling_by_customer VARCHAR(50) NULL,
    cancelled_rides_by_driver INT NULL,
    driver_cancellation_reason VARCHAR(50) NULL,
    incomplete_rides INT NULL,
    incomplete_rides_reason VARCHAR(50) NULL,
    booking_value FLOAT NULL,
    ride_distance FLOAT NULL,
    driver_ratings FLOAT NULL,
    customer_rating FLOAT NULL,
    payment_method VARCHAR(15) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_uber_ride_analytics] ADD PRIMARY KEY CLUSTERED -- Índice criado para melhorar a performance das consultas e evitar duplicidade de dados
(
	[data] ASC,
	[hora] ASC,
	[booking_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO