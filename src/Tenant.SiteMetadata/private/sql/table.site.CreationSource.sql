IF OBJECT_ID('site.SiteCreationSource', 'U') IS NULL
BEGIN
    CREATE TABLE site.SiteCreationSource
    (
        Id                 uniqueidentifier NOT NULL,
        SiteCreationSource nvarchar(100)  NOT NULL,
        RowCreated         datetime2(7)   NOT NULL,
        RowUpdated         datetime2(7)   NOT NULL,
        CONSTRAINT PK_SiteCreationSource_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000000-0000-0000-0000-000000000000', 'Unknown',                    @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('a958918c-a597-4058-8ac8-8a98b6e58b45', 'SharePoint start page',      @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('55cff85e-f373-4768-a7c8-56e7e318e760', 'OneDrive',                   @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('39966a89-5583-4e7f-a348-af1bf160ae49', 'SharePoint admin center',    @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('36d0e864-21ac-40c2-bb7e-7902c1d57c4a', 'PowerShell',                 @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('62aeb6b0-f7c5-4659-9f0a-0e08978661ff', 'API',                        @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('70fbaeeb-90ae-4a83-bec4-72273ea97b89', 'Migration',                  @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('37c03f2d-ef6a-4baf-b79d-58ab39757312', 'Hub site',                   @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('2042b5d3-c5ec-41d1-b13c-0e53936c2c67', 'Microsoft 365 group',        @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000003-0000-0ff1-ce00-000000000000', 'SharePoint app',             @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000002-0000-0ff1-ce00-000000000000', 'Outlook',                    @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000003-0000-0000-c000-000000000000', 'Microsoft 365 group',        @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('cc15fd57-2c6c-4117-a88c-83b1d56b4bbe', 'Microsoft Teams',            @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000005-0000-0ff1-ce00-000000000000', 'Yammer',                     @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('09abbdfd-ed23-44ee-a2d9-a627aa1c90f3', 'Planner',                    @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('410e0a1c-77e2-4166-b91c-ba5cec4f658d', 'PnP provisioning',           @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('03cd98f4-670d-44c4-8866-1a9a93079b6c', 'Microsoft',                  @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('74658136-14ec-4630-ad9b-26e160ff0fc6', 'My AAD Portal',              @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('65d91a3d-ab74-42e6-8a2f-0add61688c74', 'My Apps portal',             @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('de8bc8b5-d9f9-48b1-a8ad-b748da725064', 'Graph Explorer',             @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000006-0000-0ff1-ce00-000000000000', 'Microsoft 365 admin center', @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('f53895d3-095d-408f-8e93-8f94b391404e', 'Project',                    @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('2634dd23-5e5a-431c-81ca-11710d9079f4', 'Microsoft Stream',           @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('00000009-0000-0000-c000-000000000000', 'Power BI',                   @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('12128f48-ec9e-42f0-b203-ea49fb6af367', 'Microsoft Teams PowerShell', @timestamp, @timestamp )
    INSERT INTO site.SiteCreationSource (Id, SiteCreationSource, RowCreated, RowUpdated ) VALUES ('cf53fce8-def6-4aeb-8d30-b158e7b1cf83', 'Microsoft Stream',           @timestamp, @timestamp )

END