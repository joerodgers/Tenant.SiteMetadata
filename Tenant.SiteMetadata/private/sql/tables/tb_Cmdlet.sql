IF OBJECT_ID('dbo.Cmdlet', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.Cmdlet
	(
        [Id]                     int IDENTITY(1,1) NOT NULL,
        Cmdlet                   nvarchar(100)     NOT NULL,
        DeltaToken               nvarchar(500)     NULL,
        DeltaTokenUTCCreatedDate datetime2(2)      NULL,
        CONSTRAINT PK_Cmdlet_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
    CREATE NONCLUSTERED INDEX IX_Cmdlet_Cmdlet ON dbo.Cmdlet (Cmdlet ASC)
END