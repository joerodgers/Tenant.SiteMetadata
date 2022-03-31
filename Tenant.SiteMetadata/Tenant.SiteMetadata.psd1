@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'Tenant.SiteMetadata.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0.0'

    # ID used to uniquely identify this module
    GUID = 'ca5d0749-f4ba-47ed-9f9b-c8be132207f5'

    # Description of the functionality provided by this module
    Description = 'Module to download tenant site collection data to a SQL Server database'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '7.1'

    # import classes
    ScriptsToProcess = @( ".\classes\Enums.ps1", ".\classes\Classes.ps1" )

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @('bin\Tenant.SiteMetadata.dll')
    
    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @( "Microsoft.Graph.Authentication", "PSFramework", "PnP.PowerShell" )
    
    # Functions to export from this module
    FunctionsToExport = 
        'Connect-Service',
        'Disconnect-Service',
        'Get-ConfigurationSetting',
        'Import-InformationBarrierSegment',
        'Import-PrincipalInformation',
        'Import-SensitivityLabel',
        'Import-SiteCreationSource',
        'Import-TenantSiteCollectionAdministrator',
        'Import-TenantSiteCollectionInformation',
        'Import-TimeZone',
        'Import-UsageAndActivityInformation',
        'New-Database',
        'New-DatabaseConnectionInformation',
        'New-TenantConnectionInformation',
        'Set-ConfigurationSetting',
        'Update-DatabaseSchema',
        'Import-TenantSiteCollectionInformationv2'
    }
