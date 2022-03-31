CREATE OR ALTER VIEW dbo.SharePointSitesDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(13,2)
        
