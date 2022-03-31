CREATE OR ALTER VIEW dbo.SitesDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(15,2)

