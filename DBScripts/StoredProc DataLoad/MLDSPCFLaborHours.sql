CREATE PROCEDURE [dbo].[MLDSPCFLaborHours]
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
	
	Update MLModelTable SET Day9CFHours = NULL
	Update MLModelTable SET Day9CFHours = A.Day9CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day9CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-10,105) and L.LaborDate <= CONVERT(DATE, @backupDate-9,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day8CFHours = NULL
	Update MLModelTable SET Day8CFHours = A.Day8CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day8CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-9,105) and L.LaborDate <= CONVERT(DATE, @backupDate-8,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day7CFHours = NULL
	Update MLModelTable SET Day7CFHours = A.Day7CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day7CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-8,105) and L.LaborDate <= CONVERT(DATE, @backupDate-7,105) 
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day6CFHours = NULL
	Update MLModelTable SET Day6CFHours = A.Day6CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day6CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-7,105) and L.LaborDate <= CONVERT(DATE, @backupDate-6,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day5CFHours = NULL
	Update MLModelTable SET Day5CFHours = A.Day5CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day5CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-6,105) and L.LaborDate <= CONVERT(DATE, @backupDate-5,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)


	Update MLModelTable SET Day4CFHours = NULL
	Update MLModelTable SET Day4CFHours = A.Day4CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day4CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-5,105) and L.LaborDate <= CONVERT(DATE, @backupDate-4,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day3CFHours = NULL
	Update MLModelTable SET Day3CFHours = A.Day3CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day3CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-4,105) and L.LaborDate <= CONVERT(DATE, @backupDate-3,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)


	Update MLModelTable SET Day2CFHours = NULL
	Update MLModelTable SET Day2CFHours = A.Day2CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day2CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-3,105) and L.LaborDate <= CONVERT(DATE, @backupDate-2,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day1CFHours = NULL
	Update MLModelTable SET Day1CFHours = A.Day1CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day1CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-2,105) and L.LaborDate <= CONVERT(DATE, @backupDate-1,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day0CFHours = NULL
	Update MLModelTable SET Day0CFHours = A.Day0CFHours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day0CFHours from ULSLabor L WITH (NOLOCK)
		INNER JOIN LaborCategories LG
		ON L.LaborCategoryId = LG.ID 
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-1,105) and L.LaborDate <= CONVERT(DATE, @backupDate-0,105)
		AND CUSTOMERFacingIndicator ='Y'
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
		) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

RETURN 0
