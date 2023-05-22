IF (SCHEMA_ID('principal') IS NULL) 
BEGIN
    EXEC ('CREATE SCHEMA [principal]')
END