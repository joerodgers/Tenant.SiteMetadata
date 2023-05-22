using namespace System.Collections.Generic
function Get-SharePointTenantAggregatedStoreSite
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [Parameter(Mandatory=$false,ParameterSetName="Identity")]
        [ValidateSet("AggregatedStore", "AllSitesAggregatedStore")]
        [string]
        $AggregatedStore = "AggregatedStore",

        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [switch]
        $IncludeDeletedSites,

        [Parameter(Mandatory=$true,ParameterSetName="Identity")]
        [string]
        $SiteUrl,

        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [Parameter(Mandatory=$false,ParameterSetName="Identity")]
        [ValidateRange(1,5000)]
        [int]
        $PageSize = 5000
    )

    begin
    {
        $parameters = @{}

        if( $AggregatedStore -eq "AggregatedStore" )
        {
            $propertyMap = @{ 
                "GroupId"            = "GroupId"
                "HubSiteId"          = "HubSiteId"
                "RelatedGroupId"     = "RelatedGroupId"
                "SensitivityLabel"   = "SensitivityLabel"
                "SiteCreationSource" = "SiteCreationSource"
                "SiteId"             = "SiteId"
                "SiteUrl"            = "SiteUrl"
                "TemplateName"       = "Template"
                "TimeCreated"        = "CreatedDate"
                "TimeDeleted"        = "DeletedDate"
                "Title"              = "Title"
            }

            $parameters.List = "DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS"

            $viewFields = ($propertyMap.Keys | ForEach-Object { "<FieldRef Name='$_'/>" }) -join [Environment]::NewLine
        }
        else 
        {
            $propertyMap = @{ 
                LastItemModifiedDate = "LastItemModifiedDate"
                SensitivityLabel     = "SensitivityLabel"
                SiteId               = "SiteId"
                SiteUrl              = "Url"
                StorageQuota         = "StorageQuota"
                StorageUsed          = "StorageUsage"
                TemplateName         = "Template"
                TimeCreated          = "CreatedDate"
                TimeDeleted          = "DeletedDate"            
                Title                = "Title"
            }

            $parameters.List = "DO_NOT_DELETE_SPLIST_TENANTADMIN_ALL_SITES_AGGREGATED_SITECOLLECTIONS"

            $viewFields = ($propertyMap.Keys | ForEach-Object { "<FieldRef Name='$_'/>" }) -join [Environment]::NewLine
        }

        if( $PSBoundParameters.ContainsKey( "SiteUrl" )  )
        {
            $caml = "<View>
                        <Query>
                            <Where>
                                <Eq>
                                    <FieldRef Name='SiteUrl'/>
                                    <Value Type='Text'>$SiteUrl</Value>
                                </Eq>
                            </Where>
                        </Query>
                        <ViewFields>
                            $viewFields
                        </ViewFields>
                        <RowLimit Paged='TRUE'>$PageSize</RowLimit>
                    </View>"

                $parameters.Query = $caml
        }
        else
        {
            if( $IncludeDeletedSites.IsPresent )
            {
                $caml = "<View>
                            <Query>
                            </Query>
                            <ViewFields>
                                $viewFields
                            </ViewFields>
                            <RowLimit Paged='TRUE'>$PageSize</RowLimit>
                        </View>"
                
                $parameters.Query = $caml
            }
            else
            {
                $caml = "<View>
                            <Query>
                                <Where>
                                    <IsNull>
                                        <FieldRef Name='TimeDeleted'/>
                                    </IsNull>
                                </Where>
                            </Query>
                            <ViewFields>
                                $viewFields
                            </ViewFields>
                            <RowLimit Paged='TRUE'>$PageSize</RowLimit>
                        </View>"
    
                $parameters.Query = $caml
            }
        }

        # auto generate the select-object properties by building a dynamic mapping using the $propertyMap hashtable
        $properties = @( $propertyMap.Keys | ForEach-Object { @{ Name=$propertyMap[$_]; Expression=[ScriptBlock]::Create( "`$_.FieldValues.'$($_)'.ToString()" )} } )

    }
    process
    {
        Write-PSFMessage -Message "Reading items from $($parameters.List) list" -Level Verbose

        $items = Get-PnPListItem  @parameters | Select-Object $properties

        Write-PSFMessage -Message "Read $($items.Count) items from $($parameters.List) list" -Level Verbose

        return ,[System.Collections.Generic.List[PSCustomObject]]$items
    }
    end
    {
    }
}