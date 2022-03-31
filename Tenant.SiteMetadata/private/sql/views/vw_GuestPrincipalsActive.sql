CREATE OR ALTER VIEW dbo.GuestPrincipalsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(4,1)
