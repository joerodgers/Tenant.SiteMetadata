CREATE OR ALTER VIEW dbo.SecurityGroupPrincipalsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(16,1)
