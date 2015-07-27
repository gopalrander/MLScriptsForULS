CREATE PROCEDURE [dbo].[MLDSPDistinctLaborCategories]
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
		--select * from tblfinalLaborEntries
--no of distinct labor categories used by user
Update MLModelTable SET DistinctLaborCategories = NULL

Update MLModelTable SET DistinctLaborCategories = A.DistinctLaborCategories
FROM (
Select SubmittedFor, Count(Distinct(LaborCategoryId)) DistinctLaborCategories From ULSLabor L WITH (NOLOCK)
	where  LaborDate >= CONVERT(DATE, @backupDate-10,105)
	and ULSRowId in (SELECT ULSRowid from @LatestRowId)
	--and  SubmittedFor  = 'tamersh'
Group by SubmittedFor
) A inner join MLModelTable 
ON (A.SubmittedFor = MLModelTable.UserAlias)

RETURN 0

--select * from ULSLabor where SubmittedFor  = 'tamersh' order by LaborDate desc


