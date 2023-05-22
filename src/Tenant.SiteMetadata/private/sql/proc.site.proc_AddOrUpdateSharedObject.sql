CREATE OR ALTER PROCEDURE site.proc_AddOrUpdateSharedObject
	@json nvarchar(max)
AS
BEGIN

    -- delete all existing data for the sites in SharePointSharedObject
    -- with matching SiteId values as in the JSON, but with 
    -- different SnapshotDate values.  Basically, delete all the old rows

    ;WITH
        cte AS
        (
            SELECT DISTINCT
                SiteId,
                SnapshotDate
            FROM
                OPENJSON(@json)
                WITH
                (
                    SiteId       UNIQUEIDENTIFIER,
                    SnapshotDate DATETIME2(2)
                )
        )
    
    DELETE 
        site.SharedObject
    FROM 
        cte INNER JOIN site.SharedObject ON 
        cte.SiteId       =  site.SharedObject.SiteId  AND 
        cte.SnapshotDate <> site.SharedObject.SnapshotDate
    ;

    -- insert new site data
    WITH
        cte AS
        (
            SELECT
                SiteId,
                WebId,
                ItemType,
                ItemUrl,
                FileExtension,
                RoleDefinition,
                LinkId,
                LinkScope,
                ScopeId,
                SnapshotDate,
                ShareCreatedBy,
                ShareCreatedTime,
                ShareLastModifiedBy,
                ShareLastModifiedTime,
                ShareExpirationTime,
                SharedWithType,
                SharedWithName,
                SharedWithEmail
            FROM
                OPENJSON(@json)
                WITH
                (
                    SiteId                UNIQUEIDENTIFIER,
                    WebId                 UNIQUEIDENTIFIER,
                    ItemType              NVARCHAR(500),
                    ItemUrl               NVARCHAR(500) N'$.ItemURL',
                    FileExtension         NVARCHAR(50),
                    RoleDefinition        NVARCHAR(500),
                    LinkId                UNIQUEIDENTIFIER,
                    ScopeId               UNIQUEIDENTIFIER,
                    LinkScope             NVARCHAR(500),
                    SnapshotDate          DATETIME2(0),
                    ShareCreatedBy        NVARCHAR(500),
                    ShareCreatedTime      DATETIME2(7),
                    ShareLastModifiedBy   NVARCHAR(500),
                    ShareLastModifiedTime DATETIME2(7),
                    SharedWith            NVARCHAR(max) AS JSON,
                    ShareExpirationTime   DATETIME2(7)
                ) AS Record
            CROSS APPLY
                OPENJSON(Record.SharedWith)
                WITH
                (
                    SharedWithType  NVARCHAR(500) N'$.Type',
                    SharedWithName  NVARCHAR(500) N'$.Name',
                    SharedWithEmail NVARCHAR(500) N'$.Email'
                )
       )
       INSERT INTO site.SharedObject
       (
            SiteId, 
            WebId, 
            ItemType, 
            ItemUrl, 
            FileExtension, 
            RoleDefinition, 
            LinkId, 
            LinkScope, 
            ScopeId, 
            SnapshotDate, 
            ShareCreatedBy, 
            ShareCreatedTime, 
            ShareLastModifiedBy, 
            ShareLastModifiedTime, 
            ShareExpirationTime, 
            SharedWithType, 
            SharedWithName, 
            SharedWithEmail 
       )
       SELECT   
            SiteId, 
            WebId, 
            ItemType, 
            ItemUrl, 
            FileExtension, 
            RoleDefinition, 
            LinkId, 
            LinkScope, 
            ScopeId, 
            SnapshotDate, 
            ShareCreatedBy, 
            ShareCreatedTime, 
            ShareLastModifiedBy, 
            ShareLastModifiedTime, 
            ShareExpirationTime, 
            SharedWithType, 
            SharedWithName, 
            SharedWithEmail 
        FROM 
            cte;

END