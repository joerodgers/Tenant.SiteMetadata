CREATE OR ALTER FUNCTION dbo.tvf_Principals
(
    @PrincipalType   int          = 1, 
    @PrincipalStatus nvarchar(50) = 3
)
RETURNS @Principals TABLE
(
        ObjectId          uniqueidentifier NULL,
        Identifier        nvarchar(100)    NULL,
        DisplayName       nvarchar(500)    NULL,
        PrincipalType     int              NULL,
        IsDirectorySynced bit              NULL,
		DriveId           uniqueidentifier NULL,
        DeletedDate       date             NULL
) 
AS
BEGIN

    IF @PrincipalStatus & 1 <> 0
        INSERT INTO @Principals SELECT * FROM dbo.Principal WHERE PrincipalType & @PrincipalType <> 0 AND DeletedDate IS NULL 

    IF @PrincipalStatus & 2 <> 0
        INSERT INTO @Principals SELECT * FROM dbo.Principal WHERE PrincipalType & @PrincipalType <> 0 AND DeletedDate IS NOT NULL 

    RETURN
END
