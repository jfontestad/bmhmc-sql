-- SEPSIS PATIENT OVERVIEW FOR ANY SPECIFIED DATE RANGE GIVEN BY THE
-- THE SEPSIS COMMITTEE. ITEMS FOR THIS REPORT INCLUDE THE FOLLOWING:
-- PT(S) WITH A DIAGNOSIS OF SEPSIS, PT NAME, MRN, ACCT NUMBER,
-- ARRIVAL TIME, TRIAGE TIME, DISCHARGE TIME, DISCHARGE DISPOSITION,
-- TIME ORDER(S) WERE PLACED; IN PROGRESS AND COMPLETED FOR IVF, CXR,
-- WBC AND ANITBIOTICS, WAS SEPSIS ORDER SET USED, WAS SEPSIS TEMPLATE
-- USED
--#####################################################################

-- VARIABLE DECLARATION AND INITIALIZATION
DECLARE @STARTDATE DATETIME
DECLARE @ENDATE DATETIME

SET @STARTDATE = '2013-01-01';
SET @ENDATE = '2013-04-30';

-- COLUMN SELECTION
SELECT DISTINCT AFV.ACCT_NO AS 'ACCT NUMBER'
, AFV.rpt_name AS 'PT NAME'
, DAFV.med_rec_no AS 'MED REC NUM'
, AFV.adm_date AS 'ADMIT DATE'
, AFV.dsch_date AS 'DISC DATE'
, PTV.pt_type_cd_desc AS 'PT TYPE DESC'
, LAB.lab_svc_id AS 'LAB SVC ID'


-- DB(S) USED
FROM smsdss.acct_fct_v AFV
JOIN smsdss.acct_sts_dim_v STSV
ON AFV.acct_sts = STSV.acct_sts
JOIN smsdss.pt_type_dim_v PTV
ON AFV.pt_type = PTV.pt_type
JOIN smsdss.dly_acct_fct_v DAFV
ON DAFV.dly_acct_key = AFV.acct_key
JOIN smsdss.BMH_Lab_All_Billing_Transactions_tb LAB
ON AFV.acct_no = LAB.pt_adm_no

-- FILTERS
WHERE AFV.pt_type = 'E'
AND AFV.adm_date BETWEEN @STARTDATE AND @ENDATE

--#####################################################################
-- END REPORT