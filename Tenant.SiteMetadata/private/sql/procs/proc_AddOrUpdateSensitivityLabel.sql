CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdateSensitivityLabel]
	@Id               uniqueidentifier,
	@SensitivityLabel nvarchar(50)
AS
BEGIN
    IF NOT EXISTS( SELECT 1 FROM  dbo.SensitivityLabel WHERE Id = @Id)
    BEGIN
        INSERT INTO dbo.SensitivityLabel
        (
            Id, 
            SensitivityLabel
        ) 
        VALUES
        (
            @Id, 
            @SensitivityLabel
        )
    END
    ELSE
    BEGIN
        UPDATE 
            dbo.SensitivityLabel 
        SET 
            SensitivityLabel = @SensitivityLabel
        WHERE
            Id = @Id 
    END
END