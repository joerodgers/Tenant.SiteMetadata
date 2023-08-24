CREATE OR ALTER VIEW onedrive.SiteCollectionWithLegalHold
AS
    SELECT    
        *
    FROM
        onedrive.SiteCollectionActive
    WHERE
        HasHolds = 1