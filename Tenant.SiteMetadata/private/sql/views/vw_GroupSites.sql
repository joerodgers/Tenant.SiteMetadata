CREATE OR ALTER VIEW dbo.GroupsSites
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(8, 3)