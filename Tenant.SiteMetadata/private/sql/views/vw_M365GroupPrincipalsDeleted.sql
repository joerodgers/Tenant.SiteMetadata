CREATE OR ALTER VIEW dbo.M365GroupPrincipalsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(8,2)
