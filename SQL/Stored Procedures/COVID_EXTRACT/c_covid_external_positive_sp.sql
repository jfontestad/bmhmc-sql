USE [SMSPHDSSS0X0]
GO

SET ANSI_NULLS ON
GO
SET ANSI_WARNINGS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
***********************************************************************
File: c_covid_external_positive_sp.sql

Input Parameters:
	None

Tables/Views:
	smsdss.c_covid_external_positive_tbl
	[SC_server].[Soarian_Clin_Prd_1].DBO.HPatientVisit

Creates Table:
	smsdss.c_covid_ext_pos_tbl

Functions:
	None

Author: Steven P Sanderson II, MPH

Department: Finance, Revenue Cycle

Purpose/Description
	Get external positive results

Revision History:
Date		Version		Description
----		----		----
2020-07-07	v1			Initial Creation
***********************************************************************
*/

CREATE PROCEDURE [dbo].[c_covid_external_positive_sp]
AS

	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON
	SET QUOTED_IDENTIFIER ON

BEGIN
	
	SET NOCOUNT ON;
	-- Create a new table called 'c_covid_ext_pos_tbl' in schema 'smsdss'
	-- Drop the table if it already exists
	IF OBJECT_ID('smsdss.c_covid_ext_pos_tbl', 'U') IS NOT NULL
	DROP TABLE smsdss.c_covid_ext_pos_tbl;

	/*
	Positive External Results
	*/
	DECLARE @ExtPos TABLE (
		PatientVisitOID INT,
		PatientAccountID INT,
		Test_Date DATETIME2,
		Result VARCHAR(50)
		)

	INSERT INTO @ExtPos
	SELECT B.ObjectID,
		A.Acct#,
		A.[Test Date],
		A.[Status]
	FROM smsdss.c_covid_external_positive_tbl AS A
	INNER JOIN [SC_server].[Soarian_Clin_Prd_1].DBO.HPatientVisit AS B ON A.ACCT# = B.PatientAccountID;

	SELECT *
	INTO smsdss.c_covid_ext_pos_tbl
	FROM @ExtPos;

END;