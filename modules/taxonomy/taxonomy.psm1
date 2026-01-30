Import-Module $PSScriptRoot/../mongosh

function Get-Taxonomy {
    param(
        [Parameter(Required = $true, Position=0)]
        [string] $TaxId
    )

    Invoke-MongoSh -- --eval "db.node_hierarchy.find_one({ `"tax_id`": $TaxId })"
}