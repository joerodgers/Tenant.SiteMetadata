CREATE OR ALTER VIEW dbo.SitesRedirector
AS
    SELECT
        *
    FROM            
        dbo.tvf_Sites(15,1)
    WHERE
        Template LIKE 'RedirectSite%'