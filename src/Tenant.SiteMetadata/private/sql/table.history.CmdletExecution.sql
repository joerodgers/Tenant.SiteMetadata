IF OBJECT_ID('history.CmdletExecution', 'U') IS NULL
BEGIN
    CREATE TABLE history.CmdletExecution
    (
        [Id]       int IDENTITY(1,1) NOT NULL,
        CmdletId   int               NOT NULL,
        StartDate  datetime2(0)      NOT NULL,
        EndDate    datetime2(0)      NULL,
        Host       nvarchar(255)     NULL,
        ErrorCount int               NULL,
        CONSTRAINT PK_CmdletExecution_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
    CREATE NONCLUSTERED INDEX IX_CmdletExecution_CmdletId ON history.CmdletExecution (CmdletId ASC)
END
