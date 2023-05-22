CREATE OR ALTER PROCEDURE [site].[proc_AddOrUpdateSensitivityLabel]
    @json nvarchar(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH labels AS
    (
        SELECT
            Id,
            SensitivityLabel,
            RowUpdated = @timestamp
        FROM 
            OPENJSON (@json, N'$') WITH 
            (
                Id               uniqueidentifier N'$.Id',
                SensitivityLabel nvarchar(100)    N'$.Name'
            )
    )

    MERGE INTO site.SensitivityLabel AS Existing
    USING labels AS New
    ON New.Id = Existing.Id
    WHEN MATCHED THEN
        UPDATE SET
            Existing.SensitivityLabel = ISNULL(New.SensitivityLabel, Existing.SensitivityLabel),
            Existing.RowUpdated       = New.RowUpdated
    WHEN NOT MATCHED THEN
        INSERT
        (
            Id, 
            SensitivityLabel, 
            RowCreated,        
            RowUpdated      
        )
        VALUES 
        (
            Id, 
            SensitivityLabel, 
            @timestamp,
            @timestamp
        );
END