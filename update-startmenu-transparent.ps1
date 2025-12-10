# Script pour ajouter la transparence au menu Start et Search
# Utilise WindhawkBlur au lieu de AcrylicBrush

$iniPath = "C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\windows-11-start-menu-styler.ini"

Write-Host "=== Ajout de transparence au menu Start et Search ===" -ForegroundColor Cyan

# Configuration avec WindhawkBlur et thème TranslucentStartMenu comme base
# On garde les couleurs RosePine pour la bordure
$newContent = @"
[Mod]
LibraryFileName=windows-11-start-menu-styler_1.3.3_256673.dll
Disabled=0
Include=StartMenuExperienceHost.exe|SearchHost.exe|SearchApp.exe
Exclude=
Architecture=x86-64
Version=1.3.3
SettingsChangeTime=1765394359

[Settings]
theme=TranslucentStartMenu
disableNewStartMenuLayout=1
controlStyles[0].target=Border#AcrylicBorder
controlStyles[0].styles[0]=Background:=<WindhawkBlur BlurAmount="25" TintColor="#20191724" />
controlStyles[0].styles[1]=BorderBrush=#eb6f92
controlStyles[0].styles[2]=BorderThickness=1
controlStyles[1].target=Border#AcrylicOverlay
controlStyles[1].styles[0]=Visibility=Collapsed
controlStyles[2].target=Border#BorderElement
controlStyles[2].styles[0]=Background:=<WindhawkBlur BlurAmount="25" TintColor="#20191724" />
controlStyles[2].styles[1]=BorderBrush=#eb6f92
controlStyles[2].styles[2]=BorderThickness=1
controlStyles[3].target=Border#AppBorder
controlStyles[3].styles[0]=Background:=<WindhawkBlur BlurAmount="25" TintColor="#20191724" />
controlStyles[3].styles[1]=BorderBrush=#eb6f92
controlStyles[3].styles[2]=BorderThickness=1
webContentStyles[0].target=
webContentStyles[0].styles[0]=
webContentCustomJs=
styleConstants[0]=
resourceVariables[0].variableKey=
resourceVariables[0].value=
"@

# Écrire en UTF-16
$newContent | Set-Content $iniPath -Encoding Unicode -NoNewline

Write-Host "Fichier mis à jour!" -ForegroundColor Green
Write-Host "Theme: TranslucentStartMenu avec bordure RosePine" -ForegroundColor Yellow

# Afficher le contenu
Write-Host "`nContenu:" -ForegroundColor Cyan
Get-Content $iniPath -Encoding Unicode
