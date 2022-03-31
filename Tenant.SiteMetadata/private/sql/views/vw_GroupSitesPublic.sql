CREATE OR ALTER VIEW dbo.GroupsSitesPublic
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(8,1)
    WHERE
        IsPublic = 1