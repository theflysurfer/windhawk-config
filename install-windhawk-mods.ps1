# Script d'installation automatique des mods Windhawk
# Requires Administrator privileges

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Ce script doit être exécuté en tant qu'administrateur!"
    Write-Host "Relancement avec les privilèges administrateur..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "=== Installation automatique des mods Windhawk ===" -ForegroundColor Cyan
Write-Host ""

# Configuration des chemins
$windhawkModsPath = "$env:ProgramData\Windhawk\Engine\Mods"
$windhawkSourcePath = "$env:ProgramData\Windhawk\ModsSource"

# Créer les dossiers s'ils n'existent pas
if (-not (Test-Path $windhawkModsPath)) {
    New-Item -ItemType Directory -Path $windhawkModsPath -Force | Out-Null
}
if (-not (Test-Path $windhawkSourcePath)) {
    New-Item -ItemType Directory -Path $windhawkSourcePath -Force | Out-Null
}

# Liste des mods à installer
$mods = @(
    @{
        Name = "Windows 11 Taskbar Styler"
        File = "windows-11-taskbar-styler.wh.cpp"
        ID = "windows-11-taskbar-styler"
        Settings = @'
{
  "controlStyles[0].target": "Grid#RootGrid",
  "controlStyles[0].styles[0]": "Background:Transparent",
  "controlStyles[1].target": "Grid#BackgroundStroke",
  "controlStyles[1].styles[0]": "Visibility=Collapsed",
  "controlStyles[2].target": "TextBlock#LabelControl",
  "controlStyles[2].styles[0]": "Foreground=White"
}
'@
    },
    @{
        Name = "Taskbar Icon Size"
        File = "taskbar-icon-size.wh.cpp"
        ID = "taskbar-icon-size"
        Settings = @'
{
  "iconSize": 40
}
'@
    },
    @{
        Name = "Taskbar Thumbnail Size"
        File = "taskbar-thumbnail-size.wh.cpp"
        ID = "taskbar-thumbnail-size"
        Settings = @'
{
  "width": 350,
  "height": 250
}
'@
    },
    @{
        Name = "Taskbar Labels"
        File = "taskbar-labels.wh.cpp"
        ID = "taskbar-labels"
        Settings = @'
{
  "combineLabeled": "always",
  "showLabelsOnHover": true
}
'@
    },
    @{
        Name = "Windows 11 Start Menu Styler"
        File = "windows-11-start-menu-styler.wh.cpp"
        ID = "windows-11-start-menu-styler"
        Settings = @'
{
  "theme": "Windows10"
}
'@
    },
    @{
        Name = "Classic Context Menu"
        File = "explorer-context-menu-classic.wh.cpp"
        ID = "explorer-context-menu-classic"
        Settings = "{}"
    },
    @{
        Name = "Explorer Transparent"
        File = "explorer-transparent.wh.cpp"
        ID = "explorer-transparent"
        Settings = @'
{
  "transparency": 200,
  "enableBlur": true,
  "transparentBackground": true
}
'@
        Local = $true
    }
)

# Fonction pour télécharger un mod
function Download-Mod {
    param (
        [string]$FileName,
        [string]$ModName,
        [bool]$IsLocal = $false
    )

    $destination = "$windhawkSourcePath\$FileName"

    # Si c'est un mod local, copier depuis le répertoire actuel
    if ($IsLocal) {
        $localPath = Join-Path $PSScriptRoot $FileName
        if (Test-Path $localPath) {
            Write-Host "Copie de $ModName (local)..." -ForegroundColor Yellow
            try {
                Copy-Item -Path $localPath -Destination $destination -Force -ErrorAction Stop
                Write-Host "  ✓ $ModName copié" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "  ✗ Erreur lors de la copie de $ModName : $_" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "  ✗ Fichier local non trouvé: $localPath" -ForegroundColor Red
            return $false
        }
    }

    # Sinon, télécharger depuis GitHub
    $url = "https://raw.githubusercontent.com/ramensoftware/windhawk-mods/main/mods/$FileName"

    Write-Host "Téléchargement de $ModName..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
        Write-Host "  ✓ $ModName téléchargé" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  ✗ Erreur lors du téléchargement de $ModName : $_" -ForegroundColor Red
        return $false
    }
}

# Fonction pour créer l'entrée de registre pour un mod
function Register-Mod {
    param (
        [string]$ModID,
        [string]$ModName,
        [string]$Settings
    )

    $regPath = "HKLM:\SOFTWARE\Windhawk\Engine\Mods\$ModID"

    Write-Host "Enregistrement de $ModName dans le registre..." -ForegroundColor Yellow
    try {
        # Créer la clé de registre si elle n'existe pas
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }

        # Définir les valeurs
        Set-ItemProperty -Path $regPath -Name "Disabled" -Value 0 -Type DWord
        Set-ItemProperty -Path $regPath -Name "LoggingEnabled" -Value 0 -Type DWord
        Set-ItemProperty -Path $regPath -Name "Debug" -Value 0 -Type DWord
        Set-ItemProperty -Path $regPath -Name "Include" -Value "" -Type String
        Set-ItemProperty -Path $regPath -Name "Exclude" -Value "" -Type String

        # Ajouter les paramètres personnalisés
        if ($Settings -and $Settings -ne "{}") {
            Set-ItemProperty -Path $regPath -Name "Settings" -Value $Settings -Type String
        }

        Write-Host "  ✓ $ModName enregistré" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  ✗ Erreur lors de l'enregistrement de $ModName : $_" -ForegroundColor Red
        return $false
    }
}

# Installation des mods
Write-Host "Début de l'installation des mods..." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$totalCount = $mods.Count

foreach ($mod in $mods) {
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host "Mod: $($mod.Name)" -ForegroundColor Cyan

    $isLocal = if ($mod.Local) { $mod.Local } else { $false }
    $downloaded = Download-Mod -FileName $mod.File -ModName $mod.Name -IsLocal $isLocal
    if ($downloaded) {
        $registered = Register-Mod -ModID $mod.ID -ModName $mod.Name -Settings $mod.Settings
        if ($registered) {
            $successCount++
        }
    }
    Write-Host ""
}

# Résumé
Write-Host "========================================" -ForegroundColor Gray
Write-Host "Installation terminée!" -ForegroundColor Cyan
Write-Host "$successCount/$totalCount mods installés avec succès" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })
Write-Host ""

# Redémarrer Explorer pour appliquer les changements
Write-Host "Redémarrage de l'Explorateur Windows pour appliquer les changements..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2
Write-Host "✓ Explorateur redémarré" -ForegroundColor Green

Write-Host ""
Write-Host "Les mods Windhawk sont maintenant installés et configurés!" -ForegroundColor Green
Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
