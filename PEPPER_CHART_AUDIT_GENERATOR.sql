-- GENERATE RANDOM CHARTS FOR REVIEW BASED ON PEPPER_TOOL OUTCOME
DECLARE @SD DATETIME
DECLARE @ED DATETIME
SET @SD = '2013-06-01'
SET @ED = '2013-06-30'

-- COLUMN SELECT
SELECT TOP 10 PTNO_NUM

-- DB(S) USED
FROM SMSDSS.BMH_PLM_PTACCT_V PAV
JOIN SMSDSS.PYR_DIM_V PDV
ON PAV.PYR1_CO_PLAN_CD = PDV.SRC_PYR_CD

-- FILTERS
WHERE DRG_NO IN (069)                       -- TIA
--WHERE DRG_NO IN (061,062,063,064,065,066)   -- STROKE
--WHERE DRG_NO IN (177,178)                   -- RESPITORY
--WHERE DRG_NO IN (193,194)                   -- PN
--WHERE DRG_NO IN (870, 871, 872)             -- SEPTICIMIA
--WHERE DRG_NO IN (003,004,207,870,927,933)   -- VENTILATOR
--WHERE DRG_NO IN (190,191,192)               -- COPD
--WHERE DRG_NO IN (312)                       -- SYNCOPE
--WHERE DRG_NO IN (551,552)                   -- BACK
AND ADM_DATE BETWEEN @SD AND @ED
AND PLM_PT_ACCT_TYPE = 'I'
AND PDV.PYR_CD = 'A13'
	
ORDER BY RAND()