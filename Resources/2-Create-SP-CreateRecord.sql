USE [orchestrator]
GO

/****** Object:  StoredProcedure [dbo].[CreateRecord]    Script Date: 12/29/2016 2:46:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[CreateRecord]

	@RequestGuid		varchar (max),
	@Unique_User_Name0	varchar (max),
	@RequesterMail		varchar (max),
	@RequesterName		varchar (max),
	@CurrentState		varchar (max),
	@Comments			varchar (max),
	@DisplayName		varchar (max),
	@Approver			varchar (max),
	@NextStep			varchar (max)

AS

BEGIN

INSERT INTO sccmapprequests
	(
		RequestGuid			,
		Unique_User_Name0	,
		RequesterMail		,
		RequesterName		,
		CurrentState		,
		Comments			,
		DisplayName			,
		Approver			,
		NextStep			,
		LastModified
	)
VALUES
	(
		@RequestGuid		,
		@Unique_User_Name0	,
		@RequesterMail		,
		@RequesterName		,
		@CurrentState		,
		@Comments			,
		@DisplayName		,
		@Approver			,
		@NextStep			,
		GETDATE()

	)

END

GO


