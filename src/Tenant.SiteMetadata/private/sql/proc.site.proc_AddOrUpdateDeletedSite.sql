CREATE OR ALTER PROCEDURE [site].[proc_AddOrUpdateDeletedSite]
    @json nvarchar(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH sites AS
    (
        SELECT
            SiteId,
            SiteUrl,
            DeletedDate,
            RowCreated = @timestamp,
            RowUpdated = @timestamp
        FROM 
            OPENJSON (@json, N'lax $') WITH 
            (
                SiteId      uniqueidentifier N'$.SiteId',
                SiteUrl     nvarchar(450)    N'$.Url',
                DeletedDate datetime2(7)     N'$.DeletedDate'
            )
    )
   
    MERGE INTO dbo.SiteCollection AS Existing
    USING sites AS New
    ON New.SiteId = Existing.SiteId
    WHEN MATCHED THEN
        UPDATE SET
            Existing.DeletedDate = ISNULL( New.DeletedDate, Existing.DeletedDate ),
            Existing.SiteUrl     = ISNULL( New.SiteUrl,     Existing.SiteUrl ),
            Existing.RowUpdated  = New.RowUpdated
    WHEN NOT MATCHED BY TARGET THEN 
        INSERT
        (
            DeletedDate,
            SiteId,
            SiteUrl,
            RowCreated,        
            RowUpdated      
        )
        VALUES 
        (
            DeletedDate,
            SiteId,
            SiteUrl,
            @timestamp,
            @timestamp
        )
     WHEN NOT MATCHED BY SOURCE AND Existing.DeletedDate IS NOT NULL THEN
        UPDATE SET
            -- if a site has a DeletedDate value but was not in this dataset, it must be purged from the recycle bin
            Existing.IsInRecycleBin = 0;
    ;
END