/*
THIS REPORT IS FOR SOUND PHYSICIAN, IT WILL BE USED ON A MONTHLY
BASIS GOING FORWARD IN ORDER FOR THEIR INTERNAL BENCHMARKING
*/
SET ANSI_NULLS OFF
GO
-- VARIABLE DECLARATION AND INITIALIZATION
DECLARE @SD DATETIME;
DECLARE @ED DATETIME;
SET @SD = '2014-01-01';
SET @ED = '2014-01-31';

/*
-----------------------------------------------------------------------
THIS QUERY WILL GET ALL THE FRONT END INFORMATION REQUIRED FOR HOSIM
AND INSERT IT INTO A TABLE THAT WILL GET MATCHED UP WITH THE DISCHARGE
ORDERS TABLE
-----------------------------------------------------------------------
START OF QUERY 1
-----------------------------------------------------------------------
*/
-- TABLE DECLARATION
DECLARE @T1 TABLE (
	[ENCOUNTER ID] VARCHAR(200)
	, FINANCIALCLASSORIG VARCHAR(200)
	, [ADMIT DATE] DATE
	, [ADMIT MONTH] VARCHAR(10)
	, [ADMIT DAY] VARCHAR(10)
	, [ADMIT YEAR] VARCHAR(10)
	, [ADMIT TIME] TIME
	, [ADMIT HOUR] VARCHAR(10)
	, [ADMIT FROM] VARCHAR(200)
	, [DISCHARGE DATE] DATE
	, [DISCHARGE MONTH] VARCHAR(10)
	, [DISCHARGE DAY] VARCHAR(10)
	, [DISCHARGE YEAR] VARCHAR(10)
	, [DISCHARGE TIME] TIME
	, [DISCHARGE HOUR] VARCHAR(10)
	, [MS DRG] VARCHAR(200)
	, LOS VARCHAR(20)
	, [ADMIT PATIENT STATUS] VARCHAR (10)
	, [DISCHARGE PATIENT STATUS] VARCHAR(10)
	, [DISCHARGE DISPOSITION] VARCHAR (200)
	, [DISCHARGE UNIT] VARCHAR (200)
)
-- WHAT GETS INSERTED INTO @T1
INSERT INTO @T1
SELECT
A.[VISIT ID]
, A.FINANCIALCLASSORIG
, A.[ADMIT DATE]
, A.[ADMIT MONTH]
, A.[ADMIT DAY]
, A.[ADMIT YEAR]
, A.[ADMIT TIME]
, A.[ADMIT HOUR]
, A.[ADMIT FROM]
, A.[DISCHARGE DATE]
, A.[DISCHARGE MONTH]
, A.[DISCHARGE DAY]
, A.[DISCHARGE YEAR]
, A.[DISCHARGE TIME]
, A.[DISCHARGE HOUR]
, A.[MS DRG]
, A.LOS
, A.[ADMIT PATIENT STATUS]
, A.[DISCHARGE PATIENT STATUS]
, A.[DISCHARGE DISPOSITION]
, A.[DISCHARGE UNIT]
-- END @T1 INSERT SELECTION

-- WHERE IT ALL COMES FROM
-- COLUMN SELECTION
FROM (
	SELECT DISTINCT PAV.PtNo_Num AS [VISIT ID]
	, PD.pyr_name AS [FinancialClassOrig]
	, CAST(PAV.Adm_Date AS DATE) AS [ADMIT DATE]
	, DATEPART(MONTH, PAV.Adm_Date) AS [ADMIT MONTH]
	, DATEPART(DAY, PAV.Adm_Date) AS [ADMIT DAY]
	, DATEPART(YEAR, PAV.Adm_Date) AS [ADMIT YEAR]
	, CAST(PAV.vst_start_dtime AS TIME) AS [ADMIT TIME]
	, DATEPART(HOUR, PAV.vst_start_dtime) AS [ADMIT HOUR]
	, PAV.Adm_Source AS [ADMIT FROM]
	, CAST(PAV.Dsch_Date AS DATE) AS [DISCHARGE DATE]
	, DATEPART(MONTH, PAV.DSCH_DATE) AS [DISCHARGE MONTH]
	, DATEPART(DAY, PAV.DSCH_DATE) AS [DISCHARGE DAY]
	, DATEPART(YEAR, PAV.DSCH_DATE) AS [DISCHARGE YEAR]
	, CAST(PAV.Dsch_DTime AS TIME) AS [DISCHARGE TIME]
	, DATEPART(HOUR, PAV.DSCH_DTIME) AS [DISCHARGE HOUR]
	, PAV.drg_no AS [MS DRG]
	, PAV.Days_Stay AS [LOS]
	, 'I' AS [ADMIT PATIENT STATUS]
	, 'I' AS [DISCHARGE PATIENT STATUS]
	, DDM.dsch_disp_desc AS [DISCHARGE DISPOSITION]
	, VR.ward_cd AS [DISCHARGE UNIT]

	-- FROM DB(S)
	FROM smsdss.BMH_PLM_PtAcct_V PAV
	JOIN smsdss.pract_dim_v PDV
	ON PAV.Adm_Dr_No = PDV.src_pract_no
	JOIN smsdss.pyr_dim PD
	ON PAV.Pyr1_Co_Plan_Cd = PD.pyr_cd
	JOIN smsmir.vst_rpt VR
	ON PAV.PtNo_Num = VR.acct_no
	JOIN smsdss.dsch_disp_mstr DDM
	ON VR.dsch_disp = DDM.dsch_disp

	-- FILTER(S)
	WHERE PAV.Dsch_Date BETWEEN @SD AND @ED
	AND PAV.Plm_Pt_Acct_Type = 'I'
	AND PAV.PtNo_Num < '20000000'
	AND PDV.src_spclty_cd = 'HOSIM'
	AND PD.orgz_cd = 'S0X0'
	AND PD.pyr_name != '?'
) A

