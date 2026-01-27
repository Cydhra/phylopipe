Import-Module $PSScriptRoot/../conda

<#
 .SYNOPSIS
 Imports data into mongodb using mongoimport.

 .DESCRIPTION
 Calls mongoimport to import data into the provided collection. The import command has to be specified manually.

 .PARAMETER Collection
 Name of the collection where to import data.
#>
function Import-Mongo {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Collection,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments)]
        [string[]] $Args
    )

    Invoke-InConda mongoimport "--db" "TODO" "--collection" $Collection @Args
}