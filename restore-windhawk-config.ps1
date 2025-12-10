# Script de restauration complète de la configuration Windhawk
# Usage: .\restore-windhawk-config.ps1 -WindhawkPath "C:\chemin\vers\Windhawk"

param(
    [string]$WindhawkPath = ""
)

Write-Host "=== Restauration complète de Windhawk ===" -ForegroundColor Cyan
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
$modsSourcePath = "$WindhawkPath\AppData\ModsSource"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupConfigPath = "$scriptDir\windhawk-config"

# Créer les dossiers si nécessaire
@($modsConfigPath, $modsSourcePath) | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
}

# Liste des mods à installer avec leurs IDs GitHub
$modsToInstall = @(
    "windows-11-taskbar-styler",
    "windows-11-start-menu-styler",
    "windows-11-file-explorer-styler",
    "taskbar-labels",
    "taskbar-icon-size",
    "taskbar-clock-customization",
    "taskbar-thumbnail-reorder",
    "taskbar-button-click",
    "taskbar-auto-hide-when-maximized",
    "taskbar-on-top",
    "taskbar-vertical",
    "explorer-details-better-file-sizes",
    "explorer-double-f2-rename-extension",
    "explorerframe-fixes-for-win11-22h2plus",
    "extension-change-no-warning",
    "file-explorer-remove-suffixes",
    "icon-resource-redirect",
    "remove-quotes-from-ctrl-shift-c",
    "translucent-windows",
    "virtual-desktop-taskbar-order",
    "win-d-per-monitor"
)

$baseUrl = "https://raw.githubusercontent.com/ramensoftware/windhawk-mods/main/mods"

Write-Host ""
Write-Host "=== Étape 1: Téléchargement des mods ===" -ForegroundColor Cyan

$downloadedCount = 0
$failedMods = @()

foreach ($mod in $modsToInstall) {
    $url = "$baseUrl/$mod.wh.cpp"
    $destPath = "$modsSourcePath\$mod.wh.cpp"

    Write-Host "  Téléchargement de $mod..." -ForegroundColor Gray -NoNewline

    try {
        Invoke-WebRequest -Uri $url -OutFile $destPath -ErrorAction Stop
        Write-Host " ✓" -ForegroundColor Green
        $downloadedCount++
    } catch {
        Write-Host " ✗" -ForegroundColor Red
        $failedMods += $mod
    }
}

Write-Host ""
Write-Host "  $downloadedCount/$($modsToInstall.Count) mods téléchargés" -ForegroundColor $(if ($downloadedCount -eq $modsToInstall.Count) { "Green" } else { "Yellow" })

if ($failedMods.Count -gt 0) {
    Write-Host "  Échecs: $($failedMods -join ', ')" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Étape 2: Copie des fichiers de configuration ===" -ForegroundColor Cyan

if (Test-Path $backupConfigPath) {
    $iniFiles = Get-ChildItem "$backupConfigPath\*.ini" -ErrorAction SilentlyContinue
    foreach ($file in $iniFiles) {
        Write-Host "  Copie de $($file.Name)..." -ForegroundColor Gray
        Copy-Item $file.FullName "$modsConfigPath\$($file.Name)" -Force
    }
    Write-Host "  ✓ $($iniFiles.Count) fichiers de config copiés" -ForegroundColor Green
} else {
    Write-Host "  Dossier windhawk-config non trouvé, skip..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Étape 3: Instructions finales ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Lancez Windhawk: $WindhawkPath\windhawk.exe" -ForegroundColor White
Write-Host "2. Les mods téléchargés apparaîtront dans 'Installed Mods'" -ForegroundColor White
Write-Host "3. Activez chaque mod en cliquant sur 'Enable'" -ForegroundColor White
Write-Host "4. Les settings seront automatiquement appliqués" -ForegroundColor White
Write-Host ""
Write-Host "=== Configuration principale ===" -ForegroundColor Cyan
Write-Host "- Taskbar: Transparent avec texte blanc" -ForegroundColor Gray
Write-Host "- Start Menu: Translucent avec bordure RosePine (#eb6f92)" -ForegroundColor Gray
Write-Host ""
Write-Host "Restauration terminée!" -ForegroundColor Green
Write-Host ""

# Proposer de lancer Windhawk
$launch = Read-Host "Lancer Windhawk maintenant? (O/n)"
if ($launch -ne "n" -and $launch -ne "N") {
    Start-Process "$WindhawkPath\windhawk.exe"
}
