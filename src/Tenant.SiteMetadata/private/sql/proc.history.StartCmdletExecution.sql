CREATE OR ALTER PROCEDURE [history].[proc_StartCmdletExecution]
	@Cmdlet nvarchar(100)
AS
BEGIN

	EXEC history.proc_AddCmdlet @Cmdlet
	
	DECLARE @CmdletId INT

	SELECT
		@CmdletId = Id 
	FROM 
		history.Cmdlet
	WHERE	
		Cmdlet = @Cmdlet

	INSERT INTO history.CmdletExecution 
	(
		CmdletId, 
		StartDate,
		ErrorCount
	) 
	VALUES 
	(
		@CmdletId, 
		GETDATE(),
		0
	)

	SELECT SCOPE_IDENTITY() AS 'Identity'; 
END
