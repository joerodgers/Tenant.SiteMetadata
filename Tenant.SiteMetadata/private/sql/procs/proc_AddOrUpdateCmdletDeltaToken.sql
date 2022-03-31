CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdateCmdletDeltaToken]
    @Cmdlet         nvarchar(100),
    @DeltaToken     nvarchar(1000)
AS
BEGIN

    -- ensure our cmdlet is registerd
    EXEC proc_AddCmdlet @Cmdlet

    -- set new delta token
    UPDATE 
        dbo.Cmdlet 
    SET 
        DeltaToken               = @DeltaToken,
        DeltaTokenUTCCreatedDate = GETUTCDATE()
    WHERE
        Cmdlet = @Cmdlet
END
