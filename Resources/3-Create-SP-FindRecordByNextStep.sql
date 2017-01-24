USE [orchestrator]
GO

/****** Object:  StoredProcedure [dbo].[FindRecordByNextStep]    Script Date: 12/29/2016 2:47:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[FindRecordByNextStep]

	@NextStep	varchar(max)

AS

BEGIN

SELECT [RequestGuid],
	[Approver],
	[RequesterMail],
	[RequesterName],
	[DisplayName],
	[Unique_User_Name0],
	[NetBios_Name0],
	[Comments],
	[CurrentState],
	[NextStep]

FROM [dbo].[sccmapprequests] 

WHERE NextStep = @NextStep

END

GO

