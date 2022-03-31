CREATE OR ALTER VIEW dbo.OneDriveWithHolds
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(2,1)
    WHERE   
        HasHolds = 1