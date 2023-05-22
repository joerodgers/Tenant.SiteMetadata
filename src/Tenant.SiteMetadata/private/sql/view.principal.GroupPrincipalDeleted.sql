CREATE OR ALTER VIEW principal.GroupPrincipalDeleted
AS
    SELECT  
        *
    FROM
        principal.GroupPrincipal
    WHERE   
        DeletedDateTime IS NULL