IF OBJECT_ID('site.TeamsChannelType', 'U') IS NULL
BEGIN

    CREATE TABLE site.TeamsChannelType
    (
        Id               int           NOT NULL,
        TeamsChannelType nvarchar(100) NOT NULL,
        RowCreated       datetime2(7)  NOT NULL,
        RowUpdated       datetime2(7)  NOT NULL,
        CONSTRAINT PK_TeamsChannelType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.TeamsChannelType (Id, TeamsChannelType, RowCreated, RowUpdated ) VALUES ( 0, 'None',            @timestamp, @timestamp )
    INSERT INTO site.TeamsChannelType (Id, TeamsChannelType, RowCreated, RowUpdated ) VALUES ( 1, 'PrivateChannel',  @timestamp, @timestamp )
    INSERT INTO site.TeamsChannelType (Id, TeamsChannelType, RowCreated, RowUpdated ) VALUES ( 2, 'SharedChannel',   @timestamp, @timestamp )
    INSERT INTO site.TeamsChannelType (Id, TeamsChannelType, RowCreated, RowUpdated ) VALUES ( 3, 'StandardChannel', @timestamp, @timestamp )

END
