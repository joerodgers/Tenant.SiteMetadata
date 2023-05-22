CREATE OR ALTER VIEW sharepoint.SiteCollectionVisibilityPrivate
AS
    SELECT  
        s.*,
        g.IsPublic
    FROM
        principal.GroupPrincipalActive g, 
        site.SiteCollection s
    WHERE   
        g.ObjectId = s.GroupId AND g.IsPublic = 0 AND DeletedDate IS NULL AND Template NOT LIKE 'SPS%'
        
