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

    ConnectionString     :
    Query                :
    DriverClassName      :
    ItemsPerPosting      :
    SleepBetweenPostings :
    Identifier           :
    Disabled             :
    SystemName           :
    TransformationXSL    :
    ConfigurationTags    :
```

## Properties

### ConnectionString (String)

### Query (String)

### DriverClassName (String)

## METHODS

### SetPropertyValuesFromXml (\[xml\]$XmlConfiguration)

```powershell
    $this.SetCommonProperties($XmlConfiguration.jdbcConfiguration)
    $this.ConnectionString = $XmlConfiguration.jdbcConfiguration.ConnectionString
    $this.Query = $XmlConfiguration.jdbcConfiguration.Query
    $this.DriverClassName = $XmlConfiguration.jdbcConfiguration.DriverClassName
```
