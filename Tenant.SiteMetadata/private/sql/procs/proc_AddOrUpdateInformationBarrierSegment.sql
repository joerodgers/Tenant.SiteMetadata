CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdateInformationBarrierSegment]
	@Id                        uniqueidentifier,
	@InformationBarrierSegment nvarchar(450)
AS
BEGIN
    IF NOT EXISTS( SELECT 1 FROM dbo.InformationBarrierSegment WHERE Id = @Id )
    BEGIN
        INSERT INTO dbo.InformationBarrierSegment 
        (
            Id, 
            InformationBarrierSegment
		) 
        VALUES
        (
			@Id,
			@InformationBarrierSegment
		)
    END
    ELSE
    BEGIN
        UPDATE 
            dbo.InformationBarrierSegment 
        SET 
            InformationBarrierSegment = @InformationBarrierSegment
        WHERE
            Id = @Id
    END
END
