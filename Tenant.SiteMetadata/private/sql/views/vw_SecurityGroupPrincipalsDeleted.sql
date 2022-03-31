CREATE OR ALTER VIEW dbo.SecurityGroupPrincipalsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(16,2)
        