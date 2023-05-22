CREATE OR ALTER PROCEDURE [site].[proc_AddOrUpdateTimeZone]
    @json nvarchar(max)
AS
BEGIN

    /*
        [
            {
                "Id":  0,
                "Identifier":  "No:ne",
                "Description":  "None"
            },
            {
                "Id":  2,
                "Identifier":  "UTC",
                "Description":  "GREENWICH MEAN TIME DUBLIN EDINBURGH LISBON LONDON"
            },
            {
                "Id":  3,
                "Identifier":  "UTC+01:00",
                "Description":  "BRUSSELS COPENHAGEN MADRID PARIS"
            }
        ]
    */

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH zones AS
    (
        SELECT
            Id,
            Identifier,
            Description,
            RowUpdated = @timestamp,
            RowCreated = @timestamp
        FROM 
            OPENJSON (@json, N'$') WITH 
            (
                Id          int           N'$.Id',
                Identifier  nvarchar(255) N'$.Identifier',
                Description nvarchar(255) N'$.Description'
            )
    )

    MERGE INTO site.TimeZone AS Existing
    USING zones AS New
    ON New.Id = Existing.Id
    WHEN MATCHED THEN
        UPDATE SET
            Existing.Identifier  = New.Identifier, 
            Existing.Description = New.Description, 
            Existing.RowUpdated  = New.RowUpdated
    WHEN NOT MATCHED BY TARGET THEN
        INSERT
        (
            Id,
            Identifier,
            Description,
            RowCreated,
            RowUpdated
        )
        VALUES 
        (
            Id,
            Identifier,
            Description,
            RowCreated,
            RowUpdated
        );
END