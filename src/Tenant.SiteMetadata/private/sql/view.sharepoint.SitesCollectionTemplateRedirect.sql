CREATE OR ALTER VIEW sharepoint.SitesCollectionTemplateRedirect
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND Template = 'REDIRECTSITE#0'
