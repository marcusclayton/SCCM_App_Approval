USE [orchestrator]
GO

/****** Object:  StoredProcedure [dbo].[UpdateRecord]    Script Date: 12/29/2016 2:48:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[UpdateRecord]

	@RequestGuid	varchar(max),
	@NextStep		varchar (max)
AS

BEGIN

UPDATE sccmapprequests

SET		NextStep = @NextStep,
		LastModified = GETDATE()

WHERE RequestGuid = @RequestGuid

END

GO


