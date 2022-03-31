USE master

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'TenantSiteMetadata')
BEGIN 
    CREATE DATABASE [TenantSiteMetadata] 
    COLLATE SQL_Latin1_General_CP1_CI_AS;
END
