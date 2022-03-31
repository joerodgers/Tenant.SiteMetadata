CREATE OR ALTER VIEW dbo.MemberPrincipalsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(2,1)
