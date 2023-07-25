CREATE OR ALTER PROCEDURE [history].[proc_StartCmdletExecution]
	@Cmdlet nvarchar(100),
	@Host   nvarchar(255) = null
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


	IF COL_LENGTH( 'history.CmdletExecution', 'Host' ) IS NOT NULL
	BEGIN
		INSERT INTO history.CmdletExecution 
		(
			CmdletId, 
			StartDate,
			ErrorCount,
			Host
		) 
		VALUES 
		(
			@CmdletId, 
			GETDATE(),
			0,
			@Host
		)
	END
	ELSE
	BEGIN
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
	END

	SELECT SCOPE_IDENTITY() AS 'Identity';
END
	