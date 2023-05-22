CREATE OR ALTER VIEW onedrive.SitesCollectionWithLegalHold
AS
    SELECT    
        *
    FROM
        onedrive.SitesCollectionActive
    WHERE
        HasHolds = 1