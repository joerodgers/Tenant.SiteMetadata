CREATE OR ALTER VIEW sharepoint.SiteCollectionActiveAdministrators
AS
    SELECT
        SiteUrl,
        AdministratorUPN = 
        STUFF(
        (
            SELECT 
                N'; ' + up.UserPrincipalName
            FROM 
                site.Administrator a,
                principal.UserPrincipalActive up
            WHERE
                sc.SiteId = a.SiteId AND  up.ObjectId = a.PrincipalId
            FOR XML PATH('')
        )
        , 1, 1, ''),
        AdministratorEmail = 
        STUFF(
        (
            SELECT 
                N';' + up.Mail
            FROM 
                site.Administrator a,
                principal.UserPrincipalActive up
            WHERE
                sc.SiteId = a.SiteId AND  up.ObjectId = a.PrincipalId
            FOR XML PATH('')
        )
        , 1, 1, '')
    FROM 
        site.SiteCollection sc
    WHERE
        sc.GroupId = '00000000-0000-0000-0000-000000000000' AND 
        sc.LockState = 1 AND
        DeletedDate IS NULL AND 
        Template NOT LIKE 'SPS%'
