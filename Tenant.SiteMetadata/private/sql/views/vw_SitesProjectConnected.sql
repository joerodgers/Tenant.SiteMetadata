CREATE OR ALTER VIEW dbo.SitesProjectConnected
AS
    SELECT
        *
    FROM            
        dbo.tvf_Sites(15,1)
    WHERE
        IsProjectConnected = 1