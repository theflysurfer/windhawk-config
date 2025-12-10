# Skill: Modification de configuration Windhawk

## Description
Modifier les fichiers de configuration Windhawk (taskbar, start menu, etc.)

## Chemins importants
- **Config active**: `C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\*.ini`
- **Backup dans repo**: `C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\windhawk-config\`

## Fichiers de config principaux
- `windows-11-taskbar-styler.ini` - Style de la taskbar (transparent, texte blanc)
- `windows-11-start-menu-styler.ini` - Style du menu Start (translucide, RosePine)

## Format des fichiers .ini
Les fichiers sont en **UTF-16**. Pour les modifier :

```powershell
# Lire
$content = Get-Content $iniPath -Encoding Unicode -Raw

# Modifier
$content = $content -replace 'ancienne_valeur', 'nouvelle_valeur'

# Écrire
$content | Set-Content $iniPath -Encoding Unicode -NoNewline
```

## Targets courants

### Taskbar
- `TextBlock#LabelControl` - Texte des labels (Foreground=White/Red/etc)
- `Grid#RootGrid` - Fond de la taskbar

### Start Menu
- `Border#AcrylicBorder` - Fond principal
- `Border#AcrylicOverlay` - Overlay
- `Border#BorderElement` - Bordure

## Styles de transparence
```ini
# AcrylicBrush
Background:=<AcrylicBrush TintColor="#40191724" TintOpacity="0.4" />

# WindhawkBlur (plus de contrôle)
Background:=<WindhawkBlur BlurAmount="25" TintColor="#20191724" />
```

## Après modification
Toujours redémarrer explorer :
```powershell
Stop-Process -Name explorer -Force
```

## Synchroniser le backup
Après modification, copier vers le repo :
```powershell
Copy-Item "C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\*.ini" "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\windhawk-config\" -Force
```
