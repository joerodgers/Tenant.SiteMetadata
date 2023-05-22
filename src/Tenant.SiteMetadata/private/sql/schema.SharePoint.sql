IF (SCHEMA_ID('sharepoint') IS NULL) 
BEGIN
    EXEC ('CREATE SCHEMA [sharepoint]')
END