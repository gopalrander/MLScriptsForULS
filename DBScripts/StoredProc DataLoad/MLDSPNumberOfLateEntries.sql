CREATE PROCEDURE [dbo].[MLDSPNumberOfLateEntries]
	@backupDateIn NVARCHAR(30) NULL
AS

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

Update MLModelTable SET NumberOfLateEntries = NULL

Update MLModelTable SET NumberOfLateEntries = A.NumberOfLateEntries
FROM (
	Select SubmittedFor, Count(1) AS NumberOfLateEntries From ULSLabor L WITH (NOLOCK)
	Where LaborDate >= CONVERT(DATE, @backupDate-10,105) 
	and LateReasonId IS NOT NULL
	and ULSRowId in (SELECT ULSRowid from @LatestRowId)
	Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

RETURN 0
