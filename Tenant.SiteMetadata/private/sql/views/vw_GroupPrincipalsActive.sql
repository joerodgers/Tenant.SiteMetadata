CREATE OR ALTER VIEW dbo.GroupPrincipalsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(24, 1)
