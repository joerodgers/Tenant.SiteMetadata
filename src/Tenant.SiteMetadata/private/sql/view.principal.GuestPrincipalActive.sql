CREATE OR ALTER VIEW principal.GuestPrincipalActive
AS
    SELECT  
        *
    FROM
        principal.UserPrincipal
    WHERE   
        DeletedDateTime IS NULL AND PrincipalType = 4