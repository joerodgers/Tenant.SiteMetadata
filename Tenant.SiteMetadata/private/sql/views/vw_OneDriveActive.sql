CREATE OR ALTER VIEW dbo.OneDriveActive
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(2,1)

