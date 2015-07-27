CREATE PROCEDURE [dbo].[MLDSPLaborTimeZone]
AS
	Update MLModelTable SET TimeZoneID = NULL, ISEmployeeFTE=NULL

Update MLModelTable SET TimeZoneID = A.TimeZoneID, ISEmployeeFTE = A.ISEmployee
FROM (
	Select ProfileID, TimeZoneID, ISEmployee from ULSProfile WITH (NOLOCK)
	)	A inner join MLModelTable 
ON (A.ProfileID = MLModelTable.UserAlias)


Update MLModelTable SET IsUserExcluded = NULL
Update MLModelTable SET IsUserExcluded = A.IsUserExcluded
FROM (
Select ProfileID, '1' AS IsUserExcluded FROM ULSProfile P WITH (NOLOCK)
	INNER JOIN ULSExcludedCountry EX WITH (NOLOCK)
	ON P.CountryCode = EX.LocationAreaCode 
WHERE ExclusionMode = 'ALL'
OR ExclusionMode = 'SUBCON' and IsEmployee = 0
) A inner join MLModelTable 
ON (A.ProfileID = MLModelTable.UserAlias)

Update MLModelTable SET IsUserExcluded = 0 where IsUserExcluded is NULL


RETURN 0
