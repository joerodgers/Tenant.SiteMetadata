IF (SCHEMA_ID('history') IS NULL) 
BEGIN
    EXEC ('CREATE SCHEMA [history]')
END
