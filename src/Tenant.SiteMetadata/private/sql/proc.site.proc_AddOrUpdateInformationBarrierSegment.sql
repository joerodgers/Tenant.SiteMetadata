CREATE OR ALTER PROCEDURE [site].[proc_AddOrUpdateInformationBarrierSegment]
    @json NVARCHAR(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH segments AS
    (
        SELECT
            Id,
            InformationBarrierSegment,
            RowUpdated = @timestamp
        FROM 
            OPENJSON (@json, N'$') WITH 
            (
                Id                        uniqueidentifier N'$.ObjectId',
                InformationBarrierSegment nvarchar(500)    N'$.DisplayName'
            )
    )

    MERGE INTO site.InformationBarrierSegment AS Existing
    USING segments AS New
    ON New.Id = Existing.Id
    WHEN MATCHED THEN
        UPDATE SET
            Existing.InformationBarrierSegment = New.InformationBarrierSegment, 
            Existing.RowUpdated                = New.RowUpdated
    WHEN NOT MATCHED THEN
        INSERT
        (
            Id,
            InformationBarrierSegment,
            RowCreated,
            RowUpdated
        )
        VALUES 
        (
            Id,
            InformationBarrierSegment,
            @timestamp,
            @timestamp
        );
 END
