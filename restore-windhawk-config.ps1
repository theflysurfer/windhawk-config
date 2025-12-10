# Script de restauration de la configuration Windhawk
# Usage: .\restore-windhawk-config.ps1 -WindhawkPath "C:\chemin\vers\Windhawk"

param(
    [string]$WindhawkPath = ""
)

Write-Host "=== Restauration de la configuration Windhawk ===" -ForegroundColor Cyan
Write-Host ""

# Trouver le chemin Windhawk si non spécifié
if (-not $WindhawkPath) {
    $possiblePaths = @(
        "$env:USERPROFILE\OneDrive\Portable Softwares\Windhawk",
        "$env:ProgramFiles\Windhawk",
        "${env:ProgramFiles(x86)}\Windhawk",
        "$env:LOCALAPPDATA\Windhawk"
    )

    foreach ($path in $possiblePaths) {
        if (Test-Path "$path\windhawk.exe") {
            $WindhawkPath = $path
            break
        }
    }
}

if (-not $WindhawkPath -or -not (Test-Path $WindhawkPath)) {
    Write-Host "Windhawk non trouvé. Spécifiez le chemin avec -WindhawkPath" -ForegroundColor Red
    Write-Host "Exemple: .\restore-windhawk-config.ps1 -WindhawkPath 'C:\Windhawk'" -ForegroundColor Yellow
    exit 1
}

Write-Host "Windhawk trouvé: $WindhawkPath" -ForegroundColor Green

$modsConfigPath = "$WindhawkPath\AppData\Engine\Mods"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupConfigPath = "$scriptDir\windhawk-config"

# Vérifier que le dossier de backup existe
if (-not (Test-Path $backupConfigPath)) {
    Write-Host "Dossier windhawk-config non trouvé dans $scriptDir" -ForegroundColor Red
    exit 1
}

# Créer le dossier de destination si nécessaire
if (-not (Test-Path $modsConfigPath)) {
    Write-Host "Création du dossier $modsConfigPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $modsConfigPath -Force | Out-Null
}

# Liste des mods à installer (IDs)
$modsToInstall = @(
    "windows-11-taskbar-styler",
    "windows-11-start-menu-styler",
    "taskbar-labels",
    "taskbar-icon-size",
    "taskbar-clock-customization",
    "taskbar-thumbnail-reorder",
    "taskbar-button-click",
    "explorer-details-better-file-sizes",
    "icon-resource-redirect",
    "translucent-windows"
)

Write-Host ""
Write-Host "=== Étape 1: Copie des fichiers de configuration ===" -ForegroundColor Cyan

$iniFiles = Get-ChildItem "$backupConfigPath\*.ini"
foreach ($file in $iniFiles) {
    Write-Host "  Copie de $($file.Name)..." -ForegroundColor Gray
    Copy-Item $file.FullName "$modsConfigPath\$($file.Name)" -Force
}

Write-Host "  ✓ $($iniFiles.Count) fichiers copiés" -ForegroundColor Green

Write-Host ""
Write-Host "=== Étape 2: Installation des mods ===" -ForegroundColor Cyan
Write-Host "Les mods suivants doivent être installés manuellement dans Windhawk:" -ForegroundColor Yellow
Write-Host ""

foreach ($mod in $modsToInstall) {
    Write-Host "  - $mod" -ForegroundColor White
}

Write-Host ""
Write-Host "Instructions:" -ForegroundColor Cyan
Write-Host "1. Ouvrez Windhawk" -ForegroundColor White
Write-Host "2. Cliquez sur 'Explore'" -ForegroundColor White
Write-Host "3. Recherchez et installez chaque mod listé ci-dessus" -ForegroundColor White
Write-Host "4. Les settings seront automatiquement appliqués depuis les fichiers .ini" -ForegroundColor White
Write-Host ""
Write-Host "=== Configuration principale ===" -ForegroundColor Cyan
Write-Host "- Taskbar: Transparent avec texte blanc" -ForegroundColor Gray
Write-Host "- Start Menu: Translucent avec bordure RosePine (#eb6f92)" -ForegroundColor Gray
Write-Host ""
Write-Host "Restauration terminée!" -ForegroundColor Green
