# About EasitGOImportClientConfiguration class

## DESCRIPTION

Initializes a new instance of the Import Client configuration base class. This base class provides base properties and methods for the *EasitGOImportClientLdapConfiguration*, *EasitGOImportClientJdbcConfiguration* and *EasitGOImportClientXmlConfiguration* classes.

This class should not be used directly, instead use the previously mentioned classes.

## Constructors

* \[EasitGOImportClientConfiguration\]::New()

## EXAMPLES

```powershell
    [EasitGOImportClientConfiguration]::new()

    ItemsPerPosting      :
    SleepBetweenPostings :
    Identifier           :
    Disabled             :
    SystemName           :
    TransformationXSL    :
    ConfigurationTags    :
```

## Properties

### ItemsPerPosting (String)

### SleepBetweenPostings (String)

### Identifier (String)

### Disabled (String)

### SystemName (String)

### TransformationXSL (String)

### ConfigurationTags (String[])

## METHODS

### SetProperty ([String]$Name,$Value)

```powershell
    if ($this.GetPropertyByName($Name)) {
        $this."$Name" = $Value
    } else {
        throw "Unknow property ($Name)"
    }
```

### GetPropertyByName ([String]$Name)

```powershell
    try {
        return Get-Member -InputObject $this -Name $Name
    } catch {
        throw $_
    }
```

### GetPropertyValueByName ([String]$Name)

```powershell
    if (Get-Member -InputObject $this -Name $Name) {
        return $this."$Name"
    } else {
        throw "Unknown property ($Name)"
    }
```

### ToPSCustomObject ()

```powershell
    $returnObject = @{}
    foreach ($property in $this.psobject.properties.GetEnumerator()) {
        $returnObject.Add("$($property.Name)",$this."$($property.Name)")
    }
    return [PSCustomObject]$returnObject
```

### ConvertCommaSeperatedStringToList ([String]$String)

```powershell
    $strings = [System.Collections.Generic.List[String]]::new()
    [String[]]$split = $String -split ','
    if ($split.Count -eq 1) {
        $strings.Add($split)
    }
    if ($split.Count -gt 1) {
        $strings.AddRange($split)
    }
    return $strings
```

### GetConfigurationTags ($Tags)

```powershell
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
```

### SetCommonProperties ([System.Xml.XmlElement]$configuration)

```powershell
    $this.ItemsPerPosting = $configuration.ItemsPerPosting
    $this.SleepBetweenPostings = $configuration.SleepBetweenPostings
    $this.Identifier = $configuration.Identifier
    $this.Disabled = $configuration.Disabled
    $this.SystemName = $configuration.SystemName
    $this.TransformationXSL = $configuration.TransformationXSL
    $this.ConfigurationTags = $this.GetConfigurationTags($configuration.ConfigurationTags)
```
