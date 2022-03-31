CREATE OR ALTER VIEW dbo.TeamsActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(4,1)
        
