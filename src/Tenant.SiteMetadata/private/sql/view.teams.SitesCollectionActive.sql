CREATE OR ALTER VIEW teams.SitesCollectionActive
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        IsTeamsConnected = 1 AND DeletedDate IS NULL

