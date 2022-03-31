CREATE OR ALTER PROCEDURE [dbo].[proc_GetCmdletDeltaToken]
    @Cmdlet nvarchar(100)
AS
BEGIN

    SELECT
        DeltaToken
    FROM
        dbo.Cmdlet
    WHERE
        Cmdlet.Cmdlet = @Cmdlet 

END
