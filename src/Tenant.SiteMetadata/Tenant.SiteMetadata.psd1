@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'Tenant.SiteMetadata.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.0.10'

    # ID used to uniquely identify this module
    GUID = 'ca5d0749-f4ba-47ed-9f9b-c8be132207f5'

    # Description of the functionality provided by this module
    Description = 'Module to download tenant site collection data to a SQL Server database'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '7.2'

    # import classes
    ScriptsToProcess = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @( 
            'bin\Tenant.SiteMetadata.dll'
            'bin\Microsoft.Identity.Client.dll'
            'bin\Microsoft.Identity.Web.Diagnostics.dll'
            'bin\Microsoft.Identity.Web.TokenCache.dll'
            'bin\Microsoft.IdentityModel.Abstractions.dll'
            'bin\Microsoft.Extensions.Logging.dll'
            'bin\Microsoft.Extensions.Logging.Abstractions.dll'
            'bin\Microsoft.Extensions.DependencyInjection.dll'
            'bin\Microsoft.Extensions.DependencyInjection.Abstractions.dll'
            'bin\Microsoft.Extensions.Options.dll'
            'bin\Microsoft.Extensions.Caching.Memory.dll'
            'bin\Microsoft.Extensions.Caching.Abstractions.dll'
            'bin\Microsoft.Extensions.Primitives.dll'
            'bin\Microsoft.AspNetCore.DataProtection.Abstractions.dll'
        )
    
    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @( 
            "Microsoft.Graph.Authentication", 
            "Microsoft.Graph.Users", 
            "Microsoft.Graph.Groups", 
            "PSFramework", 
            "PnP.PowerShell" 
        )
    
    # Functions to export from this module
    FunctionsToExport = 
            'Connect-Service',
            'Disconnect-Service',
            'Import-InformationBarrierSegment',
            'Import-GroupPrincipal',
            'Import-UserPrincipal',
            'Import-SensitivityLabel',
            'Import-SiteCreationSource',
            'Import-SiteCollectionAdministrator',
            'Import-SiteCollection',
            'Import-TimeZone',
            'New-DatabaseConnectionInformation',
            'New-TenantConnectionInformation',
            'Update-DatabaseSchema',
            'Import-GraphDataConnectBlob',
            'Get-ServerDatabaseConnectionInformation',
            'Start-LogFileLogger',
            'Stop-LogFileLogger'
    }
