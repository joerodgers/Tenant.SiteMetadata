IF OBJECT_ID('dbo.SiteCreationSource', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SiteCreationSource
	(
        [Id]               uniqueidentifier NOT NULL,
        SiteCreationSource nvarchar(100)    NOT NULL,
        CONSTRAINT PK_SiteCreationSource_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
	INSERT INTO SiteCreationSource (Id, [SiteCreationSource]) VALUES ('00000000-0000-0000-0000-000000000000', 'Unknown'         )
	INSERT INTO SiteCreationSource (Id, [SiteCreationSource]) VALUES ('14D82EEC-204B-4C2F-B7E8-296A70DAB67E', 'Microsoft Graph' )
	INSERT INTO SiteCreationSource (Id, [SiteCreationSource]) VALUES ('5D9FFF84-5B34-4204-BC91-3AAF5F298C5D', 'PnP Lookbook'    )
END