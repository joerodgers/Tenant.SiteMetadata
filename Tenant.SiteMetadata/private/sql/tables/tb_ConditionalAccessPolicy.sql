IF OBJECT_ID('dbo.ConditionalAccessPolicy', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.ConditionalAccessPolicy
	(
        [Id]                    int           NOT NULL,
        ConditionalAccessPolicy nvarchar(100) NOT NULL,
        CONSTRAINT PK_ConditionalAccessPolicy_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
	INSERT INTO ConditionalAccessPolicy (Id, [ConditionalAccessPolicy]) VALUES (-1, 'Unknown'                )
	INSERT INTO ConditionalAccessPolicy (Id, [ConditionalAccessPolicy]) VALUES ( 0, 'Allow Full Access'      )
	INSERT INTO ConditionalAccessPolicy (Id, [ConditionalAccessPolicy]) VALUES ( 1, 'Allow Limited Access'   )
	INSERT INTO ConditionalAccessPolicy (Id, [ConditionalAccessPolicy]) VALUES ( 2, 'Block Access'           )
	INSERT INTO ConditionalAccessPolicy (Id, [ConditionalAccessPolicy]) VALUES ( 3, 'Authentication Context' )
END