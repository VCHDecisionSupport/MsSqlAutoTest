USE gcDataRequest
GO
-- 1	Waiting to be assigned
-- 2	Assigned to Advisor
-- 3	Started
-- 4	Testing
-- 5	Completed
-- 6	On Hold
-- 7	Cancelled
-- 8	Waiting For Information
-- 9	Production Ready
-- 10	Production Validation
-- 11	Test Ready
-- 12	Test Deployed
-- 13	Beta Ready
-- 14	Beta Deployed
-- 15	Beta Validated
DECLARE @title varchar(100) = 'apollo this is houston'
	,@drid int = 666
	,@requestor int = 123
	,@status int = 11
	,@priority int = 2
	,@recievied int = 276 -- graham
	,@date date = getdate()

DELETE DataRequest
FROM DataRequest AS dr
WHERE dr.IDNumber = @drid


INSERT INTO dbo.DataRequest (RequestTitle, IDNumber, RequestorID, StatusID, PriorityID, RecievedByEmp, RequestDate) VALUES(@title, @drid, @requestor, @status, @priority, @recievied, @date);
GO
SELECT st.*, dr.* FROM DataRequest AS dr
JOIN Status AS st
ON dr.StatusID = st.StatusID
WHERE st.status LIKE '%Test%'