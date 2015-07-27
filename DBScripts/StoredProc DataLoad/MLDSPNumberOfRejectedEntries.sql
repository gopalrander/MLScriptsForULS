CREATE PROCEDURE [dbo].[MLDSPNumberOfRejectedEntries]
	@backupDateIn NVARCHAR(30) NULL
AS
	DECLARE @backupDate DATETIME
	SET @backupDate = CONVERT(DATETIME, '2015-07-21 00:00:00.000')
	
	Update MLModelTable set RejectedLaborHours = NULL, NumberOfRejectedEntries = NULL

	Update MLModelTable SET RejectedLaborHours = B.RejectedLaborHours, NumberOfRejectedEntries = B.NumberOfRejectedEntries
	FROM (
	Select SubmittedFor, SUM(LaborHours) RejectedLaborHours, COUNT(1) NumberOfRejectedEntries from ULSLabor L WITH (NOLOCK)
		INNER JOIN ULSApproval A WITH (NOLOCK) 
		ON L.ULSRowID = A.ULSLaborRowID
	WHERE A.ApprovalStatus = 3
	and A.ULStransStatus = 1
	and L.LaborDate >= CONVERT(DATE, @backupDate-10,105) -- entries rejected in last week.
	Group By SubmittedFor
	)B inner join MLModelTable 
	ON (B.SubmittedFor = MLModelTable.UserAlias)

RETURN 0

--select * from MLModelTable where RejectedLaborHours is not null


