CREATE OR ALTER PROCEDURE dbo.proc_AddOrUpdateSiteCreationSource
	@Id                 uniqueidentifier,
	@SiteCreationSource nvarchar(100)
AS
BEGIN

    IF NOT EXISTS( SELECT 1 FROM  dbo.SiteCreationSource WHERE Id = @Id)
    BEGIN
        INSERT INTO dbo.SiteCreationSource 
        (
            Id, 
            SiteCreationSource
        ) 
        VALUES
        (
            @Id, 
            @SiteCreationSource
        )
    END
    ELSE
    BEGIN
        UPDATE 
            dbo.SiteCreationSource 
        SET 
            SiteCreationSource = @SiteCreationSource
        WHERE
            Id = @Id 
    END
END