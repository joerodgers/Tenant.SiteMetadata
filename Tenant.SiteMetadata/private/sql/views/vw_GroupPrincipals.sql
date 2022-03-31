CREATE OR ALTER VIEW dbo.GroupPrincipals
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(24, 3)
