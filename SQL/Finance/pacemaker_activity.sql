SELECT A.PT_NO
, CAST(B.Adm_Date AS DATE)          AS ADM_DATE
, DATEPART(YEAR, Adm_Date)          AS ADM_YEAR
, DATEPART(MONTH, ADM_DATE)         AS ADM_MONTH
, CAST(B.Dsch_Date AS DATE)         AS DSCH_DATE
, DATEPART(YEAR, DSCH_DATE)         AS DSCH_YEAR
, DATEPART(MONTH, DSCH_DATE)        AS DSCH_MONTH
, CAST(B.Days_Stay AS INT)          AS LOS
, B.Atn_Dr_No
, C.pract_rpt_name
, A.Clasf_Eff_Date
, DATEPART(MONTH, A.Clasf_Eff_Date) AS SVC_MONTH
, DATEPART(YEAR, A.CLASF_EFF_DATE)  AS SVC_YEAR
, A.CLASFCD
, D.alt_clasf_desc

FROM SMSDSS.BMH_PLM_PtAcct_Clasf_Proc_V_New AS A
LEFT JOIN SMSDSS.BMH_PLM_PTACCT_V           AS B
ON A.Pt_No = B.Pt_No
LEFT JOIN SMSDSS.pract_dim_v                AS C
ON A.RespParty = C.src_pract_no
       AND B.Regn_Hosp = C.orgz_cd
LEFT JOIN SMSDSS.proc_dim_v                 AS D
ON A.ClasfCd = D.proc_cd
	AND A.Proc_Cd_Schm = D.proc_cd_schm

