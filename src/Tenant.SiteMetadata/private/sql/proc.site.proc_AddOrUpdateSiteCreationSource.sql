CREATE OR ALTER PROCEDURE site.proc_AddOrUpdateSiteCreationSource
	@json nvarchar(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH sources AS
    (
        SELECT
            Id,
            SiteCreationSource,
            RowUpdated = @timestamp
        FROM 
            OPENJSON (@json, N'$') WITH 
            (
                Id                 uniqueidentifier N'$.Id',
                SiteCreationSource nvarchar(100)    N'$.SiteCreationSource'
            )
    )

    MERGE INTO site.SiteCreationSource AS Existing
    USING sources AS New
    ON New.Id = Existing.Id
    WHEN MATCHED THEN
        UPDATE SET
            Existing.SiteCreationSource = ISNULL(New.SiteCreationSource, Existing.SiteCreationSource),
            Existing.RowUpdated         = New.RowUpdated
    WHEN NOT MATCHED THEN
        INSERT
        (
            Id, 
            SiteCreationSource, 
            RowCreated,        
            RowUpdated      
        )
        VALUES 
        (
            Id, 
            SiteCreationSource, 
            @timestamp,
            @timestamp
        );

END