/*
***********************************************************************
File: UHC_MRI_CT_Site_Review.sql

Input Parameters:
	@START
    @END

Tables/Views:
	smsmir.actv
    smsdss.BMH_PLM_PtAcct_V AS PAV
    smsdss.pyr_dim_v AS PDV

Creates Table:
	None

Functions:
	None

Author: Steven P Sanderson II, MPH

Department: Finance, Revenue Cycle

Purpose/Description
	Get MRI/CT usage and UHC MRI/CT specific site review usage

Revision History:
Date		Version		Description
----		----		----
2019-05-07	v1			Initial Creation
***********************************************************************
*/

DECLARE @START DATETIME2
DECLARE @END DATETIME2

SET @START = '2017-01-01';
SET @END = '2019-05-01';

SELECT PAV.Med_Rec_No
, PAV.PtNo_Num
, CAST(PAV.Adm_Date AS date) AS [Adm_Date]
, CAST(PAV.Dsch_Date AS date) AS [Dsch_Date]
, YEAR(PAV.ADM_DATE) AS [Adm_YR]
, MONTH(PAV.ADM_DATE) AS [Adm_MO]
, PAV.Pyr1_Co_Plan_Cd
, PDV.pyr_name
, PDV.pyr_group2
, ISNULL(
(
SELECT MAX(CASE WHEN XXX.PT_ID IS NOT NULL THEN 1 ELSE 0 END)
    FROM smsmir.actv AS XXX
    WHERE XXX.pt_id = PAV.Pt_No
        AND XXX.unit_seq_no = PAV.unit_seq_no
        AND XXX.from_file_ind = PAV.from_file_ind
        AND LEFT(XXX.ACTV_CD, 3) = '023'
    GROUP BY XXX.pt_id
)
, 0
) AS [MRI_Flag]
, ISNULL(
(
SELECT MAX(CASE WHEN XXX.PT_ID IS NOT NULL THEN 1 ELSE 0 END)
    FROM smsmir.actv AS XXX
    WHERE XXX.pt_id = PAV.Pt_No
        AND XXX.unit_seq_no = PAV.unit_seq_no
        AND XXX.from_file_ind = PAV.from_file_ind
        AND LEFT(XXX.ACTV_CD, 3) = '013'
    GROUP BY XXX.pt_id
)
, 0
) AS [CT_Flag]
, ISNULL(
(
SELECT MAX(CASE WHEN XXX.PT_ID IS NOT NULL THEN 1 ELSE 0 END)
    FROM smsmir.actv AS XXX
    WHERE XXX.pt_id = PAV.Pt_No
        AND XXX.unit_seq_no = PAV.unit_seq_no
        AND XXX.from_file_ind = PAV.from_file_ind
        AND XXX.ACTV_CD IN (
			'02304707','02301802','02301836','02303204','02303303','02304202',
			'02301810','02301828','02303220','02303329','02303725','02304228',
			'02301844','02301851','02303246','02303345','02303444','02303543',
			'02303741','02304244','02320406','02320703','02320422','02320729',
			'02320448','02320745','02320505','02320521','02320547','02300804',
			'02302701','02303709','02303808','02300820','02302727','02303824',
			'02300846','02300861','02302743','02303840','02300705','02304608',
			'02300721','02304624','02300747','02304640','02320604','02304301',
			'02304327','02304509','02304525','02304400','02304426','02304343',
			'02304541','02304442','02303600','02303907','02303626','02303923',
			'02303642','02303949','02320612','02320620','02320638','02300101',
			'02301505','02300127','02300143','02301208','02301307','02301356',
			'02351351','02301224','02351302','02300010','02301109','02301141',
			'02300606','02320109','02300929','02301026','02300945','02301042',
			'02301125','02301141','02320604','02320307','02320257','02370765',
			'02370823','02370781','02370849','02370807','02370864','02301521',
			'02301547','02351500'
		)
    GROUP BY XXX.pt_id
)
, 0
) AS [UHC_MRI_FLAG]
, ISNULL(
(
SELECT MAX(CASE WHEN XXX.PT_ID IS NOT NULL THEN 1 ELSE 0 END)
    FROM smsmir.actv AS XXX
    WHERE XXX.pt_id = PAV.Pt_No
        AND XXX.unit_seq_no = PAV.unit_seq_no
        AND XXX.from_file_ind = PAV.from_file_ind
        AND XXX.ACTV_CD IN (
			'01304104','01304765','01331453','01331735','13016316','01304054',
			'01304005','01304161','01304252','01304757','01304831','01331461',
			'01331743','13016324','01304153','01304245','01304740','01304815',
			'01304179','01304799','01304468','01304658','01331479','01331750',
			'13016332','01304450','01304641','01304997','01304906','01304856',
			'01301555','01307271','01331321','01331354','01331610','01331644',
			'13016118','13016142','01301605','01307289','01331339','01331628',
			'13016126','01302108','01302140','01302256','01320019','01302058',
			'01302124','01302181','01320027','01302009','01320035','01330919',
			'01331313','01306109','01331529','01331792','13016373','01306257',
			'01306059','01331511','01331784','13016365','01306208','01306000',
			'01331495','01331776','13016357','01306158','01307206','01330927',
			'01305101','01305200','01320043','01331487','01331768','13016340',
			'01305051','01320050','01305002','01320068','01331420','13016100',
			'13016191','01331438','01331446','13016209','13016308','01330950',
			'01331362','01331370','13016159','13016167','01331388','01331396',
			'13016175','13016183','01300045','01330943','01301050','01320076',
			'01301001','01320084','01301100','01320092','01330935','01330968',
			'01307255','01330703','01307248','01330604','01330901','01307263',
			'01330802','01300052','01301654','01331347','01331636','13016134',
			'01302504','01330018','01331545','01331578'
		)
    GROUP BY XXX.pt_id
)
, 0
) AS [UHC_CT_FLAG]
, PAV.tot_chg_amt
, PAV.Tot_Amt_Due
, PAV.tot_pay_amt

FROM smsdss.BMH_PLM_PtAcct_V AS PAV
    LEFT OUTER JOIN smsdss.pyr_dim_v AS PDV
    ON PAV.Pyr1_Co_Plan_Cd = PDV.pyr_cd
        AND PAV.Regn_Hosp = PDV.orgz_cd

WHERE Pyr1_Co_Plan_Cd IN (
'K15','J22','J10','X22','K92','X52'
)
    AND PAV.tot_chg_amt > 0
    AND PAV.Plm_Pt_Acct_Type != 'I'
    AND PAV.Pt_No IN (
        SELECT ZZZ.pt_id
        FROM smsmir.actv AS ZZZ
        WHERE LEFT(ZZZ.actv_cd, 3) IN (
        '023','013'
        )
    )
    AND PAV.Adm_Date >= @START
    AND PAV.Adm_Date < @END