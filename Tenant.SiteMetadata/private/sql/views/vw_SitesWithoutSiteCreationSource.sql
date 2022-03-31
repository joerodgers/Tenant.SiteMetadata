CREATE OR ALTER VIEW dbo.SitesWithoutSiteCreationSource
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(15,1)
    WHERE   
            CreatedDate IS NOT NULL
        AND CreatedDate >= '2020-09-01'
        AND (SiteCreationSource IS NULL OR SiteCreationSource = '00000000-0000-0000-0000-000000000000')
        AND Template NOT LIKE 'RedirectSite%'