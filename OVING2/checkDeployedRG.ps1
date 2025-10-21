<#
.SYNOPSIS
  Lists all Azure Resource Groups containing 'jfk' in their name.

.DESCRIPTION
  This script queries Azure for all resource groups whose names contain
  a specific prefix (default: 'jfk') and prints them to the console.

.EXAMPLE
  .\Check-DeployedRG.ps1
#>

param (
    [string]$Prefix = "jfk"
)

Write-Host "Checking active resource groups containing prefix '$Prefix'..."

try {
    $rgList = az group list --query "[?contains(name, '$Prefix')].name" -o tsv 2>$null
} catch {
    Write-Error "Failed to query Azure resource groups. Make sure you are logged in (az login)."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($rgList)) {
    Write-Host "No resource groups found with prefix '$Prefix'."
} else {
    Write-Host "Found the following resource groups:" -ForegroundColor Cyan
    $rgList -split "`n" | ForEach-Object { Write-Host " - $_" }
}

Write-Host ""
Write-Host "Done."
