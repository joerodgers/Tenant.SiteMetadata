CREATE OR ALTER VIEW principal.GroupPrincipalActive
AS
    SELECT  
        *
    FROM
        principal.GroupPrincipal
    WHERE   
        DeletedDateTime IS NOT NULL
