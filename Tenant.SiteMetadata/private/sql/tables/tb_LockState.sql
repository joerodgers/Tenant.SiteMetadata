IF OBJECT_ID('dbo.LockState', 'U') IS NULL
BEGIN
	-- LockState
	CREATE TABLE dbo.LockState
	(
        [Id]      int           NOT NULL,
        LockState nvarchar(100) NOT NULL,
        CONSTRAINT PK_LockState_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
	INSERT INTO LockState (Id, [LockState]) VALUES (-1, 'Unknown')
	INSERT INTO LockState (Id, [LockState]) VALUES ( 1, 'Unlock')
	INSERT INTO LockState (Id, [LockState]) VALUES ( 2, 'Read Only')
	INSERT INTO LockState (Id, [LockState]) VALUES ( 3, 'No Access')
END