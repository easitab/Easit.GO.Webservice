# About EasitGOImportClientLdapConfiguration class

## DESCRIPTION

Initializes a new instance of the Import Client LDAP configuration class.

## Inheritance

\[[EasitGOImportClientConfiguration](about_EasitGOImportClientConfiguration.md)\] -> EasitGOImportClientLdapConfiguration

## Constructors

* \[EasitGOImportClientLdapConfiguration\]::New()

## EXAMPLES

```powershell
    [EasitGOImportClientLdapConfiguration]::new()

    Credentials           :
    Host                  :
    Secure                :
    Port                  :
    PagingDisabled        :
    Queries               :
    BinaryAttributes      :
    MultiValueAttributes  :
    DoNotEncodeAttributes :
    ItemsPerPosting       :
    SleepBetweenPostings  :
    Identifier            :
    Disabled              :
    SystemName            :
    TransformationXSL     :
    ConfigurationTags     :
```

## Properties

|Name (Datatype)|Description|
|:--|:--|
|Credentials ([System.Management.Automation.PSCredential](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential))|Credentials used for authenticating to a source|
|Host (String)|Uri to or Hostname of LDAP server|
|Secure (String)|Specifies if connection to host should be encrypted (true/false)|
|Port (String)|The port on which the host listens|
|PagingDisabled (String)|Specifies if all responses should be fetched in one round or not. False = all responses fetched in one round|
|Queries ([System.Collections.Generic.List[PSCustomObject]](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1))|List of queries to query the host with|
|BinaryAttributes (String[])|Specifies what attributes contain binary data|
|MultiValueAttributes (String[])|Specifies what attributes that contain multiple values|
|DoNotEncodeAttributes (String[])|Specifies what attributes NOT to be encoded as a base64 string|

## METHODS

### SetPropertyValuesFromXml (\[xml\]$XmlConfiguration)

```powershell
    $this.SetCommonProperties($XmlConfiguration.ldapConfiguration)
    $this.Credentials = $this.NewCredentialObject($XmlConfiguration.ldapConfiguration.username,$this.ConvertToSecureString($XmlConfiguration.ldapConfiguration.password))
    $this.Host = $XmlConfiguration.ldapConfiguration.Host
    $this.Secure = $XmlConfiguration.ldapConfiguration.Secure
    $this.Port = $XmlConfiguration.ldapConfiguration.Port
    $this.PagingDisabled = $XmlConfiguration.ldapConfiguration.PagingDisabled
    $this.Queries = $this.GetLdapQueries($XmlConfiguration.ldapConfiguration.queries)
    $this.BinaryAttributes = $this.ConvertCommaSeperatedStringToList($XmlConfiguration.ldapConfiguration.binaryAttributes.InnerText)
    $this.MultiValueAttributes = $this.ConvertCommaSeperatedStringToList($XmlConfiguration.ldapConfiguration.multiValueAttributes.InnerText)
    $this.DoNotEncodeAttributes = $this.ConvertCommaSeperatedStringToList($XmlConfiguration.ldapConfiguration.doNotEncodeAttributes.InnerText)
```

### GetLdapQueries ($Queries)

```powershell
    $ldapQueries = [System.Collections.Generic.List[PSCustomObject]]::new()
    foreach ($query in $Queries.GetEnumerator()) {
        $queryObject = [PSCustomObject]@{
            base = $query.base
            filter = $query.filter
            attributes = $query.attributes
        }
        try {
            $ldapQueries.Add($queryObject)
        } catch {
            Write-Warning $_
            continue
        }
    }
    return $ldapQueries
```

### NewCredentialObject (\[String\]$Username,\[[SecureString](https://learn.microsoft.com/en-us/dotnet/api/system.security.securestring)\]$Password)

```powershell
    $credObject = New-Object System.Management.Automation.PSCredential ($Username, $Password)
    return $credObject
```

### ConvertToSecureString (\[String\]$InputString)

```powershell
    $secureString = ConvertTo-SecureString $InputString -AsPlainText -Force
    return $secureString
```
