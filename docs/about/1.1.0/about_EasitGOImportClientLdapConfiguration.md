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

### Credentials ([System.Management.Automation.PSCredential](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential))

### Host (String)

### Secure (String)

### Port (String)

### PagingDisabled (String)

### Queries ([System.Collections.Generic.List[PSCustomObject]](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1))

### BinaryAttributes (String[])

### MultiValueAttributes (String[])

### DoNotEncodeAttributes (String[])

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
