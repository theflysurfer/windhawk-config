# Script pour modifier la couleur du texte de la taskbar
param(
    [string]$Color = "White"
)

$iniPath = "C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\windows-11-taskbar-styler.ini"

Write-Host "=== Modification de la couleur du texte taskbar ===" -ForegroundColor Cyan
Write-Host "Nouvelle couleur: $Color" -ForegroundColor Yellow

# Lire le fichier en UTF-16
$content = Get-Content $iniPath -Encoding Unicode -Raw

# Remplacer la couleur
$content = $content -replace 'controlStyles\[0\]\.styles\[0\]=Foreground=\w+', "controlStyles[0].styles[0]=Foreground=$Color"

# Écrire en UTF-16
$content | Set-Content $iniPath -Encoding Unicode -NoNewline

Write-Host "Fichier mis à jour!" -ForegroundColor Green

# Afficher le contenu
Write-Host "`nContenu actuel:" -ForegroundColor Cyan
Get-Content $iniPath -Encoding Unicode
