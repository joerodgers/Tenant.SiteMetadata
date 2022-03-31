IF OBJECT_ID('dbo.RestrictedToRegion', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.RestrictedToRegion
	(
		[Id]               int           NOT NULL,
		RestrictedToRegion nvarchar(255) NOT NULL,
		CONSTRAINT [PK_RestrictedToRegion_Id] PRIMARY KEY CLUSTERED (Id ASC)
	)
	INSERT INTO RestrictedToRegion (Id, RestrictedToRegion ) VALUES ( 0, 'NoRestriction' )
	INSERT INTO RestrictedToRegion (Id, RestrictedToRegion ) VALUES ( 1, 'BlockMoveOnly' )
	INSERT INTO RestrictedToRegion (Id, RestrictedToRegion ) VALUES ( 2, 'BlockFull'     )
	INSERT INTO RestrictedToRegion (Id, RestrictedToRegion ) VALUES ( 3, 'Unknown'       )
END	