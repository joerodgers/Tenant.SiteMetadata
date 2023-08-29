CREATE OR ALTER PROCEDURE site.proc_AddOrUpdateSiteAdministrator
    @json nvarchar(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH
        json_cte
        AS
        (
            SELECT 
                SiteId,
                LoginName
            FROM 
                OPENJSON (@json, N'lax $') WITH 
                (
                    SiteId    uniqueidentifier N'$.SiteId',
                    LoginName nvarchar(500)    N'$.LoginName'
                )
        )
        ,
        site_administrator_cte
        AS
        (
            SELECT
                json_cte.SiteId, principal.UserPrincipalActive.ObjectId AS 'PrincipalId'
            FROM
                json_cte
                LEFT OUTER JOIN principal.UserPrincipalActive ON principal.UserPrincipalActive.UserPrincipalName = json_cte.loginname -- join input loginname to UserPrincipal table to find user's ObjectId, NULL matches are tossed out
            WHERE
                ObjectId IS NOT NULL

            UNION

            SELECT
                json_cte.SiteId, LoginName AS 'PrincipalId'
            FROM
                json_cte
            WHERE
                json_cte.LoginName NOT LIKE '%@%' -- no @ sign in the loginname means the value is a group's ObjectId
        )


    DELETE FROM
        site.Administrator
    WHERE
        SiteId IN (SELECT SiteId FROM site_administrator_cte)



    ;WITH
        json_cte
        AS
        (
            SELECT 
                SiteId,
                LoginName
            FROM 
                OPENJSON (@json, N'lax $') WITH 
                (
                    SiteId    uniqueidentifier N'$.SiteId',
                    LoginName nvarchar(500)    N'$.LoginName'
                )
        )
        ,
        site_administrator_cte
        AS
        (
            SELECT
                json_cte.SiteId, principal.UserPrincipalActive.ObjectId AS 'PrincipalId'
            FROM
                json_cte
                LEFT OUTER JOIN principal.UserPrincipalActive ON principal.UserPrincipalActive.UserPrincipalName = json_cte.loginname -- join input loginname to UserPrincipal table to find user's ObjectId, NULL matches are tossed out
            WHERE
                ObjectId IS NOT NULL

            UNION

            SELECT
                json_cte.SiteId, LoginName AS 'PrincipalId'
            FROM
                json_cte
            WHERE
                json_cte.LoginName NOT LIKE '%@%' -- no @ sign in the loginname means the value is a group's ObjectId
        )

    INSERT INTO site.Administrator
    (
        SiteId,
        PrincipalId,
        RowCreated,
        RowUpdated
    )
    SELECT SiteId, PrincipalId, @timestamp, @timestamp  FROM site_administrator_cte

/*

    MERGE INTO site.Administrator AS Existing
    USING site_administrator_cte AS New
    ON New.SiteId = Existing.SiteId AND New.PrincipalId = Existing.PrincipalId
        
    WHEN MATCHED THEN
        UPDATE SET
            RowUpdated = @timestamp
    WHEN NOT MATCHED THEN 
        INSERT
        (
            SiteId,
            PrincipalId,
            RowCreated,
            RowUpdated
        )
        VALUES
        (
            SiteId,
            PrincipalId,
            @timestamp,
            @timestamp
        )
    WHEN NOT MATCHED BY SOURCE AND Existing.SiteId IN (SELECT SiteId FROM site_administrator_cte) THEN
        DELETE
   --OUTPUT DELETED.*, $action AS [Action], INSERTED.* ;
    ;
*/
END