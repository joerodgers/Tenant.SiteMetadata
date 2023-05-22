CREATE OR ALTER PROCEDURE site.proc_AddSharedObject
    @truncate bit = 0,
    @json     nvarchar(max)
AS
BEGIN

    -- optionally truncate table prior to json import
    IF( @truncate = 1 )
        TRUNCATE TABLE site.SharedObject

    -- insert new site data
    ;WITH
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
                    SiteId                uniqueidentifier,
                    WebId                 uniqueidentifier,
                    ItemType              nvarchar(500),
                    ItemUrl               nvarchar(500) N'$.ItemURL',
                    FileExtension         nvarchar(50),
                    RoleDefinition        nvarchar(500),
                    LinkId                uniqueidentifier,
                    ScopeId               uniqueidentifier,
                    LinkScope             nvarchar(500),
                    SnapshotDate          datetime2(0),
                    ShareCreatedBy        nvarchar(500),
                    ShareCreatedTime      datetime2(7),
                    ShareLastModifiedBy   nvarchar(500),
                    ShareLastModifiedTime datetime2(7),
                    SharedWith            nvarchar(max) AS JSON,
                    ShareExpirationTime   datetime2(7)
                ) AS Record
            CROSS APPLY
                OPENJSON(Record.SharedWith)
                WITH
                (
                    SharedWithType  nvarchar(500) N'$.Type',
                    SharedWithName  nvarchar(500) N'$.Name',
                    SharedWithEmail nvarchar(500) N'$.Email'
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
