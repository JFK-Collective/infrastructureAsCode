# Parametere
param(
    [Parameter(Mandatory=$true)]
    [string]$KeyVaultName,
    
    [Parameter(Mandatory=$true)]
    [string]$TfvarsFilePath,
    
    [Parameter(Mandatory=$true)]
    [string]$SecretName
)

# Les hele filen som tekst
$fileContent = Get-Content -Path $TfvarsFilePath -Raw

# Lagre til Key Vault
az keyvault secret set `
    --vault-name $KeyVaultName `
    --name $SecretName `
    --value $fileContent

Write-Host "✓ Hele filen '$TfvarsFilePath' er lagret som secret '$SecretName' i Key Vault '$KeyVaultName'"

$vaultName = "kv-tfstate-jfk"
>> 
>> # Loop through all .tfvars files and upload them Base64-encoded
>> Get-ChildItem -Filter "*.tfvars" | ForEach-Object {
>>     $envName = $_.BaseName  # "dev", "test", or "prod"
>>     $b64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($_.FullName))
>>     Write-Host "Uploading $envName.tfvars to Key Vault..."
>>     az keyvault secret set --vault-name $vaultName --name "$envName-tfvars-oblig2" --value $b64 | Out-Null
>> }
>> 
>> Write-Host "✅ All .tfvars uploaded to Key Vault as Base64."
>> 