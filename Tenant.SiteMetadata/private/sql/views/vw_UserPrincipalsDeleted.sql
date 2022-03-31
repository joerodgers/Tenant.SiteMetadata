CREATE OR ALTER VIEW dbo.UserPrincipalsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(6,2)

