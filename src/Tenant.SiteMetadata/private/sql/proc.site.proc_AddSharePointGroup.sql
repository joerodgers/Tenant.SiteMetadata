CREATE OR ALTER PROCEDURE site.proc_AddSharePointGroup
	@truncate bit = 0,
    @json     nvarchar(max)
AS
BEGIN

    IF( @truncate = 1 )
        TRUNCATE TABLE site.SiteGroup

    ;WITH
        cte AS
        (
            SELECT
                SiteId,
                GroupId,
                GroupLinkId,
                GroupType,
                DisplayName,
                Description,
                PrincipalType,
                PrincipalName,
                PrincipalEmail,
                PrincipalObjectId,
                SnapshotDate
            FROM OPENJSON(@json) WITH
            (
                SiteId       uniqueidentifier,
                GroupId      int,
                GroupLinkId  uniqueidentifier,
                GroupType    nvarchar(500),
                DisplayName  nvarchar(500),
                Description  nvarchar(2000),
                Members      nvarchar(max) AS JSON,
                SnapshotDate datetime2(2),
                Operation    nvarchar(50)
            ) AS Record
            CROSS APPLY OPENJSON(Record.Members) WITH
            (
                PrincipalType     nvarchar(500)    N'$.Type',
                PrincipalName     nvarchar(500)    N'$.Name',
                PrincipalEmail    nvarchar(500)    N'$.Email',
                PrincipalObjectId uniqueidentifier N'$.AadObjectId'
            )
        )
        INSERT INTO site.SiteGroup
        (
            SiteId,
            GroupId,
            GroupLinkId,
            GroupType,
            DisplayName,
            Description,
            PrincipalType,
            PrincipalName,
            PrincipalEmail,
            PrincipalObjectId,
            SnapshotDate
       )
       SELECT   
            SiteId,
            GroupId,
            GroupLinkId,
            GroupType,
            DisplayName,
            Description,
            PrincipalType,
            PrincipalName,
            PrincipalEmail,
            PrincipalObjectId,
            SnapshotDate
        FROM 
            cte;
END        
