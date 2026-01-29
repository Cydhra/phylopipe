Push-Location $PSScriptRoot

# make sure mongodb is installed
& ../mongodb/install.ps1

# load config
. ..\..\config.ps1

Import-Module $PSScriptRoot/../mongodb

& ./download.ps1

Start-Mongo
Import-MongoConfiguration "create_indices.js"
& ./import.ps1
Import-MongoConfiguration "aggregate_hierarchy.js"
Stop-Mongo

Pop-Location
Write-Host "Done."