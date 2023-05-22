CREATE OR ALTER VIEW principal.UserPrincipalDeleted
AS
    SELECT  
        *
    FROM
        principal.UserPrincipal
    WHERE   
        DeletedDateTime IS NOT NULL