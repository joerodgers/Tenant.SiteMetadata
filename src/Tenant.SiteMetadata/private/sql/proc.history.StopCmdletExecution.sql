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


    DELETE FROM 
        history.CmdletExecution
    WHERE   
        Id = @Id AND
        (EndDate IS NULL OR EndDate < DATEADD(DAT, -30, (CAST(GETDATE() AS DATE))))

END
