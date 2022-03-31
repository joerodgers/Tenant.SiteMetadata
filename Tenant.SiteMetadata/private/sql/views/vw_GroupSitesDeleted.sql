CREATE OR ALTER VIEW dbo.GroupsSitesDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(8,2)