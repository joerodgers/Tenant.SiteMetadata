CREATE OR ALTER VIEW dbo.UserPrincipals
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(6,3)
