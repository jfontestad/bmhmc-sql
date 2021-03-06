-- VARIABLE DECLARATION AND INITIALIZATION
DECLARE @SD DATE;
DECLARE @ED DATE;
SET @SD = '2014-05-01';
SET @ED = '2014-06-01';

-- COLUMN SELECTION
SELECT DISTINCT SO.episode_no AS [VISIT ID]
, SO.svc_desc AS [SERVICE DESCRIPTION]
, SO.svc_cd AS [SERVICE CODE]
, SO.ord_no AS [ORDER NUMBER]
, SO.pty_name AS [ORDERING PARTY]

-- DB(S) USED
FROM smsmir.sr_ord SO
JOIN smsdss.BMH_PLM_PtAcct_V PAV
ON SO.episode_no = PAV.PtNo_Num

-- FILTER(S)
WHERE SO.svc_cd IN (
	'01330802','01330703','01330604','01301035','01301027',
	'01301019','01301100','01301001','01301050','01304005',
	'01304054','01304104','01306257','01306109','01302082',
	'01302082','01302017','01302025','01302066','01302066',
	'01302074','01302009','01302058','01302181','01302181',
	'01302108','01302256','01331206','01331008','01331024',
	'01331016','01331412','01331438','01331396','01331446',
	'01331453','01331479','01331487','01331529','01331511',
	'01306208','01306059','01303114','01303015','01303312',
	'01303213','01303122','01303023','01303320','01303221',
	'01304641','01304658','01304799','01304815','01304831',
	'01306000','01306000','01306158','01304856','01304906',
	'01304997','01304245','01304252','01305200','01305002',
	'01305051','01305101','01304179','01304161','01304450',
	'01304468','01304740','01304757'
)
AND PAV.Dsch_Date >= @SD 
AND PAV.Dsch_Date < @ED
AND PAV.drg_no IN (190,191,192)
AND PAV.Plm_Pt_Acct_Type = 'I'
AND PAV.PtNo_Num < '20000000'
