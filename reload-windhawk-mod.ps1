# Script pour forcer le rechargement du mod Windhawk
# Requires Administrator privileges

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Ce script doit être exécuté en tant qu'administrateur!"
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "=== Rechargement du mod Taskbar Styler ===" -ForegroundColor Cyan

# Méthode 1: Désactiver puis réactiver le mod
$regPath = "HKLM:\SOFTWARE\Windhawk\Engine\Mods\windows-11-taskbar-styler"

Write-Host "Désactivation temporaire du mod..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name "Disabled" -Value 1 -Type DWord
Start-Sleep -Seconds 1

Write-Host "Réactivation du mod..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name "Disabled" -Value 0 -Type DWord

Write-Host "Redémarrage de l'Explorateur Windows..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 3

Write-Host "Terminé!" -ForegroundColor Green
