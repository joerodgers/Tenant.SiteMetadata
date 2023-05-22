CREATE OR ALTER VIEW sharepoint.SiteCollectionVisibilityPublic
AS
    SELECT  
        s.*,
        g.IsPublic
    FROM
        principal.GroupPrincipalActive g, 
        site.SiteCollection s
    WHERE   
        g.ObjectId = s.GroupId AND g.IsPublic = 1 AND DeletedDate IS NOT NULL AND Template NOT LIKE 'SPS%'
