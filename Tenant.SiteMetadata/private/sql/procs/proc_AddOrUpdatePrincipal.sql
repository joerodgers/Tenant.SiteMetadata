CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdatePrincipal]
	@ObjectId          uniqueidentifier,
	@Identifier        nvarchar(100) = NULL,
	@DisplayName       nvarchar(500) = NULL,
	@PrincipalType     int           = NULL,
	@IsDirectorySynced bit           = NULL,
	@DeletedDate       date          = '1753-01-01'
AS
BEGIN

    IF (@DeletedDate = '1753-01-01' ) -- parameter default, use existing row value
        SELECT @DeletedDate = DeletedDate FROM dbo.Principal WHERE ObjectId = @ObjectId

    IF NOT EXISTS( SELECT 1 FROM  dbo.Principal WHERE ObjectId = @ObjectId)
    BEGIN
        INSERT INTO dbo.Principal
        (
            ObjectId, 
            Identifier,
            DisplayName,
            PrincipalType,
            IsDirectorySynced,
			DeletedDate
		) 
        VALUES
        (
			@ObjectId,
			@Identifier,
			@DisplayName,
			@PrincipalType,
			@IsDirectorySynced,
			@DeletedDate
		)
    END
    ELSE
    BEGIN
        UPDATE 
            dbo.Principal 
        SET 
            Identifier        = ISNULL(@Identifier,        Identifier ),
            DisplayName       = ISNULL(@DisplayName,       DisplayName ),
            PrincipalType     = ISNULL(@PrincipalType,     PrincipalType ),
            IsDirectorySynced = ISNULL(@IsDirectorySynced, IsDirectorySynced ),
			DeletedDate       = @DeletedDate
        WHERE
            ObjectId = @ObjectId 
    END
END