CREATE OR ALTER VIEW dbo.UserPrincipalsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(6,1)
