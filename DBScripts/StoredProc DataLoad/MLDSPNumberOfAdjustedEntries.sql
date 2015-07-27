CREATE PROCEDURE [dbo].[MLDSPNumberOfAdjustedEntries]
	@backupDateIn NVARCHAR(30) NULL
AS
	DECLARE @backupDate DATETIME
	SET @backupDate = CONVERT(DATETIME, '2015-07-21 00:00:00.000')
	
	Update MLModelTable SET NumberOfAdjustedEntries = NULL
	
	Update MLModelTable SET NumberOfAdjustedEntries = B.NumberOfAdjustedEntries
	FROM (
		Select SubmittedFor, COUNT(TOTAL) AS NumberOfAdjustedEntries FROM (
		Select SubmittedFor, Count(1) as Total FROM ULSLabor L with (Nolock)
		Where LaborDate >= CONVERT(DATE, @backupDate-10,105)
		and ULSTransStatus = 1
		Group By LaborID, SubmittedFor
		Having Count(1)> 1) A
		Group By SubmittedFor
		) B inner join MLModelTable 
		ON (B.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable set NumberOfAdjustedEntries = 0 
	where NumberOfAdjustedEntries is NULL and DistinctLaborCategories is not null
RETURN 0