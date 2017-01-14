CREATE TABLE smsdss.c_EmpireExchange_mir_pay_2016 (
 PK INT NOT NULL IDENTITY(1, 1) PRIMARY KEY
, PT_ID VARCHAR(12)
, pay_cd VARCHAR(15)
, pay_date DATE
, pay_seq_no INT
, tot_pay_adj_amt MONEY
, orgz_cd VARCHAR(10)
, pay_desc VARCHAR(200)
, hosp_svc VARCHAR(10)
, pyr_cd VARCHAR(5)
, pt_id_start_dtime DATETIME
);

INSERT INTO smsdss.c_EmpireExchange_mir_pay_2016

SELECT *
FROM (
	SELECT pt_id
	, pay_cd
	, pay_date
	, pay_seq_no
	, tot_pay_adj_amt
	, orgz_cd
	, pay_desc
	, hosp_svc
	, pyr_cd
	, pt_id_start_dtime

	FROM smsmir.pay

	WHERE (pay_cd BETWEEN '09600000' AND '09699999'
	OR pay_cd BETWEEN '00990000' AND '00999999'
	OR pay_cd BETWEEN '09900000' AND '09999999'
	OR pay_cd IN (
		'00980300','00980409','00980508','00980607','00980656','00980706',
		'00980755','00980805','00980813','00980821','09800095','09800277',
		'09800301','09800400','09800459','09800509','09800558','09800608',
		'09800707','09800715','09800806','09800814','09800905','09800913',
		'09800921','09800939','09800947','09800962','09800970','09800988',
		'09800996','09801002','09801010','09801028','09801036','09801044',
		'09801051','09801069','09801077','09801085','09801093','09801101',
		'09801119'
		)
	)
	--AND LEFT(pt_id, 5) != '00007'
	--AND pay_date >= '2012-01-01'
	--AND pay_date < '2016-01-01'
	AND tot_pay_adj_amt != '0'
	AND pt_id in (
		'000014223267','000014224703','000014230783','000014231005','000014233670',
		'000014237655','000014238349','000014242358','000014242531','000014242994',
		'000014243851','000014248025','000014249569','000014250575','000014254205',
		'000014257828','000014261887','000014261986','000014262224','000014269930',
		'000014272272','000014276778','000014277628','000014288526','000014289961',
		'000014290696','000014291314','000014292973','000014293195','000014295828',
		'000014297618','000014299861','000014304232','000014305536','000014314017',
		'000014315873','000014316251','000014319057','000014320881','000014322630',
		'000014322812','000014325823','000014332134','000014332241','000014333959',
		'000014334908','000014339261','000014341085','000014345813','000014347330',
		'000030436588','000030436703','000030439947','000030466163','000061241196',
		'000061249181','000061298865','000061331328','000061359733','000061446258',
		'000061464251','000061474896','000061665287','000085494201','000085505683',
		'000085515237','000085517035','000085525327','000085528321','000085536498',
		'000085541753','000085542470','000085544211','000085545713','000085550911',
		'000085555407','000085571321','000085575819','000085576437','000085578862',
		'000085581130','000085600724','000085611374','000085614667','000085625309',
		'000085625515','000085635290','000085639821','000085642668','000085655124',
		'000085670305','000085674141','000085684678','000085688281','000085696201',
		'000085696979','000085697977','000085698702','000085701993','000085706430',
		'000085711646','000085722783','000085727543','000085728111','000085728657',
		'000085729325','000085734184','000085740652','000085744365','000085749950',
		'000085751501','000085755825','000085757110','000085761989','000085766152',
		'000085767333','000085768208','000085770444','000085771186','000085773307',
		'000085776813','000085782886','000085785350','000085786143','000085787844',
		'000085789014','000085791887','000085802841','000085803047','000085806909',
		'000085812741','000085813038','000085817419','000085823698','000085831352',
		'000085848638','000085851418','000085854677','000085870434','000085882959',
		'000085884435','000085896090','000085898740','000085901700','000085908408',
		'000085911808','000085917706','000085918951','000085923571','000085925790',
		'000085929792','000085934131','000085941060','000085942803','000085943355',
		'000085948289','000085948297','000085952869','000085954063','000085960664',
		'000085968337','000085981199','000085987964','000085992865','000085993756',
		'000085994747','000086006848','000086012457','000086032711','000086032836',
		'000086033859','000086057510','000086072337','000086077963','000086098225',
		'000086100849','000086103967','000086106952','000086126166','000086137031',
		'000086150695','000086157914','000086164951','000086168077','000086173341',
		'000086178738','000086196771','000086198108','000086202728','000086218633',
		'000086219748','000086226156','000086227915','000086228822','000086242237',
		'000086250172','000086251865','000086254331','000086254760','000086257995',
		'000086259066','000086261344','000099930968'
	)
) A
