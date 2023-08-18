# Tests

## Introduction

This document will try to explain how the tests and folders are structured. There are 2 main types of tests written for this module, function tests and module tests. Each type of test can be found in the folder with the corresponding name.

### Function tests

Function tests should only test a specific function. All functions, private and public, need to have tests. If the function depends on another function or cmdlet, that function or cmdlet have to be mocked. The mocked function should only "mock" its behavior, meaning that if the function should return a JSON string representation of an object, you can "hard code" it. This type of tests can be compared to an "unit test" (Unit testing refers to tests that verify the functionality of a specific section of code, usually at the function level. In an object-oriented environment, this is usually at the class level, and the minimal unit tests include the constructors and destructors.).

Please tag these tests with 'function' and 'public'/'private'.

#### Real function

```powershell
    function Convert-ToEasitGOJson {
        param (
            [Parameter(Mandatory)]
            [PSCustomObject]$InputObject,
            [Parameter()]
            [System.Collections.Hashtable]$Parameters
        )
        begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
        }
        process {
            if ($null -eq $Parameters) {
                try {
                    ConvertTo-Json -InputObject $InputObject
                } catch {
                    throw $_
                }
            } else {
                try {
                    ConvertTo-Json -InputObject $InputObject @Parameters
                } catch {
                    throw $_
                }
            }
        }
        end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
        }
    }
```

#### Mocked function

```powershell
    function Convert-ToEasitGOJson {
        param (
            [Parameter(Mandatory)]
            [PSCustomObject]$InputObject,
            [Parameter()]
            [System.Collections.Hashtable]$Parameters
        )
        Get-Content 'Path/to/my/file.json' -Raw
    }
```

[Mocking with Pester](https://pester.dev/docs/usage/mocking)

### Module tests

All public functions must have a "module test" and the purpose with this type of test is to verify that the functionality, and the functions and/or cmdlets it depends on, acts as expected. This type of tests can be compared to an "Integration test" (Integration testing is any type of software testing that seeks to verify the interfaces between components against a software design. Integration testing works to expose defects in the interfaces and interaction between integrated components (modules)).

There is one exception to this statement, you can and should mock 'Invoke-EasitGOWebRequest'.

Please tag these tests with 'module'.

## data directory

Contains files that can be used in tests.

## function directory

All functions tests should be saved in this location.

## module directory

All modules tests should be saved in this location.
