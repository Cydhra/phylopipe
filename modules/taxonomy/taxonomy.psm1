Import-Module $PSScriptRoot/../mongodb

function Get-Taxonomy {
    param(
        [Parameter(Mandatory = $true, Position=0)]
        [string] $TaxId
    )

    Invoke-MongoSh -- --eval "db.node_hierarchy.find_one({ `"tax_id`": $TaxId })"
}