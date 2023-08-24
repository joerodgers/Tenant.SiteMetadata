IF OBJECT_ID('onedrive.SitesCollectionActive', 'V') IS NOT NULL 
    DROP VIEW onedrive.SitesCollectionActive

IF OBJECT_ID('onedrive.SitesCollectionDeleted', 'V') IS NOT NULL 
    DROP VIEW onedrive.SitesCollectionDeleted

IF OBJECT_ID('onedrive.SitesCollectionWithLegalHold', 'V') IS NOT NULL 
    DROP VIEW onedrive.SitesCollectionWithLegalHold

IF OBJECT_ID('sharepoint.SitesCollectionActive', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionActive

IF OBJECT_ID('sharepoint.SitesCollectionDeleted', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionDeleted

IF OBJECT_ID('sharepoint.SitesCollectionGroupConnected', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionGroupConnected

IF OBJECT_ID('sharepoint.SitesCollectionNoAccess', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionNoAccess

IF OBJECT_ID('sharepoint.SitesCollectionReadOnly', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionReadOnly

IF OBJECT_ID('sharepoint.SitesCollectionTemplateClassic', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionTemplateClassic

IF OBJECT_ID('sharepoint.SitesCollectionTemplateProject', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionTemplateProject

IF OBJECT_ID('sharepoint.SitesCollectionTemplateRedirect', 'V') IS NOT NULL 
    DROP VIEW sharepoint.SitesCollectionTemplateRedirect

IF OBJECT_ID('teams.SitesCollectionActive', 'V') IS NOT NULL 
    DROP VIEW teams.SitesCollectionActive

IF OBJECT_ID('teams.SitesCollectionDeleted', 'V') IS NOT NULL 
    DROP VIEW teams.SitesCollectionDeleted
