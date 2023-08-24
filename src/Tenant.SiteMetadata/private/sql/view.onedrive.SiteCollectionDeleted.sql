CREATE OR ALTER VIEW onedrive.SiteCollectionDeleted
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        Template LIKE 'SPS%' AND DeletedDate IS NOT NULL

