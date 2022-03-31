CREATE OR ALTER VIEW dbo.MemberPrincipals
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Principals(2,3)
