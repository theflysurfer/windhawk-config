# Windhawk Configuration

Ma configuration personnalisée Windhawk pour Windows 11.

## Aperçu

- **Taskbar**: Transparente avec texte blanc
- **Start Menu**: Translucide avec bordure RosePine (#eb6f92)
- **Search**: Même style que le Start Menu

## Installation sur un nouveau PC

### 1. Installer Windhawk

Télécharger depuis [windhawk.net](https://windhawk.net/) (version portable recommandée)

### 2. Installer les mods requis

Ouvrir Windhawk > Explore, puis installer :

- `windows-11-taskbar-styler`
- `windows-11-start-menu-styler`
- `taskbar-labels`
- `taskbar-icon-size`
- `taskbar-clock-customization`
- `taskbar-thumbnail-reorder`
- `taskbar-button-click`
- `explorer-details-better-file-sizes`
- `icon-resource-redirect`

### 3. Restaurer la configuration

```powershell
git clone https://github.com/theflysurfer/windhawk-config.git
cd windhawk-config
.\restore-windhawk-config.ps1 -WindhawkPath "C:\chemin\vers\Windhawk"
```

### 4. Redémarrer Explorer

```powershell
Stop-Process -Name explorer -Force
```

## Structure

```
windhawk-config/          # Fichiers .ini de configuration des mods
├── windows-11-taskbar-styler.ini
├── windows-11-start-menu-styler.ini
└── ...
restore-windhawk-config.ps1  # Script de restauration
```

## Configuration principale

### Taskbar Styler
- Theme: `TranslucentTaskbar`
- Texte: `Foreground=White`

### Start Menu Styler
- Theme: `TranslucentStartMenu`
- Background: `WindhawkBlur` avec `TintColor="#20191724"`
- Bordure: `#eb6f92` (RosePine)
