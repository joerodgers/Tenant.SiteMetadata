CREATE OR ALTER VIEW dbo.GroupsSitesActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(8,1)