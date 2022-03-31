CREATE OR ALTER PROCEDURE [dbo].[proc_DeleteCmdletExecution]
	@Id int
AS
BEGIN

	DELETE FROM 
        dbo.CmdletExecutionHistory 
    WHERE
        Id = @Id
END
