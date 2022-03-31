CREATE OR ALTER VIEW dbo.Sites
AS
    SELECT        
        *
    FROM 
        dbo.tvf_Sites(15,3)
        
