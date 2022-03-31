CREATE OR ALTER VIEW dbo.GroupsSitesPrivate
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(8,1)
    WHERE
        IsPublic = 0