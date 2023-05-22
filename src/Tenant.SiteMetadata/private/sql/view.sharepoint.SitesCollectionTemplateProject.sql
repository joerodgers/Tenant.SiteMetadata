CREATE OR ALTER VIEW sharepoint.SitesCollectionTemplateProject
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND (Template = 'PROJECTSITE#0' OR Template = 'PWA#0')
