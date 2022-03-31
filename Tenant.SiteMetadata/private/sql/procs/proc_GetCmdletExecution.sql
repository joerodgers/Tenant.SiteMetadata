CREATE OR ALTER PROCEDURE [dbo].[proc_GetCmdletExecution]
	@Cmdlet nvarchar(100)
AS
BEGIN

    SELECT 
        StartDate,
        EndDate,
        ErrorCount
    FROM
        dbo.Cmdlet, 
        dbo.CmdletExecution
    WHERE
        Cmdlet.Id = CmdletExecution.CmdletId
        AND Cmdlet.Cmdlet = @Cmdlet 
    ORDER BY 
        CmdletExecution.Id DESC
END
