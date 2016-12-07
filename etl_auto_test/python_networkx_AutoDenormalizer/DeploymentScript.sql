	PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT

:r $(pathvar)/Table/ALTER-dbo.HomeSupportActivityFact.sql
:r $(pathvar)/Table/ALTER-dbo.CDPreviousTestResultFact.sql
:r $(pathvar)/Table/ALTER-dbo.WaitTimeFact.sql
:r $(pathvar)/Table/ALTER-dbo.PersonFact.sql
:r $(pathvar)/Table/ALTER-dbo.ImmunizationAlertFact.sql
:r $(pathvar)/Table/ALTER-dbo.ClientGPFact.sql
:r $(pathvar)/Table/ALTER-dbo.AssessmentContactFact.sql
:r $(pathvar)/Table/ALTER-dbo.WeightGrowthFact.sql
:r $(pathvar)/Table/ALTER-dbo.ImmunizationHistoryFact.sql
:r $(pathvar)/Table/ALTER-dbo.CDLabReportFact.sql
:r $(pathvar)/Table/ALTER-dbo.CaseNoteContactFact.sql
:r $(pathvar)/Table/ALTER-dbo.WaitlistEntryFact.sql
:r $(pathvar)/Table/ALTER-dbo.ScreeningResultFact.sql
:r $(pathvar)/Table/ALTER-dbo.WaitlistClientOfferFact.sql
:r $(pathvar)/Table/ALTER-dbo.CurrentLocationFact.sql
:r $(pathvar)/Table/ALTER-dbo.HCRSAssessmentFact.sql
:r $(pathvar)/Table/ALTER-dbo.AddressFact.sql
:r $(pathvar)/Table/ALTER-dbo.WaitlistDefinitionFact.sql
:r $(pathvar)/Table/ALTER-dbo.SubstanceUseFact.sql
:r $(pathvar)/Table/ALTER-dbo.CDPublicHealthMeasureFact.sql
:r $(pathvar)/Table/ALTER-dbo.InterventionFact.sql
:r $(pathvar)/Table/ALTER-dbo.ReferralFact.sql
:r $(pathvar)/Table/ALTER-dbo.AssessmentHeaderFact.sql
:r $(pathvar)/Table/ALTER-dbo.InvolvedProfessionFact.sql
:r $(pathvar)/Table/ALTER-dbo.ImmAdverseEventFact.sql
:r $(pathvar)/Table/ALTER-dbo.WaitlistProviderOfferFact.sql
:r $(pathvar)/Table/ALTER-dbo.SchoolHistoryFact.sql
:r $(pathvar)/Table/ALTER-dbo.YouthClinicActivityFact.sql
:r $(pathvar)/Table/ALTER-dbo.HoNOSFact.sql
:r $(pathvar)/Table/ALTER-dbo.CaseNoteHeaderFact.sql