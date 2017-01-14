SELECT DT_ARRIVAL AS 'PT ARRIVAL', DT_DEPARTURE AS 'PT DEPARTS', DT_CARE_COMPLETE AS 'CC TIME',
DT_TRIAGE AS 'TRIAGE TIME', DT_INIT_BED AS 'PT IN BED', S_VISIT_IDENT AS 'ENCOUNTER NUMBER',
S_SERVICE_LEVEL AS 'SERVICE LEVEL', S_LAST_ACUITY AS 'LAST ACUITY', S_ATTENDING_PHYS AS 'DOC',
N_ARR_TO_TRIAGE AS 'ARR TO TRIAGE', N_ARR_TO_CC AS 'ARR TO CC', N_ARR_TO_DEP AS 'ARR TO DEP',
S_DIAGNOSIS_FOR_SORT AS 'DX', S_RACE AS 'RACE', S_AGE AS 'PT AGE'

FROM DBO.JTM_GENERIC_LIST_V

WHERE
AND DT_DEPARTURE > '1/1/12' AND DT_DEPARTURE < '1/1/13'
AND S_DIAGNOSIS_FOR_SORT LIKE '%SEPSIS%'