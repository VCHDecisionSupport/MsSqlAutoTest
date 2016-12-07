	PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.ImmunizationHistoryFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.ReferralFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.ImmAdverseEventFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.CaseNoteContactFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.CDPreviousTestResultFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.YouthClinicActivityFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.HomeSupportActivityFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.WaitlistClientOfferFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.SchoolHistoryFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.InterventionFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.AssessmentContactFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.CaseNoteHeaderFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.ClientGPFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.WeightGrowthFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.WaitlistEntryFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.AddressFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.CDLabReportFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.WaitlistDefinitionFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.HCRSAssessmentFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.CDPublicHealthMeasureFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.PersonFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.CurrentLocationFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.AssessmentHeaderFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.InvolvedProfessionFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.ScreeningResultFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.WaitlistProviderOfferFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.HoNOSFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.ImmunizationAlertFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.SubstanceUseFact.sql
:r $(pathvar)/Table/ALTER-CommunityMart.dbo.WaitTimeFact.sql