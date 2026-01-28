Import-Module $PSScriptRoot/../mongodb

$REPO_ROOT = "$PSScriptRoot"

function Import-Collection {
    param(
        [string]$name,
        [string]$file="$REPO_ROOT/data/$name.csv",
        [string]$database="taxonomy",
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string[]]$upsert_fields
    )

    Import-Mongo $database $name -- --parseGrace skipRow --type csv --mode upsert --upsertFields ($upsert_fields -join ",") --headerline $file
}

Start-Mongo
Import-Collection -name "citations" -upsert_fields "cit_id"
Import-Collection -name "delnodes" -upsert_fields "tax_id"
Import-Collection -name "division" -upsert_fields "division_id"
Import-Collection -name "gencode" -upsert_fields "gen_code_id"
Import-Collection -name "images" -upsert_fields "image_id"
Import-Collection -name "merged" -upsert_fields "old_tax_id", "new_tax_id"
Import-Collection -name "names" -upsert_fields "tax_id", "name_txt"
Import-Collection -name "nodes" -upsert_fields "tax_id"
Stop-Mongo