CREATE OR ALTER VIEW principal.GuestPrincipalDeleted
AS
    SELECT  
        *
    FROM
        principal.UserPrincipal
    WHERE   
        DeletedDateTime IS NOT NULL AND PrincipalType = 4