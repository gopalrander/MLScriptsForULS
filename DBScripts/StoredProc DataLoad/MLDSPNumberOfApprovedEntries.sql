CREATE PROCEDURE [dbo].[MLDSPNumberOfApprovedEntries]
	@backupDateIn NVARCHAR(30) NULL
AS
	--Total approved hours last week
DECLARE @LatestRowId TABLE ( ULSRowId int)
DECLARE @backupDate DATETIME
SET @backupDate = CONVERT(DATETIME, '2015-07-21 00:00:00.000')

;WITH tblLaborEntries (SEQ, ulsrowid, SubmittedFor, labordate, ULSTransStatus)
           AS (SELECT --use the row_number function to get the newest record
              ROW_NUMBER()
                OVER(
                  PARTITION BY T1.SubmittedFor, T1.labordate, T1.laborid
                  ORDER BY ULSRowid DESC) AS SEQ,
              T1.ulsrowid,
              T1.SubmittedFor,
              T1.labordate,
              T1.ULSTransStatus
               FROM   dbo.ULSLABOR T1 WITH (nolock)
               WHERE  T1.ULSTransStatus = 1
			   AND LaborDate >= CONVERT(DATE, @backupDate-10,105)),
           tblfinalLaborEntries
           AS (SELECT ulsrowid,
                      ULSTransStatus
               FROM   tblLaborEntries
               WHERE  Seq = 1)
		Insert into @LatestRowId
		SELECT ULSRowid from tblfinalLaborEntries 
		--select * from tblfinalLaborEntries
--no of distinct labor categories used by user
Update MLModelTable SET ApprovedLaborHours = NULL, NumberOfApprovedEntries=NULL

Update MLModelTable SET ApprovedLaborHours = A.ApprovedLaborHours, NumberOfApprovedEntries = A.NumberOfApprovedEntries
FROM (
	Select SubmittedFor, SUM(LaborHours) AS ApprovedLaborHours, COUNT(1) AS NumberOfApprovedEntries from ULSLabor L WITH (NOLOCK)
	INNER JOIN ULSApproval A WITH (NOLOCK) 
	ON L.ULSRowID = A.ULSLaborRowID
	Where A.ApprovalStatus = 2
	and A.ULSTransStatus = 1
	 and L.LaborDate >= CONVERT(DATE, @backupDate-10,105)
	and L.ULSRowId in (SELECT ULSRowid from @LatestRowId)
	Group By SubmittedFor
	) A inner join MLModelTable 
ON (A.SubmittedFor = MLModelTable.UserAlias)

RETURN 0

