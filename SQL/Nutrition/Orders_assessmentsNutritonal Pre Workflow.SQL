/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Visit.episode_no
, B.[CreationTime] as 'Assessment Completed'
--,B.[InternalValue]
--,B.FindingAbbr
, Case
	when b.InternalValue = '4'
		then 'Manual Order'
	when b.InternalValue = '7'
		then 'Workflow Order'
	when (
		b.InternalValue = '6'
		and b.FindingAbbr = 'A_BMH_NSAct18-74'
	)
		then 'Manual Order'
		else 'Workflow Order'
  end as [Order_Type]
, B.[Value] as 'Assessment Value'
, C.CollectedDT as 'Nutritional Consult Completed'
, datediff(minute,B.CreationTime,C.collecteddt) AS [ELAPSED_MINUTES]

FROM [SMSPHDSSS0X0].[smsmir].[mir_sc_Assessment] as A
left outer join [SMSPHDSSS0X0].[smsmir].[mir_sc_Observation] as B
on A.AssessmentID = B.AssessmentID
left outer join [smsmir].[mir_sc_Assessment] as C
on A.Patient_oid = C.Patient_oid and A.PatientVisit_oid = C.PatientVisit_oid
left outer join [smsmir].[mir_sr_vst_pms] As Visit
on A.PatientVisit_oid = Visit.vst_no 

where (
	(
		FindingAbbr= 'A_BMH_NSAct18-74'
		and InternalValue in ('6' , '7')
	)
	or
	(
		FindingAbbr= 'A_BMH_NS75Action'
		and InternalValue in ('4' , '6')
		)
	)
and B.EndDT is null
and B.CreationTime between '2017-08-01' and '2019-02-27'
and C.FormUsage = 'Nutritional Assessment'
and C.CollectedDT > B.CreationTime

   
   