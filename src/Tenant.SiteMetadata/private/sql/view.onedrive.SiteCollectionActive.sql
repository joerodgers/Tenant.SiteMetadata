CREATE OR ALTER VIEW onedrive.SiteCollectionActive
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        Template LIKE 'SPS%' AND DeletedDate IS NULL

