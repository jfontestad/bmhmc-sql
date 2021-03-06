SELECT COUNT(a.pt_no) AS [Cases]
, MONTH(a.adm_Date)   AS [Svc_Month]
, YEAR(a.adm_Date)    AS [Svc_Year]
, a.Pt_No
, a.pt_type
, a.hosp_svc
, c.spclty_cd_desc
, a.atn_dr_no
, b.pract_rpt_name
, d.proc_Cd           AS [Prin_Proc_Cd]
, e.clasf_desc        AS [Prin_Proc_Cd_Desc]
, a.tot_Chg_Amt

FROM smsdss.bmh_plm_ptacct_v             AS a 
LEFT JOIN smsmir.mir_pract_mstr          AS b
ON a.atn_dr_no = b.pract_no 
	AND b.src_sys_id='#PASS0X0'
LEFT OUTER JOIN smsdss.pract_spclty_mstr AS c
ON b.spclty_cd1 = c.spclty_cd 
	AND c.src_sys_id = '#PMSNTX0'
LEFT OUTER JOIN smsmir.mir_sproc         AS d
ON a.Pt_No = d.pt_id 
	AND d.proc_cd_prio IN ('1','01') 
	AND proc_cd_type = 'PC'
LEFT OUTER JOIN smsmir.mir_clasf_mstr    AS e
ON d.proc_cd=e.clasf_cd

WHERE (
	a.pt_type IN ('D','G')
	AND hosp_svc NOT IN ('INF','CTH')
	--AND Atn_Dr_No = ''
	AND (
		Adm_Date >= '2016-01-01' 
		AND Adm_Date < '2016-04-01' 
		--OR 
		--Adm_Date >= '01/01/2015' 
		--AND Adm_Date < '09/30/2015'
	)
	AND a.tot_chg_amt > '0'
	AND LEFT(a.pt_no,5)NOT IN ('00008','00009')
)

GROUP BY MONTH(a.adm_Date)
, YEAR(a.adm_Date) 
, a.Pt_No
, a.pt_type
, a.hosp_svc
, c.spclty_cd_desc
, a.atn_dr_no
, b.pract_rpt_name
, d.proc_Cd 
, e.clasf_desc
, a.tot_Chg_Amt