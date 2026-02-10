Import-Module $PSScriptRoot/../mongodb

function Get-Taxonomy {
    param(
        [Parameter(Mandatory = $true, Position=0)]
        [string] $TaxId
    )

    Invoke-MongoSh -- "mongodb://127.0.0.1/taxonomy" --eval "db.nodes_hierarchy.findOne({ tax_id: $TaxId })"
}