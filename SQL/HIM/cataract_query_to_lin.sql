SELECT B.Pt_Name
, B.Pt_Birthdate
, B.Med_Rec_No
, A.pt_id
, A.proc_eff_date
, A.proc_cd
, A.proc_cd_modf1

INTO #TEMPA

FROM smsmir.sproc AS A
LEFT JOIN smsdss.BMH_PLM_PtAcct_V AS B
ON A.PT_ID = B.Pt_No

WHERE A.proc_eff_date >= dateadd(MM, datediff(MM, 0, GETDATE()), 0)
AND A.proc_cd IN ('66820', '66821', '66830', '66982', '66983', '66984')
AND LEFT(pt_id, 4) = '0000'

ORDER BY B.MED_REC_NO
, A.proc_eff_date;

-----

DECLARE @T1 TABLE (
	PT_NAME VARCHAR(100)
	, PT_BIRTHDATE DATETIME
	, MED_REC_NO VARCHAR(10)
	, PT_ID VARCHAR(12)
	, PROC_EFF_DATE DATETIME
	, PROC_CD VARCHAR(15)
	, PROC_CD_MODF1 VARCHAR(20)
);

WITH CTE1 AS (
	SELECT A.*

	FROM #TEMPA AS A

	UNION

	SELECT B.Pt_Name
	, B.Pt_Birthdate
	, B.Med_Rec_No
	, A.pt_id
	, A.proc_eff_date
	, A.proc_cd
	, A.proc_cd_modf1

	FROM smsmir.sproc AS A
	LEFT JOIN smsdss.BMH_PLM_PtAcct_V AS B
	ON A.PT_ID = B.Pt_No

	WHERE B.Med_Rec_No IN (
		SELECT ZZZ.Med_Rec_No
		FROM #TEMPA AS ZZZ
	)
	AND A.pt_id NOT IN (
		SELECT ZZZ.PT_ID
		FROM #TEMPA AS ZZZ
	)
	AND A.proc_cd IN (
		'66820', '66821', '66830', '66982', '66983', '66984'
	)
	AND LEFT(A.PT_ID, 4) = '0000'
)

INSERT INTO @T1
SELECT * FROM CTE1 
;

SELECT T1.*
, CODERV.Coder
, RN = ROW_NUMBER() OVER(
	PARTITION BY MED_REC_NO
	ORDER BY PROC_EFF_DATE
)
FROM @T1 AS T1
LEFT JOIN smsdss.c_bmh_coder_activity_v AS CODERV
ON T1.PT_ID = CODERV.Patient_ID;


DROP TABLE #TEMPA;