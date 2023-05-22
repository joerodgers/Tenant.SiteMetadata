CREATE OR ALTER VIEW principal.UserPrincipalActive
AS
    SELECT  
        *
    FROM
        principal.UserPrincipal
    WHERE   
        DeletedDateTime IS NULL