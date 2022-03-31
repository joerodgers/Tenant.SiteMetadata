CREATE OR ALTER VIEW dbo.M365GroupPrincipals
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(8,3)
