CREATE OR ALTER PROCEDURE [history].[proc_AddCmdlet]
    @Cmdlet nvarchar(100)
AS
BEGIN
    IF NOT EXISTS( SELECT 1 FROM history.Cmdlet WHERE Cmdlet = @Cmdlet)
    BEGIN

        DECLARE @timestamp datetime2(7) = GETUTCDATE()

        INSERT INTO history.Cmdlet
        (
            Cmdlet,
            RowCreated,
            RowUpdated
        ) 
        VALUES
        (
            @Cmdlet,
            @timestamp,
            @timestamp
        )
    END
END
