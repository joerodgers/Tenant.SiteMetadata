CREATE OR ALTER VIEW sharepoint.SiteCollectionActiveNoActiveAdministrators
AS
    SELECT
        sc.*
    FROM 
        site.SiteCollection sc
    WHERE
        sc.GroupId = '00000000-0000-0000-0000-000000000000' AND 
        sc.LockState = 1 AND
        DeletedDate IS NULL AND 
        Template NOT LIKE 'SPS%' AND
        SiteId NOT IN 
        (
            SELECT
                sc.SiteId
            FROM 
                site.SiteCollection sc,
                site.Administrator a,
                principal.UserPrincipalActive upa
            WHERE
                sc.SiteId = a.SiteId AND    
                sc.DeletedDate IS NULL AND 
                sc.Template NOT LIKE 'SPS%' AND
                a.PrincipalId = upa.ObjectId AND
                sc.GroupId = '00000000-0000-0000-0000-000000000000' AND 
                sc.LockState = 1
        ) 
