CREATE OR ALTER PROCEDURE [dbo].[proc_StartCmdletExecution]
	@Cmdlet nvarchar(100)
AS
BEGIN

	EXEC proc_AddCmdlet @Cmdlet
	
	DECLARE @CmdletId INT

	SELECT
		@CmdletId = Id 
	FROM 
		dbo.Cmdlet
	WHERE	
		Cmdlet = @Cmdlet

	INSERT INTO dbo.CmdletExecution 
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
