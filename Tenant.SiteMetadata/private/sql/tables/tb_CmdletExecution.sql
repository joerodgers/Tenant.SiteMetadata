IF OBJECT_ID('dbo.CmdletExecution', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.CmdletExecution
	(
        [Id]       int IDENTITY(1,1) NOT NULL,
        CmdletId   int               NOT NULL,
        StartDate  datetime2(0)      NOT NULL,
        EndDate    datetime2(0)      NULL,
        ErrorCount int               NULL
        CONSTRAINT PK_CmdletExecution_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
    CREATE NONCLUSTERED INDEX IX_CmdletExecution_CmdletId ON dbo.CmdletExecution (CmdletId ASC)
END
