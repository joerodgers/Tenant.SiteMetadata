CREATE OR ALTER VIEW teams.SitesCollectionDeleted
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        IsTeamsConnected = 1 AND DeletedDate IS NOT NULL