--SELECT * FROM @T1
/*
-----------------------------------------------------------------------
END OF QUERY ONE (1)
-----------------------------------------------------------------------
*/
--#####################################################################
/*
-----------------------------------------------------------------------
START OF QUERY TWO (2)
-----------------------------------------------------------------------
*/
-- @T2 DECLARATION
DECLARE @T2 TABLE (
	[ENCOUNTER ID] VARCHAR(200)
	, [ORDER NUMBER] VARCHAR(200)
	, [ORDER DATE] DATE
	, [ORDER MONTH] VARCHAR(10)
	, [ORDER DAY] VARCHAR(10)
	, [ORDER YEAR] VARCHAR(10)
	, [ORDER TIME] TIME
	, [ORDER HOUR] VARCHAR(10)
)

-- WHAT GETS INSERTED INTO @T2
INSERT INTO @T2
SELECT
B.episode_no
, B.ord_no
, B.DATE
, B.[ORDER MONTH]
, B.[ORDER DAY]
, B.[ORDER YEAR]
, B.TIME
, B.[ORDER HOUR]


-- WHERE IT ALL COMES FROM
FROM (
	SELECT EPISODE_NO
	, ORD_NO
	, CAST(ENT_DTIME AS DATE) AS [DATE]
	, DATEPART(MONTH, ENT_DTIME) AS [ORDER MONTH]
	, DATEPART(DAY, ent_dtime) AS [ORDER DAY]
	, DATEPART(YEAR, ENT_DTIME) AS [ORDER YEAR]
	, CAST(ENT_DTIME AS TIME) AS [TIME]
	, DATEPART(HOUR, ENT_DTIME) AS [ORDER HOUR]
	, ROW_NUMBER() OVER(
						PARTITION BY EPISODE_NO ORDER BY ORD_NO
						) AS ROWNUM
	FROM smsmir.sr_ord
	WHERE svc_desc = 'DISCHARGE TO'
	AND episode_no < '20000000'
) B

WHERE B.ROWNUM = 1

--SELECT * FROM @T2
/*
-----------------------------------------------------------------------
END OF QUERY TWO (2)
-----------------------------------------------------------------------
*/
/*
-----------------------------------------------------------------------
QUERY THREE (3)
-----------------------------------------------------------------------
*/
-- TABLE 3 DECLARATION
DECLARE @T3 TABLE (
	[ENCOUNTER 3] VARCHAR(200)
	, [HAS ICU VISIT] VARCHAR(10)
)
-- WHAT GETS INSERTED INTO @T3
INSERT INTO @T3
SELECT
C.pt_no
,C.HAS_ICU_VISIT

-- WHERE IT ALL COMES FROM
FROM (
	SELECT DISTINCT PVFV.pt_no
	, MAX(CASE
			WHEN TXFR.NURS_STA IN ('SICU','MICU','CCU')
			THEN 'Y'
			ELSE 'N'
		  END)
		  OVER (PARTITION BY PVFV.PT_NO) AS HAS_ICU_VISIT

	FROM @T1 T1
	JOIN smsdss.pms_vst_fct_v PVFV
	ON T1.[ENCOUNTER ID] = PVFV.pt_no
	JOIN SMSDSS.PMS_XFER_ACTV_FCT_V TXFR
	ON PVFV.pms_vst_key = TXFR.pms_vst_key

WHERE PVFV.vst_end_date BETWEEN @SD AND @ED
) C

/*
-----------------------------------------------------------------------
END OF QUERY THREE (3)
-----------------------------------------------------------------------
*/
--#####################################################################
/*
-----------------------------------------------------------------------
PUTTING IT ALL TOGETHER NOW
-----------------------------------------------------------------------
*/

SELECT T1.FINANCIALCLASSORIG
, T1.[ADMIT DATE]
, T1.[ADMIT MONTH]
, T1.[ADMIT DAY]
, T1.[ADMIT YEAR]
, T1.[ADMIT TIME]
, T1.[ADMIT HOUR]
, T1.[ADMIT FROM]
, T1.[DISCHARGE DATE]
, T1.[DISCHARGE MONTH]
, T1.[DISCHARGE DAY]
, T1.[DISCHARGE YEAR]
, T1.[DISCHARGE TIME]
, T1.[DISCHARGE HOUR]
, ISNULL(T2.[ORDER DATE], '1800-01-01') AS [ORDER DATE]
, ISNULL(T2.[ORDER MONTH], 'NO MONTH') AS [ORDER MONTH]
, ISNULL(T2.[ORDER DAY], 'NO DAY') AS [ORDER DAY]
, ISNULL(T2.[ORDER YEAR], 'NO YEAR') AS [ORDER YEAR]
, ISNULL(T2.[ORDER TIME], '00:00:00') AS [ORDER TIME]
, ISNULL(T2.[ORDER HOUR], 'NO HOUR') AS [ORDER HOUR]
, T1.[DISCHARGE DISPOSITION]
, T1.[DISCHARGE UNIT]
, T1.[MS DRG]
, T1.LOS
, T1.[ADMIT PATIENT STATUS]
, T1.[DISCHARGE PATIENT STATUS]
, T3.[HAS ICU VISIT]


FROM @T1 T1
LEFT JOIN @T2 T2
ON T1.[ENCOUNTER ID] = T2.[ENCOUNTER ID]
JOIN @T3 T3
ON T1.[ENCOUNTER ID] = T3.[ENCOUNTER 3]

