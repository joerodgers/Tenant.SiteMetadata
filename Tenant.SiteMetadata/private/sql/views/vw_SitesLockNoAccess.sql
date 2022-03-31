CREATE OR ALTER VIEW dbo.SitesLockedNoAccess
AS
    SELECT
        *
    FROM            
        dbo.tvf_Sites(15,1)
    WHERE
        LockState = 3
