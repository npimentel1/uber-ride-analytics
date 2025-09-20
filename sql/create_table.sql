SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_uber_ride_analytics](
	[data] [date] NOT NULL,
	[hora] [time](7) NOT NULL,
	[semana_iso] [tinyint] NULL,
	[mes] [tinyint] NULL,
	[ano] [smallint] NULL,
	[intervalo] [time](7) NULL,
	[booking_id] [varchar](10) NOT NULL,
	[booking_status] [varchar](25) NULL,
	[customer_id] [varchar](10) NULL,
	[vehicle_type] [varchar](15) NULL,
	[pickup_location] [varchar](30) NULL,
	[drop_location] [varchar](30) NULL,
	[avg_vtat] [float] NULL,
	[avg_ctat] [float] NULL,
	[cancelled_rides_by_customer] [bit] NULL,
	[reason_for_cancelling_by_customer] [varchar](50) NULL,
	[cancelled_rides_by_driver] [bit] NULL,
	[driver_cancellation_reason] [varchar](50) NULL,
	[incomplete_rides] [bit] NULL,
	[incomplete_rides_reason] [varchar](50) NULL,
	[booking_value] [float] NULL,
	[ride_distance] [float] NULL,
	[driver_ratings] [float] NULL,
	[customer_rating] [float] NULL,
	[payment_method] [varchar](15) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[tb_uber_ride_analytics] ADD PRIMARY KEY CLUSTERED 
(
	[data] ASC,
	[hora] ASC,
	[booking_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
