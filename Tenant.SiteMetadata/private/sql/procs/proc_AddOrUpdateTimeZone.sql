CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdateTimeZone]
	@Id          int,
	@Identifier  nvarchar(100),
	@Description nvarchar(100)
AS
BEGIN
    IF NOT EXISTS( SELECT 1 FROM dbo.TimeZone WHERE Id = @Id)
    BEGIN
        INSERT INTO dbo.TimeZone 
		(
            Id, 
            Identifier,
			[Description]
		) 
        VALUES 
		(
            @Id, 
            @Identifier,
            @Description
		)
    END
    ELSE
    BEGIN
        UPDATE 
            dbo.TimeZone 
        SET 
            Identifier    = @Identifier,
            [Description] = @Description
        WHERE
            Id = @Id 
    END
END