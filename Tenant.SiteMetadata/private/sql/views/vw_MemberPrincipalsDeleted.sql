CREATE OR ALTER VIEW dbo.MemberPrincipalsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(2,2)
