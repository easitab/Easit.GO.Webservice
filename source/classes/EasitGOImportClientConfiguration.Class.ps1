<#
.SYNOPSIS
    Initializes a new instance of the ImportClient configuration base class.
.DESCRIPTION
    Initializes a new instance of the ImportClient configuration base class. This base class provides base properties and methods for the *EasitGOImportClientLdapConfiguration*, *EasitGOImportClientJdbcConfiguration* and *EasitGOImportClientXmlConfiguration* classes.

    This class should not be used directly, instead use the previously mentioned classes.
.EXAMPLE
    [EasitGOImportClientConfiguration]::new()

    ItemsPerPosting      :
    SleepBetweenPostings :
    Identifier           :
    Disabled             :
    SystemName           :
    TransformationXSL    :
    ConfigurationTags    :
.EXAMPLE
    if ($ConfigurationType -eq 'ldapConfiguration') {
        [EasitGOImportClientLdapConfiguration]::New()
    } elseif ($ConfigurationType -eq 'jdbcConfiguration') {
        [EasitGOImportClientJdbcConfiguration]::New()
    } elseif ($ConfigurationType -eq 'fileConfiguration') {
        [EasitGOImportClientXmlConfiguration]::New()
    } else {
        throw "Unknown configuration type"
    }
#>
Class EasitGOImportClientConfiguration {
    [String]$ItemsPerPosting
    [String]$SleepBetweenPostings
    [String]$Identifier
    [String]$Disabled
    [String]$SystemName
    [String]$TransformationXSL
    [String[]]$ConfigurationTags
    [void] SetProperty ($Name,$Value) {
        if ($this.GetPropertyByName($Name)) {
            $this."$Name" = $Value
        } else {
            throw "Unknow property ($Name)"
        }
    }
    [String] GetPropertyByName ($Name) {
        try {
            return Get-Member -InputObject $this -Name $Name
        } catch {
            throw $_
        }
    }
    [String] GetPropertyValueByName ($Name) {
        if (Get-Member -InputObject $this -Name $Name) {
            return $this."$Name"
        } else {
            throw "Unknown property ($Name)"
        }
    }
    [PSCustomObject] ToPSCustomObject () {
        $returnObject = @{}
        foreach ($property in $this.psobject.properties.GetEnumerator()) {
            $returnObject.Add("$($property.Name)",$this."$($property.Name)")
        }
        return [PSCustomObject]$returnObject 
    }
    [System.Collections.Generic.List[String]] ConvertCommaSeperatedStringToList ([String]$String) {
        $strings = [System.Collections.Generic.List[String]]::new()
        [String[]]$split = $String -split ','
        if ($split.Count -eq 1) {
            $strings.Add($split)
        }
        if ($split.Count -gt 1) {
            $strings.AddRange($split)
        }
        return $strings
    }
    [System.Collections.Generic.List[PSCustomObject]] GetLdapQueries ($Queries) {
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
    }
    [System.Management.Automation.PSCredential] NewCredentialObject ([String]$Username,[String]$Password) {
        [securestring]$secString = ConvertTo-SecureString $Password -AsPlainText -Force
        $credObject = New-Object System.Management.Automation.PSCredential ($Username, $secString)
        return $credObject
    }
    [System.Collections.Generic.List[String]] GetConfigurationTags ($Tags) {
        $configTags = [System.Collections.Generic.List[String]]::new()
        foreach ($tag in $Tags.GetEnumerator()) {
            try {
                $configTags.Add($tag.name)
            } catch {
                Write-Warning $_
                continue
            }
        }
        return $configTags
    }
    [void] SetCommonProperties ([System.Xml.XmlElement]$configuration) {
        $this.ItemsPerPosting = $configuration.ItemsPerPosting
        $this.SleepBetweenPostings = $configuration.SleepBetweenPostings
        $this.Identifier = $configuration.Identifier
        $this.Disabled = $configuration.Disabled
        $this.SystemName = $configuration.SystemName
        $this.TransformationXSL = $configuration.TransformationXSL
        $this.ConfigurationTags = $this.GetConfigurationTags($configuration.ConfigurationTags)
    }
}
Class EasitGOImportClientLdapConfiguration : EasitGOImportClientConfiguration {
    [System.Management.Automation.PSCredential]$Credentials
    [String]$Host
    [String]$Secure
    [String]$Port
    [String]$PagingDisabled
    [System.Collections.Generic.List[PSCustomObject]]$Queries
    [String[]]$BinaryAttributes
    [String[]]$MultiValueAttributes
    [String[]]$DoNotEncodeAttributes
    [void] SetPropertyValuesFromXml ([xml]$XmlConfiguration) {
        $this.SetCommonProperties($XmlConfiguration.ldapConfiguration)
        $this.Credentials = $this.NewCredentialObject($XmlConfiguration.ldapConfiguration.username,$XmlConfiguration.ldapConfiguration.password)
        $this.Host = $XmlConfiguration.ldapConfiguration.Host
        $this.Secure = $XmlConfiguration.ldapConfiguration.Secure
        $this.Port = $XmlConfiguration.ldapConfiguration.Port
        $this.PagingDisabled = $XmlConfiguration.ldapConfiguration.PagingDisabled
        $this.Queries = $this.GetLdapQueries($XmlConfiguration.ldapConfiguration.queries)
        $this.BinaryAttributes = $this.ConvertCommaSeperatedStringToList($XmlConfiguration.ldapConfiguration.binaryAttributes.InnerText)
        $this.MultiValueAttributes = $this.ConvertCommaSeperatedStringToList($XmlConfiguration.ldapConfiguration.multiValueAttributes.InnerText)
        $this.DoNotEncodeAttributes = $this.ConvertCommaSeperatedStringToList($XmlConfiguration.ldapConfiguration.doNotEncodeAttributes.InnerText)
    }
}
Class EasitGOImportClientJdbcConfiguration : EasitGOImportClientConfiguration {
    [String]$ConnectionString
    [String]$Query
    [String]$DriverClassName
    [void] SetPropertyValuesFromXml ([xml]$XmlConfiguration) {
        $this.SetCommonProperties($XmlConfiguration.jdbcConfiguration)
        $this.ConnectionString = $XmlConfiguration.jdbcConfiguration.ConnectionString
        $this.Query = $XmlConfiguration.jdbcConfiguration.Query
        $this.DriverClassName = $XmlConfiguration.jdbcConfiguration.DriverClassName
    }
}
Class EasitGOImportClientXmlConfiguration : EasitGOImportClientConfiguration {
    [String]$Filename
    [void] SetPropertyValuesFromXml ([xml]$XmlConfiguration) {
        $this.SetCommonProperties($XmlConfiguration.fileConfiguration)
        $this.Filename = $XmlConfiguration.fileConfiguration.Filename
    }
}