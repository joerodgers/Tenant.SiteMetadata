CREATE OR ALTER VIEW sharepoint.SiteCollectionTemplateRedirect
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND Template = 'REDIRECTSITE#0'
