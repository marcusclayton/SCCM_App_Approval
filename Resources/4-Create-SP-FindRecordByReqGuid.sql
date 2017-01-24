USE [orchestrator]
GO

/****** Object:  StoredProcedure [dbo].[FindRecordByReqGuid]    Script Date: 12/29/2016 2:48:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[FindRecordByReqGuid]

	@RequestGuid	varchar(max)

AS

BEGIN

SELECT [RequestGuid]

FROM [dbo].[sccmapprequests] 

WHERE RequestGuid = @RequestGuid

END

GO

