CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdatePrincipalManager]
	@PrincipalObjectId uniqueidentifier,
	@ManagerObjectId   uniqueidentifier
AS
BEGIN

	-- make sure both principals are present in the principal table
    IF NOT EXISTS( SELECT 1 FROM  dbo.Principal WHERE ObjectId = @PrincipalObjectId ) OR 
	   NOT EXISTS( SELECT 1 FROM  dbo.Principal WHERE ObjectId = @ManagerObjectId   )
	BEGIN
		RETURN 0
	END
	
    IF NOT EXISTS( SELECT 1 FROM  dbo.PrincipalManager WHERE PrincipalObjectId = @PrincipalObjectId )
	BEGIN
        INSERT INTO dbo.PrincipalManager
        (
            PrincipalObjectId,
			ManagerObjectId
		) 
        VALUES
        (
			@PrincipalObjectId,
			@ManagerObjectId
		)
    END
    ELSE
    BEGIN
        UPDATE 
            dbo.PrincipalManager 
        SET 
            ManagerObjectId = @ManagerObjectId
        WHERE
            PrincipalObjectId = @PrincipalObjectId 
    END
END
