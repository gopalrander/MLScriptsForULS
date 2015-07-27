CREATE PROCEDURE [dbo].[MLDSPNumberOfEntries]
	@backupDateIn NVARCHAR(30) NULL
AS
	--no of entries done in last week
	
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

Update MLModelTable SET NumberOfEntries = NULL

Update MLModelTable SET NumberOfEntries = A.NumberOfEntries
FROM (
	Select SubmittedFor, Count(1) AS NumberOfEntries From ULSLabor L WITH (NOLOCK)
	Where LaborDate >= CONVERT(DATE, @backupDate-10,105)
	and ULSRowId in (SELECT ULSRowid from @LatestRowId)
	Group By SubmittedFor
	) A inner join MLModelTable 
ON (A.SubmittedFor = MLModelTable.UserAlias)

	
RETURN 0
