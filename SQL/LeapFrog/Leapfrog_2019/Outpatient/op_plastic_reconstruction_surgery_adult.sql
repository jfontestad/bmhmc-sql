/*
***********************************************************************
File: op_plastic_reconstruction_srugery_adult.sql

Input Parameters:
	None

Tables/Views:
	SMSDSS.BMH_PLM_PtAcct_V
	SMSDSS.BMH_PLM_PtAcct_Clasf_Proc_V_New
	SMSDSS.BMH_UserTwoFact_V AS D
	SMSDSS.BMH_UserTwoField_Dim_V

Creates Table:
	None

Functions:
	None

Author: Steven P Sanderson II, MPH

Department: Finance, Revenue Cycle

Purpose/Description
	Pull adult/peds cases for adult plastic reconstruction surgery procedures 2019 op lf

Revision History:
Date		Version		Description
----		----		----
2019-06-04	v1			Initial Creation
2019-06-27	v2			Add CCSParent_Description
***********************************************************************
*/

SELECT PAV.Med_Rec_No
, PAV.PtNo_Num
, E.UserDataCd
, D.UserDataText AS 'ORSOS_CASE_NO'
, PAV.Adm_Date
, pvn.ClasfCd
, 'Plastic_Reconstruction_Surgery_Adult' AS 'LeapFrog_Procedure_Group'
, CCS.[Description] AS 'CCS_Description'
, CCSParent.[Description] AS 'CCSParent_Description'

FROM SMSDSS.BMH_PLM_PtAcct_V AS PAV
INNER JOIN SMSDSS.BMH_PLM_PtAcct_Clasf_Proc_V_New AS PVN
ON PAV.Pt_No = PVN.Pt_No
	AND (
		PVN.ClasfCd BETWEEN '19316' AND '19380' OR 
		PVN.ClasfCd BETWEEN '20926' AND '20926'
	)
INNER JOIN SMSDSS.BMH_UserTwoFact_V AS D
ON PAV.PtNo_Num = D.PtNo_Num
	AND D.UserDataKey = '571'
LEFT OUTER JOIN SMSDSS.BMH_UserTwoField_Dim_V AS E
ON D.UserDataKey = E.UserTwoKey

CROSS APPLY (
	SELECT
		CASE
			WHEN PVN.CLASFCD BETWEEN '19316' AND '19380' THEN 'Other OR therapeutic procedures on skin and breast'
			WHEN PVN.CLASFCD BETWEEN '20926' AND '20926' THEN 'Other OR therapeutic procedures on skin and breast'
		END AS 'Description'
) AS CCS

CROSS APPLY (
	SELECT
		CASE
			WHEN PVN.CLASFCD BETWEEN '19316' AND '19380' THEN 'Breast Repair or Reconstruction'
			WHEN PVN.CLASFCD BETWEEN '20926' AND '20926' THEN 'Musculoskeletal Grafts or Implants '
		END AS 'Description'
) AS CCSParent

WHERE PAV.Pt_Age >= 18
AND PAV.tot_chg_amt > 0
AND LEFT(PAV.PTNO_NUM, 1) NOT IN ('2', '8')
AND LEFT(PAV.PTNO_NUM, 4) != '1999'
AND PAV.Adm_Date >= '2018-01-01'
AND PAV.Adm_Date < '2019-01-01'
AND PAV.Plm_Pt_Acct_Type != 'I'

ORDER BY PAV.PtNo_Num