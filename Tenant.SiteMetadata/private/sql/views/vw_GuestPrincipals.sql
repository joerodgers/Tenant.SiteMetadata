CREATE OR ALTER VIEW dbo.GuestPrincipals
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(4,3)
