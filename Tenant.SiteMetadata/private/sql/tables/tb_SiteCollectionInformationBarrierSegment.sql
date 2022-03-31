IF OBJECT_ID('dbo.SiteCollectionInformationBarrierSegment', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SiteCollectionInformationBarrierSegment
	(
		[SiteId]                       uniqueidentifier NOT NULL,
		[InformationBarrierSegmentId]  uniqueidentifier NOT NULL
		CONSTRAINT [PK_SiteCollectionInformationBarrierSegment_SiteIdInformationBarrierSegmentId] PRIMARY KEY CLUSTERED (SiteId ASC, InformationBarrierSegmentId ASC)
	)
END