WHERE B.Dsch_Date >= '2015-01-01'
AND B.Dsch_Date < '2017-01-01'
AND A.ClasfCd IN (
    --   '33202','33203','33206','33207','33208','33210','33211',
    --   '33212','33213','33221','33216','33217','33224','33225',
    --   '93583',
	   ---- icd-10
	   --'0JH604A','0JH605Z','0JH606Z','0JH607Z',
	   --'0JH634Z','0JH635Z','0JH636Z','0JH637Z',
	   --'0JH804Z','0JH805Z','0JH806Z','0JH807Z',
	   --'0JH834Z','0JH835Z','0JH836Z','0JH837Z',
	   --'02H60JZ','02H60KZ','02H60MZ','02H60NZ',
	   --'02H63JZ','02H63KZ','02H63MZ','02H63NZ',
	   --'02H64JZ','02H64KZ','02H64MZ','02H64NZ',
	   --'02H70JZ','02H70KZ','02H70MZ','02H70NZ',
	   --'02H73JZ','02H73KZ','02H73MZ','02H73NZ',
	   --'02H74JZ','02H74KZ','02H74MZ','02H74NZ',
	   --'02HK0JZ','02HK0KZ','02HK0MZ','02HK0NZ',
	   --'02HK3JZ','02HK3KZ','02HK3MZ','02HK3NZ',
	   --'02HK4JZ','02HK4KZ','02HK4MZ','02HK4NZ',
	   --'02HL0JZ','02HL0KZ','02HL0MZ','02HL0NZ',
	   --'02HL3JZ','02HL3KZ','02HL3MZ','02HL3NZ',
	   --'02HL4JZ','02HL4KZ','02HL4MZ','02HL4NZ',
	   --'0JH80ZZ','0JH83ZZ','0JH60ZZ','0JH63ZZ'
	   	'02PA0MZ','02PA3MZ','02PA4MZ','02PAXMZ','02PA0NZ','02PA3NZ','02PARNZ',
	'02PAXNZ','02PA0QZ','02PA3QZ','02PA4QZ','02PAXQZ','02PA0RZ','02PA3RZ',
	'02PA4RZ','02PAXRZ','02WA0MZ','02WA3MZ','02WA4MZ','02WAXMZ','02WA0NZ',
	'02WA3NZ','02WA4NZ','02WAXNZ','02WA0QZ','02WA3QZ','02WA4QZ','02WAXQZ',
	'02WA0RZ','02WA3RZ','02WA4RZ','02WAXRZ','0JH600Z','0JH630Z','0JH800Z',
	'0JH830Z','0JH602Z','0JH632Z','0JH802Z','0JH832Z','0JH604Z','0JH634Z',
	'0JH804Z','0JH834Z','0JH605Z','0JH635Z','0JH805Z','0JH835Z','0JH607Z',
	'0JH637Z','0JH807Z','0JH837Z','0JH608Z','0JH638Z','0JH808Z','0JH838Z',
	'0JH609Z','0JH639Z','0JH809Z','0JH839Z','0JH60PZ','0JH63PZ','0JH80PZ',
	'0JH83PZ','02H400','02H402','02H40J','02H40K','02H40M','02H40N','02H40Q',
	'02H40R','02H40Z','02H430','02H432','02H43J','02H43K','02H43M','02H43N',
	'02H43Q','02H43R','02H43Z','02H440','02H442','02H44J','02H44K','02H44M',
	'02H44N','02H44Q','02H44R','02H44Z','02H600','02H602','02H60J','02H60K',
	'02H60M','02H60N','02H60Q','02H60R','02H60Z','02H630','02H632','02H63J',
	'02H63K','02H63M','02H63N','02H63Q','02H63R','02H63Z','02H640','02H642',
	'02H64J','02H64K','02H64M','02H64N','02H64Q','02H64R','02H64Z','02H74Z',
	'02H700','02H702','02H70J','02H70K','02H70M','02H70N','02H70Q','02H70R',
	'02H70Z','02H730','02H732','02H73J','02H73K','02H73M','02H73N','02H73Q',
	'02H73R','02H73Z','02H740','02H742','02H74J','02H74K','02H74M','02H74N',
	'02H74Q','02H74R','02H74Z','02HK4Z','02HK00','02HK02','02HK0J','02HK0K',
	'02HK0M','02HK0N','02HK0Q','02HK0R','02HK0Z','02HK30','02HK32','02HK3J',
	'02HK3K','02HK3M','02HK3N','02HK3Q','02HK3R','02HK3Z','02HK40','02HK42',
	'02HK4J','02HK4K','02HK4M','02HK4N','02HK4Q','02HK4R','02HK4Z','02HL4Z',
	'02HL00','02HL02','02HL0J','02HL0K','02HL0M','02HL0N','02HL0Q','02HL0R',
	'02HL0Z','02HL30','02HL32','02HL3J','02HL3K','02HL3M','02HL3N','02HL3Q',
	'02HL3R','02HL3Z','02HL40','02HL42','02HL4J','02HL4K','02HL4M','02HL4N',
	'02HL4Q','02HL4R','02HL4Z','02HA4Z','02HA00','02HA02','02HA0J','02HA0K',
	'02HA0M','02HA0N','02HA0Q','02HA0R','02HA0Z','02HA30','02HA32','02HA3J',
	'02HA3K','02HA3M','02HA3N','02HA3Q','02HA3R','02HA3Z','02HA40','02HA42',
	'02HA4J','02HA4K','02HA4M','02HA4N','02HA4Q','02HA4R','02HA4Z','02HN4Z',
	'02HN00','02HN02','02HN0J','02HN0K','02HN0M','02HN0N','02HN0Q','02HN0R',
	'02HN0Z','02HN30','02HN32','02HN3J','02HN3K','02HN3M','02HN3N','02HN3Q',
	'02HN3R','02HN3Z','02HN40','02HN42','02HN4J','02HN4K','02HN4M','02HN4N',
	'02HN4Q','02HN4R','02HN4Z','5A12032','5A12132','5A12232','5A1203Z','5A1213Z',
	'5A1223Z',
	-- cpt codes
	'33202','33203','33206','33207','33208','33210','33211','33212','33213',
	'33221','33216','33217','33224','33225','93583','33233','33227','33228',
	'33229','33234','33235','33236','33237','33214','33215','33218','33220',
	'33222','33223','33226'
)

ORDER BY a.Pt_No
OPTION(FORCE ORDER);