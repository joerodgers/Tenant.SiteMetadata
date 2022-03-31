IF OBJECT_ID('dbo.SharingDomainRestrictionMode', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SharingDomainRestrictionMode
	(
		[Id]                         int           NOT NULL,
		SharingDomainRestrictionMode nvarchar(255) NOT NULL,
		CONSTRAINT [PK_SharingDomainRestrictionMode_Id] PRIMARY KEY CLUSTERED (Id ASC)
	)
	INSERT INTO SharingDomainRestrictionMode (Id, SharingDomainRestrictionMode ) VALUES ( 0, 'None'      )
	INSERT INTO SharingDomainRestrictionMode (Id, SharingDomainRestrictionMode ) VALUES ( 1, 'AllowList' )
	INSERT INTO SharingDomainRestrictionMode (Id, SharingDomainRestrictionMode ) VALUES ( 2, 'BlockList' )
END