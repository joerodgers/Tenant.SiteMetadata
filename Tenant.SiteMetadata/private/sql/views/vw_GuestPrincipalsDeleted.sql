CREATE OR ALTER VIEW dbo.GuestPrincipalsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(4,2)
