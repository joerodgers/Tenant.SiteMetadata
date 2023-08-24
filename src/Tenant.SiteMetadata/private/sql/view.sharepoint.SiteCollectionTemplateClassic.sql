CREATE OR ALTER VIEW sharepoint.SiteCollectionTemplateClassic
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND Template = 'STS#0'