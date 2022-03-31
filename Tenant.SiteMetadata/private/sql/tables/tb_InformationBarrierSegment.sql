IF OBJECT_ID('dbo.InformationBarrierSegment', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.InformationBarrierSegment 
	(
		[Id]                       uniqueidentifier NOT NULL,
		InformationBarrierSegment nvarchar(255)    NOT NULL,
		CONSTRAINT [PK_InformationBarrierSegment_Id] PRIMARY KEY CLUSTERED (Id ASC)
	)
END