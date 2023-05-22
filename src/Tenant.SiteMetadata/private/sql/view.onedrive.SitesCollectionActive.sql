CREATE OR ALTER VIEW onedrive.SitesCollectionActive
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        Template LIKE 'SPS%' AND DeletedDate IS NULL

