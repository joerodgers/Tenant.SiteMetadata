CREATE OR ALTER VIEW sharepoint.SitesCollectionTemplateClassic
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND Template = 'STS#0'