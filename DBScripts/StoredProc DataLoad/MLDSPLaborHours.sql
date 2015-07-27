CREATE PROCEDURE [dbo].[MLDSPLaborHours]
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

	Update MLModelTable SET Day9Hours = NULL
	Update MLModelTable SET Day9Hours = A.Day9Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day9Hours from ULSLabor L WITH (NOLOCK)
		WHERE  L.LaborDate > CONVERT(DATE, @backupDate-10,105) and L.LaborDate <= CONVERT(DATE, @backupDate-9,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)


	Update MLModelTable SET Day8Hours = NULL
	Update MLModelTable SET Day8Hours = A.Day8Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day8Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-9,105) and L.LaborDate <= CONVERT(DATE, @backupDate-8,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)


	Update MLModelTable SET Day7Hours = NULL
	Update MLModelTable SET Day7Hours = A.Day7Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day7Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-8,105) and L.LaborDate <= CONVERT(DATE, @backupDate-7,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day6Hours = NULL
	Update MLModelTable SET Day6Hours = A.Day6Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day6Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-7,105) and L.LaborDate <= CONVERT(DATE, @backupDate-6,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day5Hours = NULL
	Update MLModelTable SET Day5Hours = A.Day5Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day5Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-6,105) and L.LaborDate <= CONVERT(DATE, @backupDate-5,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day4Hours = NULL
	Update MLModelTable SET Day4Hours = A.Day4Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day4Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-5,105) and L.LaborDate <= CONVERT(DATE, @backupDate-4,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day3Hours = NULL
	Update MLModelTable SET Day3Hours = A.Day3Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day3Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-4,105) and L.LaborDate <= CONVERT(DATE, @backupDate-3,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day2Hours = NULL
	Update MLModelTable SET Day2Hours = A.Day2Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day2Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-3,105) and L.LaborDate <= CONVERT(DATE, @backupDate-2,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day1Hours = NULL
	Update MLModelTable SET Day1Hours = A.Day1Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day1Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-2,105) and L.LaborDate <= CONVERT(DATE, @backupDate-1,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

	Update MLModelTable SET Day0Hours = NULL
	Update MLModelTable SET Day0Hours = A.Day0Hours
	FROM (
		Select SubmittedFor, SUM(LaborHours) AS Day0Hours from ULSLabor L WITH (NOLOCK)
		WHERE L.LaborDate > CONVERT(DATE, @backupDate-1,105) and L.LaborDate <= CONVERT(DATE, @backupDate-0,105)
		and ULSRowId in (SELECT ULSRowid from @LatestRowId)
		Group By SubmittedFor
	) A inner join MLModelTable 
	ON (A.SubmittedFor = MLModelTable.UserAlias)

RETURN 0


select * from MLModelTable