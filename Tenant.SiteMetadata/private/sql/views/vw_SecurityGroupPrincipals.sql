CREATE OR ALTER VIEW dbo.SecurityGroupPrincipals
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(16,3)
