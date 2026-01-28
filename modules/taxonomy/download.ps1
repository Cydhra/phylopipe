# the archive download URL
$PERMANENT_URL = "https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz"

# permanent URL to an MD5 hash file to verify download integrity
$MD5_URL = "https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz.md5"

# repository root path
$REPO_ROOT = "$PSScriptRoot"

# target folder for extracted data relative to repository root
$TARGET_FOLDER = "$REPO_ROOT/data"

# target paths for various downloaded/generated files
$TAXDUMP_FILE = "$TARGET_FOLDER/taxdump.tar.gz"
$TAXDUMP_MD5_FILE = "$TARGET_FOLDER/taxdump.tar.gz.md5"
$DUMP_FOLDER = "$TARGET_FOLDER/dump"

# download archive
"downloading latest archive dump..."
curl $PERMANENT_URL --output $TAXDUMP_FILE
curl $MD5_URL --output $TAXDUMP_MD5_FILE

if (-not ((Get-FileHash $TAXDUMP_FILE -Algorithm MD5).Hash -ieq (Get-Content -Path $TAXDUMP_MD5_FILE -Delimiter " " -TotalCount 1).Trim())) {
    "archive hash does not match expected hash. Exiting..."
    exit 1
} else {
    Remove-Item -Path $TAXDUMP_MD5_FILE
    "finished."
}

# extract archive
"extracting..."
New-Item -Path $DUMP_FOLDER -Type Directory -ErrorAction SilentlyContinue
tar -xvf $TAXDUMP_FILE -C $DUMP_FOLDER
"finished."

Remove-Item -Path $TAXDUMP_FILE

# convert data into proper TSV files
function Convert-Dump {
    param (
        [Parameter(Mandatory)]
        [string]$FileName,
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string[]]$columns
    )


    $data = (Get-Content -Raw -Path "$DUMP_FOLDER/$FileName.dmp") -split "`t\|`n" | `
        ForEach-Object {
            $index = 0
            $object = New-Object PSObject
            $_ -split "`t\|`t" | ForEach-Object {
                $object | Add-Member -MemberType NoteProperty -Name $columns[$index] -Value $_
                $index += 1
            }
            $object
        } | `
        Export-Csv -Path "$TARGET_FOLDER/$FileName.csv" -UseQuotes Always

    "converted $FileName."
    $data
}

Convert-Dump -FileName "nodes" "tax_id", "parent_tax_id", "rank", "locus_prefix", "division_id", `
    "inherit_div", "genetic_code", "inherit_gc", "mito_genetic_code", "inherit_mgc", "genbank_hidden", `
    "hidden_root", "comments"
Convert-Dump -FileName "names" "tax_id", "name_txt", "unique_name", "name_class"
Convert-Dump -FileName "division" "division_id", "division_cde", "division_name", "comments"
Convert-Dump -FileName "gencode" "gen_code_id", "abbreviation", "name", "cde", "starts"
Convert-Dump -FileName "delnodes" "tax_id"
Convert-Dump -FileName "merged" "old_tax_id", "new_tax_id"
Convert-Dump -FileName "citations" "cit_id", "cit_key", "pubmed_id", "medline_id", "url", "text", "taxid_list"
Convert-Dump -FileName "images" "image_id", "image_key", "url", "license", "attribution", "source", "properties", "taxid_list"
Remove-Item -Path $DUMP_FOLDER -Recurse