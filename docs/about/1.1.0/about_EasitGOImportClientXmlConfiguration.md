# About EasitGOImportClientJdbcConfiguration class

## DESCRIPTION

Initializes a new instance of the Import Client LDAP configuration class.

## Inheritance

\[[EasitGOImportClientConfiguration](about_EasitGOImportClientConfiguration.md)\] -> EasitGOImportClientJdbcConfiguration

## Constructors

* \[EasitGOImportClientJdbcConfiguration\]::New()

## EXAMPLES

```powershell
    [EasitGOImportClientJdbcConfiguration]::new()

    Filename             :
    ItemsPerPosting      :
    SleepBetweenPostings :
    Identifier           :
    Disabled             :
    SystemName           :
    TransformationXSL    :
    ConfigurationTags    :
```

## Properties

|Name (Datatype)|Description|
|:--|:--|
|Filename (String)|Full path to file |

## METHODS

### SetPropertyValuesFromXml (\[xml\]$XmlConfiguration)

```powershell
    $this.SetCommonProperties($XmlConfiguration.fileConfiguration)
    $this.Filename = $XmlConfiguration.fileConfiguration.Filename
```
