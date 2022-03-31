CREATE OR ALTER PROCEDURE [dbo].[proc_StopCmdletExecution]
	@Id         int,
    @ErrorCount int = 0
AS
BEGIN

	UPDATE 
        dbo.CmdletExecution
	SET
        EndDate    = GETDATE(),
		ErrorCount = @ErrorCount
    WHERE
        Id = @Id

END
