CREATE OR ALTER VIEW dbo.SharePointSites
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(13,3)
        
