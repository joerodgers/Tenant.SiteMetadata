[Flags()]
enum PrincipalType {
    Unknown       =  1
    Member        =  2
    Guest         =  4
    M365Group     =  8
    SecurityGroup =  16
}

[Flags()]
enum ObjectStatus {
    Active    = 1
    Deleted   = 2
}

[Flags()]
enum SiteType {
    SharePoint      = 1
    OneDrive        = 2
    Teams           = 4
    Group           = 8
    All             = 15
}
