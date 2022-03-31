CREATE OR ALTER PROCEDURE [dbo].[proc_AddCmdlet]
	@Cmdlet nvarchar(100)
AS
BEGIN
    IF NOT EXISTS( SELECT 1 FROM dbo.Cmdlet WHERE Cmdlet = @Cmdlet)
    BEGIN
        INSERT INTO dbo.Cmdlet
        (
            Cmdlet
        ) 
        VALUES
        (
            @Cmdlet
        )
    END
END
