CREATE OR ALTER VIEW teams.SiteCollectionActive
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        IsTeamsConnected = 1 AND DeletedDate IS NULL

