CREATE OR ALTER VIEW dbo.M365GroupPrincipalsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(8,1)
