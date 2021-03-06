USE [SMSPHDSSS0X0]
GO

/****** Object:  View [smsdss].[c_LIHN_Svc_Lines_Rpt2_v]    Script Date: 11/16/2015 10:09:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
ALTER VIEW [smsdss].[c_LIHN_Svc_Lines_Rpt2_ICD10_v]
AS
SELECT pt_id
, Dsch_Date
, LOS
, Atn_Dr_No
, Atn_Dr_Name
, drg_no
, drg_schm
, drg_name
, Diag01
, Diagnosis
, Proc01
, [Procedure]
, Shock_Ind
, Intermed_Coronary_Synd_Ind
, CASE 
	WHEN LIHN_Svc_Line <> '' 
		THEN LIHN_Svc_Line 
	WHEN LIHN_Svc_Line = '' 
		AND drg_no IN (
			'1', '2', '3', '4', '5', '6', '7', '8', '10', 
			'11', '12', '13', '14', '16', '17', '20', '21', '22', 
			'23', '24', '25', '26', '27', '28', '29', '30', '31', 
			'32', '33', '34', '35', '36', '37', '38', '39', '40', 
			'41', '42', '113', '114', '115', '116', '117', '129', 
			'130', '131', '132', '133', '134', '135', '136', '137', 
			'138', '139', '163', '164', '165', '166', '167', '168', 
			'215', '216', '217', '218', '219', '220', '221', '222', 
			'223', '224', '225', '226', '227', '228', '229', '230', 
			'231', '232', '233', '234', '235', '236', '237', '238', 
			'239', '240', '241', '242', '243', '244', '245', '246', 
			'247', '248', '249', '250', '251', '252', '253', '254', 
            '255', '256', '257', '258', '259', '260', '261', '262', 
			'263', '264', '265', '326', '327', '328', '329', '330', 
			'331', '332', '333', '334', '335', '336', '337', '338', 
			'339', '340', '341', '342', '343', '344', '345', '346', 
			'347', '348', '349', '350', '351', '352', '353', '354', 
			'355', '356', '357', '358', '405', '406', '407', '408', 
			'409', '410', '411', '412', '413', '414', '415', '416', 
			'417', '418', '419', '420', '421', '422', '423', '424', 
			'425', '453', '454', '455', '456', '457', '458', '459', 
			'460', '461', '462', '463', '464', '465', '466', '467', 
			'468', '469', '470', '471', '472', '473', '474', '475', 
			'476', '477', '478', '479', '480', '481', '482', '483', 
			'484', '485', '486', '487', '488', '489', '490', '491', 
			'492', '493', '494', '495', '496', '497', '498', '499', 
			'500', '501', '502', '503', '504', '505', '506', '507', 
			'508', '509', '510', '511', '512', '513', '514', '515', 
			'516', '517', '570', '571', '572', '573', '574', '575', 
			'576', '577', '578', '579', '580', '581', '582', '583', 
			'584', '585', '614', '615', '616', '617', '618', '619', 
			'620', '621', '622', '623', '624', '625', '626', '627', 
			'628', '629', '630', '652', '653', '654', '655', '656', 
			'657', '658', '659', '660', '661', '662', '663', '664', 
			'665', '666', '667', '668', '669', '670', '671', '672', 
			'673', '674', '675', '707', '708', '709', '710', '711', 
			'712', '713', '714', '715', '716', '717', '718', '734', 
			'735', '736', '737', '738', '739', '740', '741', '742', 
			'743', '744', '745', '746', '747', '748', '749', '750', 
			'765', '766', '767', '768', '769', '770', '799', '800', 
			'801', '802', '803', '804', '820', '821', '822', '823', 
			'824', '825', '826', '827', '828', '829', '830', '853', 
			'854', '855', '856', '857', '858', '876', '901', '902', 
			'903', '904', '905', '906', '907', '908', '909', '927', 
			'928', '929', '939', '940', '941', '955', '956', '957', 
			'958', '959', '969', '970', '981', '982', '983', '984', 
			'985', '986', '987', '988', '989'
			)
		THEN 'Surgical' 
	WHEN LIHN_Svc_Line = '' 
		AND drg_no NOT IN ('1', '2', '3', '4', '5', '6', '7', '8', '10', 
			'11', '12', '13', '14', '16', '17', '20', '21', '22', '23', 
			'24', '25', '26', '27', '28', '29', '30', '31', '32', '33', 
			'34', '35', '36', '37', '38', '39', '40', '41', '42', '113', 
			'114', '115', '116', '117', '129', '130', '131', '132', '133', 
			'134', '135', '136', '137', '138', '139', '163', '164', '165', 
			'166', '167', '168', '215', '216', '217', '218', '219', '220', 
			'221', '222', '223', '224', '225', '226', '227', '228', '229', 
			'230', '231', '232', '233', '234', '235', '236', '237', '238', 
			'239', '240', '241', '242', '243', '244', '245', '246', '247', 
					  '248', '249', '250', '251', '252', '253', 
                      '254', '255', '256', '257', '258', '259', '260', 
					  '261', '262', '263', '264', '265', '326', '327', 
					  '328', '329', '330', '331', '332', '333', '334', 
					  '335', '336', '337', '338', '339', '340', 
                      '341', '342', '343', '344', '345', '346', '347', 
					  '348', '349', '350', '351', '352', '353', '354', '355', 
					  '356', '357', '358', '405', '406', '407', '408', '409', 
					  '410', '411', '412', '413', 
                      '414', '415', '416', '417', '418', '419', '420', '421', 
					  '422', '423', '424', '425', '453', '454', '455', '456', 
					  '457', '458', '459', '460', '461', '462', '463', '464', 
					  '465', '466', '467', 
                      '468', '469', '470', '471', '472', '473', '474', '475', 
					  '476', '477', '478', '479', '480', '481', '482', '483', 
					  '484', '485', '486', '487', '488', '489', '490', '491', 
					  '492', '493', '494', 
                      '495', '496', '497', '498', '499', '500', '501', '502', 
					  '503', '504', '505', '506', '507', '508', '509', '510', 
					  '511', '512', '513', '514', '515', '516', '517', '570', 
					  '571', '572', '573', 
                      '574', '575', '576', '577', '578', '579', '580', '581', 
					  '582', '583', '584', '585', '614', '615', '616', '617', 
					  '618', '619', '620', '621', '622', '623', '624', '625', 
					  '626', '627', '628', 
                      '629', '630', '652', '653', '654', '655', '656', '657', 
					  '658', '659', '660', '661', '662', '663', '664', '665', 
					  '666', '667', '668', '669', '670', '671', '672', '673', 
					  '674', '675', '707', 
                      '708', '709', '710', '711', '712', '713', '714', '715', 
					  '716', '717', '718', '734', '735', '736', '737', '738', 
					  '739', '740', '741', '742', '743', '744', '745', '746', 
					  '747', '748', '749', 
                      '750', '765', '766', '767', '768', '769', '770', '799', 
					  '800', '801', '802', '803', '804', '820', '821', '822', 
					  '823', '824', '825', '826', '827', '828', '829', '830', 
					  '853', '854', '855', 
                      '856', '857', '858', '876', '901', '902', '903', '904', 
					  '905', '906', '907', '908', '909', '927', '928', '929', 
					  '939', '940', '941', '955', '956', '957', '958', '959', 
					  '969', '970', '981', 
                      '982', '983', '984', '985', '986', '987', '988', '989') 
		THEN 'Medical' 
END AS LIHN_Service_Line
, icd_cd_schm
, proc_cd_schm

FROM smsdss.c_LIHN_Svc_Lines_Rpt_ICD10_v

GO


