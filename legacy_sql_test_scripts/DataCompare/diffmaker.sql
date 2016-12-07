DELETE 
FROM DR5555_54_DSDW_Community_ReferralFact 
WHERE ETLAuditID IN (SELECT TOP 3 PERCENT ETLAuditID FROM DR5555_54_DSDW_Community_ReferralFact AS ref
ORDER BY NEWID()) 


SELECT *
FROM DR5555_54_DSDW_Community_ReferralFact AS ref
WHERE ref.DischargeDateID > 2000

UPDATE DR5555_54_DSDW_Community_ReferralFact
SET ReferralReasonID = ReferralReasonID - 1
FROM DR5555_54_DSDW_Community_ReferralFact ref
WHERE ref.ETLAuditID IN (SELECT TOP 3 PERCENT ETLAuditID FROM DR5555_54_DSDW_Community_ReferralFact
ORDER BY NEWID()) 


