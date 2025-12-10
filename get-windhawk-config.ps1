# Script pour lire la configuration Windhawk
$regPath = "HKLM:\SOFTWARE\Windhawk\Engine\Mods\windows-11-taskbar-styler"

if (Test-Path $regPath) {
    Write-Host "=== Configuration actuelle du Taskbar Styler ===" -ForegroundColor Cyan
    Get-ItemProperty -Path $regPath | Format-List
} else {
    Write-Host "Clé de registre non trouvée: $regPath" -ForegroundColor Red

    # Chercher dans d'autres emplacements possibles
    Write-Host "`nRecherche dans HKLM:\SOFTWARE\Windhawk..." -ForegroundColor Yellow
    if (Test-Path "HKLM:\SOFTWARE\Windhawk") {
        Get-ChildItem "HKLM:\SOFTWARE\Windhawk" -Recurse | ForEach-Object {
            Write-Host $_.PSPath -ForegroundColor Gray
        }
    }
}

# Chercher aussi les fichiers de configuration
Write-Host "`n=== Fichiers de configuration ===" -ForegroundColor Cyan
$configPaths = @(
    "$env:APPDATA\Windhawk",
    "$env:LOCALAPPDATA\Windhawk",
    "$env:ProgramData\Windhawk"
)

foreach ($path in $configPaths) {
    if (Test-Path $path) {
        Write-Host "`nContenu de $path :" -ForegroundColor Yellow
        Get-ChildItem $path -Recurse -File | ForEach-Object {
            Write-Host "  $($_.FullName)" -ForegroundColor Gray
        }
    }
}
