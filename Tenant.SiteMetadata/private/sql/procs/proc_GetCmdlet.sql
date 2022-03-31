CREATE OR ALTER PROCEDURE [dbo].[proc_GetCmdlet]
	@Cmdlet nvarchar(100)
AS
BEGIN

    EXEC proc_AddCmdlet @Cmdlet
    
    SELECT 
        Id, Cmdlet
    FROM
        dbo.Cmdlet
    WHERE
        Cmdlet = @Cmdlet

END
