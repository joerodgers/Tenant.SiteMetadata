IF OBJECT_ID('site.LockState', 'U') IS NULL
BEGIN

    CREATE TABLE site.LockState
    (
        Id         int           NOT NULL,
        LockState  nvarchar(100) NOT NULL,
        RowCreated datetime2(7)  NOT NULL,
        RowUpdated datetime2(7)  NOT NULL,
        CONSTRAINT PK_LockState_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.LockState (Id, LockState, RowCreated, RowUpdated ) VALUES (-1, 'Unknown',   @timestamp, @timestamp )
    INSERT INTO site.LockState (Id, LockState, RowCreated, RowUpdated ) VALUES ( 1, 'Unlock',    @timestamp, @timestamp )
    INSERT INTO site.LockState (Id, LockState, RowCreated, RowUpdated ) VALUES ( 2, 'ReadOnly',  @timestamp, @timestamp )
    INSERT INTO site.LockState (Id, LockState, RowCreated, RowUpdated ) VALUES ( 3, 'NoAccess',  @timestamp, @timestamp )

END