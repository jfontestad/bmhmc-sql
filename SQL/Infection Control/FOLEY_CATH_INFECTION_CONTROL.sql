-- FOLEY CATHETER ORDERS

-- VARIABLE DECLARATION AND INITIALIZATION
DECLARE @SD DATETIME
DECLARE @ED DATETIME
SET @SD = '2014-04-01';
SET @ED = '2014-05-01';

-- COLUMN SELECTION
WITH flagged AS (
    SELECT PV.PTNO_NUM
    , PV.MED_REC_NO
    , PV.VST_START_DTIME
    , PV.VST_END_DTIME
    , PV.DAYS_STAY
    , PV.PT_TYPE
    , PV.HOSP_SVC
    , SO.ORD_NO
    , X.[ORD DESC] -- <-- THE CROSS APPLY STATEMENT
    , CASE
		WHEN OSM.ord_sts = 'ACTIVE'      THEN '1 - ACTIVE'
		WHEN OSM.ord_sts = 'IN PROGRESS' THEN '2 - IN PROGRESS'
		WHEN OSM.ord_sts = 'COMPLETE'    THEN '3 - COMPLETE'
		WHEN OSM.ord_sts = 'CANCEL'      THEN '4 - CANCEL'
		WHEN OSM.ord_sts = 'DISCONTINUE' THEN '5 - DISCONTINUE'
		WHEN OSM.ord_sts = 'SUSPEND'     THEN '6 - SUSPEND'
	  END AS [ORDER STATUS]
	, SOS.prcs_dtime AS 'ORDER STATUS TIME'
	, DATEDIFF(DAY,PV.vst_start_dtime,SOS.prcs_dtime) AS [ADM TO ORD STS IN DAYS]
	-- THE FOLLOWING ARE FLAGS THAT WILL PRODUCE A 1 OR 0 IF THE PT HAS RECEIVED
	-- A SPECIFIED TEST
	, MAX(CASE WHEN [ORD DESC] LIKE 'URIN%' THEN 1 ELSE 0 END)
		OVER (PARTITION BY PV.PTNO_NUM) AS HasUrineTest
	, MAX(CASE WHEN [ORD DESC] IN ('INSERT FOLEY', 'REMOVE FOLEY') THEN 1 ELSE 0 END)
		OVER (PARTITION BY PV.PTNO_NUM) AS HasInsertRemoveFoley
	
	-- DB(S) USED AND JOIN STATEMENTS
	FROM smsdss.BMH_PLM_PtAcct_V               PV
		JOIN smsmir.sr_ord                     SO
		ON PV.PtNo_Num = SO.episode_no
		JOIN smsmir.sr_ord_sts_hist            SOS
		ON SO.ord_no = SOS.ord_no
		JOIN smsmir.ord_sts_modf_mstr          OSM
		ON SOS.hist_sts = OSM.ord_sts_modf_cd
	
	-- CROSS APPLY STATEMENT USED ON THE CASE STATEMENT FOR THE MAX(OVER()) WINDOW FUNCTION
	CROSS APPLY (
		SELECT
			CASE
				WHEN SO.svc_desc = 'INSERT FOLEY CATHETER' 
				THEN 'INSERT FOLEY'
				WHEN SO.svc_desc = 'INSERT INDWELLING URINARY CATHETER TO GRAVITY DRAINAGE' 
				THEN 'INSERT FOLEY'
				WHEN SO.svc_desc = 'REMOVE INDWELLING URINARY CATHETER' 
				THEN 'REMOVE FOLEY'
				ELSE SO.svc_desc
			END AS [ORD DESC]
			) X

	-- FILTERS
	WHERE PV.Adm_Date >= @SD 
	AND PV.Adm_Date < @ED
	-- THE ORDER DESCRIPTORS YOU ARE LOOKING FOR
	AND (SO.svc_desc LIKE 'INSERT FOLEY CATHETER'
		OR SO.svc_desc LIKE 'INSERT INDWELLING URINARY CATHETER TO GRAVITY DRAINAGE'
		OR SO.svc_desc LIKE 'REMOVE INDWELLING URINARY CATHETER'
		OR SO.svc_desc LIKE 'URIN%'
		)
	-- DECLARING WHAT HOSPITAL SERVICE A PATIENT SHOULD NOT BE PART OF
	AND PV.hosp_svc NOT IN (
		'DIA'
		,'DMS'
		,'EME'
		)
	-- THIS WILL KICK OUT ALL ORDERS THAT HAVE BEEN DISCONTINUED, FOR EXAMPLE:
	-- IF AN ORDER FOR A 'REMOVE FOLEY CATHETER' IS DISCONTINUED OR CANCELLED
	-- THEN THAT ORDER IN ITS ENTIRETY WILL BE KICKED OUT
	AND SO.ord_no NOT IN (
		-- THE COLUMN WE ARE LOOKING AT THAT WILL ULTIMATELY BE REJECTED
		SELECT SO.ord_no
		-- DB(S) USED
		FROM smsdss.BMH_PLM_PtAcct_V               PV
			JOIN smsmir.sr_ord                     SO
			ON PV.PtNo_Num = SO.episode_no
			JOIN smsmir.sr_ord_sts_hist            SOS
			ON SO.ord_no = SOS.ord_no
			JOIN smsmir.ord_sts_modf_mstr          OSM
			ON SOS.hist_sts = OSM.ord_sts_modf_cd
		-- THE FILTER THAT SAYS WHAT TO EXCLUDE FROM OUR RESULT SET
		WHERE OSM.ord_sts IN (
		'DISCONTINUE'
		, 'CANCEL'
		)
		AND PV.Adm_Date >= @SD
		AND PV.Adm_Date < @ED
		AND (SO.svc_desc LIKE 'INSERT FOLEY CATHETER'
		OR SO.svc_desc LIKE 'INSERT INDWELLING URINARY CATHETER TO GRAVITY DRAINAGE'
		OR SO.svc_desc LIKE 'REMOVE INDWELLING URINARY CATHETER'
		)
	)
)

SELECT *
FROM flagged
WHERE HasUrineTest = 1
AND HasInsertRemoveFoley = 1