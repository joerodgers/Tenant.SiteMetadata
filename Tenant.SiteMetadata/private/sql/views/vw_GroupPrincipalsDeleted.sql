CREATE OR ALTER VIEW dbo.GroupPrincipalsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(24, 2)
