# Script pour ajouter le texte blanc à la taskbar
# Requires Administrator privileges

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Ce script doit être exécuté en tant qu'administrateur!"
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$regPath = "HKLM:\SOFTWARE\Windhawk\Engine\Mods\windows-11-taskbar-styler"

# Nouvelle configuration avec le texte blanc
$newSettings = @'
{
  "controlStyles[0].target": "Grid#RootGrid",
  "controlStyles[0].styles[0]": "Background:Transparent",
  "controlStyles[1].target": "Grid#BackgroundStroke",
  "controlStyles[1].styles[0]": "Visibility=Collapsed",
  "controlStyles[2].target": "TextBlock#LabelControl",
  "controlStyles[2].styles[0]": "Foreground=White"
}
'@

Write-Host "=== Mise à jour de la configuration Taskbar Styler ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ancienne configuration:" -ForegroundColor Yellow
$oldSettings = (Get-ItemProperty -Path $regPath).Settings
Write-Host $oldSettings -ForegroundColor Gray
Write-Host ""

Write-Host "Nouvelle configuration:" -ForegroundColor Green
Write-Host $newSettings -ForegroundColor Gray
Write-Host ""

# Appliquer la nouvelle configuration
Set-ItemProperty -Path $regPath -Name "Settings" -Value $newSettings -Type String

Write-Host "Configuration mise à jour avec succès!" -ForegroundColor Green
Write-Host ""
Write-Host "Redémarrage de l'Explorateur Windows pour appliquer les changements..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2
Write-Host "Explorateur redémarré!" -ForegroundColor Green
Write-Host ""
Write-Host "Le texte de la taskbar devrait maintenant être blanc." -ForegroundColor Cyan
