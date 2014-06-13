
-- VARIABLE DECLARATION AND INITIALIZATION
DECLARE @STARTDATE DATETIME;
DECLARE @ENDATE    DATETIME;

SET @STARTDATE = '2010-01-01';
SET @ENDATE =    '2014-06-01';

-- COLUMN SELECTION
SELECT PAV.PtNo_Num           AS [PAV PTNO_NUM]
, PAV.Med_Rec_No, PAV.pt_type AS [PAV PT TYPE]
, PAPV.Bl_Drg_No              AS [NYS DRG NO]
, DRGM.DRGDesc                AS [DRG DESC]
, PSVH.Chg_Qty                AS [QUANTITY]
, PSVH.Svc_Date               AS [SERVICE DATE]

-- DB(S) USED
FROM SMSDSS.BMH_PLM_PTACCT_V              PAV
	JOIN SMSDSS.BMH_PLM_PTACCT_SVC_V_hold PSVH
	ON PAV.PT_NO = PSVH.PT_NO
	JOIN smsdss.BMH_PLM_PtAcct_Payor_V    PAPV
	ON PAV.Pt_Key = PAPV.Pt_Key
	JOIN smsdss.DRGMstr                   DRGM
	ON DRGM.DRGNo = PAPV.Bl_Drg_No

-- FILTERS
WHERE PSVH.Svc_Cd IN (
	'04161253',
	'04161022'
	)
-- '04161253' and '04161022' for RBC's
	AND DRGM.DRGVers = 'MS-V25' 
	AND PAV.pt_type not in ('R', 'E')
	AND PAV.Dsch_Date >= @STARTDATE 
	AND PAV.Dsch_Date < @ENDATE
	AND PAPV.Pt_Acct_Pyr_Seq_No = 1

ORDER BY PSVH.Svc_Date ASC
