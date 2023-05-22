CREATE OR ALTER PROCEDURE [history].[proc_StopCmdletExecution]
	@Id         int,
    @ErrorCount int = 0
AS
BEGIN

	UPDATE 
        history.CmdletExecution
	SET
        EndDate    = GETDATE(),
		ErrorCount = @ErrorCount
    WHERE
        Id = @Id

END
