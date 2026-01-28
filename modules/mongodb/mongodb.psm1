Import-Module $PSScriptRoot/../conda

$DB_PATH = "$PSScriptRoot\mongodata"
$LOGPATH="$DB_PATH\mongod.log"

<#
 .SYNOPSIS
 Start a mongodb database process with the phylopipe database

 .DESCRIPTION
 Starts the mongod process in a new process to allow it running in the background until Stop-Mongo is called.
#>
function Start-Mongo {
    . (Get-CondaHook)
    $Environ = Get-CondaEnvironment
    conda activate $Environ
    Start-Process -NoNewWindow mongod -ArgumentList "--logpath $LOGPATH --dbpath $DB_PATH --bind_ip 127.0.0.1 --noauth"
}

<#
 .SYNOPSIS
 Shutdown the mongodb database process.

 .DESCRIPTION
 Uses the mongoshell to shutdown the mongo server that was previously started with Start-Mongo
#>
function Stop-Mongo {
    Invoke-InConda -- mongosh --eval 'db.getSiblingDB("admin").shutdownServer()'
}

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
        [string] $Database,

        [Parameter(Mandatory = $true)]
        [string] $Collection,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments)]
        [string[]] $Args
    )

    Invoke-InConda -- mongoimport --db $Database --collection $Collection @Args
}