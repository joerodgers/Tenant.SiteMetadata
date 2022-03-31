CREATE OR ALTER VIEW dbo.OneDrive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(2,3)
