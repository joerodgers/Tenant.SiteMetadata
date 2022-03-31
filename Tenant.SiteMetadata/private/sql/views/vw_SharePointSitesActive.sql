CREATE OR ALTER VIEW dbo.SharePointSitesActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(13,1)
        
