CREATE OR ALTER VIEW dbo.SitesWithHolds
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(15,1)
    WHERE   
        HasHolds = 1
