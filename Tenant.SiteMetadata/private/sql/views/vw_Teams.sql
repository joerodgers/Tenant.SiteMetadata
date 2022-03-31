CREATE OR ALTER VIEW dbo.Teams
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(4,3)
        
