namespace Tenant.SiteMetadata.Enums
{
    [Flags]
    public enum SiteCollectionType
    {
        SharePoint = 1,
        OneDrive = 2,
        Teams = 4,
        M365Group = 8,
        All = 15
    }
}
