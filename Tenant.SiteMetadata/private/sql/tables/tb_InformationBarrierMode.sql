IF OBJECT_ID('dbo.InformationBarrierMode', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.InformationBarrierMode 
	(
		[Id]                   int           NOT NULL,
		InformationBarrierMode nvarchar(255) NOT NULL,
		CONSTRAINT [PK_InformationBarrierMode_Id] PRIMARY KEY CLUSTERED (Id ASC)
	)
	INSERT INTO InformationBarrierMode (Id, InformationBarrierMode ) VALUES ( -1, 'Unknown'        )
	INSERT INTO InformationBarrierMode (Id, InformationBarrierMode ) VALUES (  1, 'Open'           )
	INSERT INTO InformationBarrierMode (Id, InformationBarrierMode ) VALUES (  2, 'Implicit'       )
	INSERT INTO InformationBarrierMode (Id, InformationBarrierMode ) VALUES (  3, 'Explicit'       )
	INSERT INTO InformationBarrierMode (Id, InformationBarrierMode ) VALUES (  4, 'OwnerModerated' )
	INSERT INTO InformationBarrierMode (Id, InformationBarrierMode ) VALUES (  5, 'Inferred'       )
END