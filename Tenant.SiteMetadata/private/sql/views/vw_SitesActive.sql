CREATE OR ALTER VIEW dbo.SitesActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(15,1)

