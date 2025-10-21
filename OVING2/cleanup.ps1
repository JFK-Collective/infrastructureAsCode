<#
.SYNOPSIS
  Finn og slett alle Azure Resource Groups hvor navnet inneholder både 'oblig2' og 'jfk'.

.DESCRIPTION
  Dette scriptet finner Resource Groups der både "oblig2" og "jfk" forekommer i navnet (case-insensitive),
  viser hvilke som treffes, og ber om én tekstbasert bekreftelse før sletting.
  Etter bekreftelsen slettes alle automatisk uten flere spørsmål.
  Viser fremdrift (… → … → …) underveis for å indikere aktivitet.

.EXAMPLE
  # Interaktiv bruk (anbefalt)
  .\Destroy-Oblig2jfkRGs.ps1

.EXAMPLE
  # Dry-run (viser hva som ville blitt slettet)
  .\Destroy-Oblig2jfkRGs.ps1 -WhatIf

.EXAMPLE
  # Automatisk sletting (ikke-interaktiv)
  .\Destroy-Oblig2jfkRGs.ps1 -Force

.NOTES
  - Du må være logget inn i Azure (Connect-AzAccount) eller ha OIDC konfigurert i runneren.
  - Sletting er irreversibelt. Bruk -WhatIf først for å verifisere.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param (
    [switch]$Force
)

function Ensure-AzModule {
    if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
        Write-Host "Az-modulen ser ikke ut til å være installert. Forsøker å importere/installere..."
        try {
            Install-Module -Name Az -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
        } catch {
            Write-Error "Kunne ikke installere Az-modulen. Installer manuelt og prøv igjen."
            throw
        }
    }
}

try {
    Ensure-AzModule
} catch {
    exit 1
}

# Hent Resource Groups
Write-Host "Henter alle Azure Resource Groups..."
try {
    $rgs = Get-AzResourceGroup -ErrorAction Stop
} catch {
    Write-Error "Feil ved henting av resource groups: $_"
    exit 2
}

# Filtrer RGs som inneholder både 'oblig2' OG 'jfk'
$matchingRGs = $rgs | Where-Object {
    $_.ResourceGroupName -imatch 'oblig2' -and $_.ResourceGroupName -imatch 'jfk'
}

if (-not $matchingRGs -or $matchingRGs.Count -eq 0) {
    Write-Host "Ingen resource groups funnet som inneholder både 'oblig2' og 'jfk'. Ingen handling utføres."
    exit 0
}

# Vis funn
Write-Host ("Fant {0} resource group(s) som matcher:" -f $matchingRGs.Count)
$matchingRGs | ForEach-Object { Write-Host " - $($_.ResourceGroupName) (Location: $($_.Location))" }

# Støtt -WhatIf
if ($PSBoundParameters.ContainsKey('WhatIf')) {
    Write-Host "WhatIf angitt — ingen slettinger utføres."
    exit 0
}

# Bekreftelse (interaktiv) hvis ikke Force
if (-not $Force) {
    Write-Host ""
    $confirmation = Read-Host "Skriv EXACT 'DELETE' for å bekrefte sletting av disse resource group-ene"
    if ($confirmation -ne 'DELETE') {
        Write-Warning "Bekreftelse avbrutt. Ingen resource groups ble slettet."
        exit 0
    }
}

# Utfør sletting uten flere bekreftelser
Write-Host ""
Write-Host "Starter sletting av ${($matchingRGs.Count)} resource group(s)..."
Write-Host "Dette kan ta noen minutter."

$errors = @()
foreach ($rg in $matchingRGs) {
    $name = $rg.ResourceGroupName
    $message = "Sletter resource group '$name'..."
    Write-Host ""
    Write-Host $message -ForegroundColor Yellow

    # Viser fremdrift (… → … → …)
    for ($i = 1; $i -le 3; $i++) {
        Write-Host ("." * $i) -NoNewline
        Start-Sleep -Seconds 1
    }
    Write-Host ""

    if ($PSCmdlet.ShouldProcess($name, "Sletting av $name")) {
        try {
            Remove-AzResourceGroup -Name $name -Force -ErrorAction Stop
            Write-Host "✅ Slettet: $name"
        } catch {
            Write-Error "Feil ved sletting av $name : $_"
            $errors += @{ ResourceGroup = $name; Error = $_.Exception.Message }
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Error "Noen slettinger feilet:"
    $errors | ForEach-Object { Write-Error " - $($_.ResourceGroup): $($_.Error)" }
    exit 3
}

Write-Host ""
Write-Host "Ferdig. Alle resource groups som inneholder 'oblig2' og 'jfk' er forsøkt slettet."
exit 0
