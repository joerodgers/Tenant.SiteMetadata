CREATE OR ALTER VIEW dbo.SiteByTemplate
AS
    SELECT
        [Template], COUNT(*) AS 'Count'
    FROM            
        dbo.tvf_Sites(15,1)
    GROUP BY    
        [Template]
