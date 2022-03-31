CREATE OR ALTER VIEW dbo.TeamsDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(4,2)
        
