CREATE OR ALTER VIEW dbo.OneDriveDeleted
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(2,2)

