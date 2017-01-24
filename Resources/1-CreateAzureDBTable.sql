/****** Object:  Table [dbo].[sccmapprequests]    Script Date: 12/29/2016 2:43:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sccmapprequests](
	[DisplayName] [varchar](max) NULL,
	[Unique_User_Name0] [varchar](max) NULL,
	[Netbios_Name0] [varchar](max) NULL,
	[RequestGuid] [varchar](max) NOT NULL,
	[CurrentState] [varchar](max) NULL,
	[Comments] [varchar](max) NULL,
	[NextStep] [varchar](max) NULL,
	[Approver] [varchar](max) NULL,
	[LastModified] [varchar](max) NULL,
	[RequesterMail] [varchar](max) NULL,
	[RequesterName] [varchar](max) NULL
)

GO


