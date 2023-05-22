IF (SCHEMA_ID('onedrive') IS NULL) 
BEGIN
    EXEC ('CREATE SCHEMA [onedrive]')
END
