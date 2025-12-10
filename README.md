# Windhawk Configuration

Ma configuration personnalisée Windhawk pour Windows 11.

## Aperçu

- **Taskbar**: Transparente avec texte blanc
- **Start Menu**: Translucide avec bordure RosePine (#eb6f92)
- **Search**: Même style que le Start Menu

## Installation sur un nouveau PC

### 1. Installer Windhawk

Télécharger depuis [windhawk.net](https://windhawk.net/) (version portable recommandée)

### 2. Restaurer la configuration (automatique)

```powershell
git clone https://github.com/theflysurfer/windhawk-config.git
cd windhawk-config
.\restore-windhawk-config.ps1 -WindhawkPath "C:\chemin\vers\Windhawk"
```

Le script va automatiquement :
- Télécharger tous les mods depuis GitHub
- Copier les fichiers de configuration (.ini)
- Proposer de lancer Windhawk

### 3. Activer les mods dans Windhawk

1. Ouvrir Windhawk
2. Aller dans "Installed Mods"
3. Cliquer "Enable" sur chaque mod

### 4. Redémarrer Explorer

```powershell
Stop-Process -Name explorer -Force
```

## Liste des mods

| Mod | Description |
|-----|-------------|
| windows-11-taskbar-styler | Style transparent de la taskbar |
| windows-11-start-menu-styler | Menu Start translucide RosePine |
| windows-11-file-explorer-styler | Style de l'explorateur |
| taskbar-labels | Labels sur la taskbar |
| taskbar-icon-size | Taille des icônes |
| taskbar-clock-customization | Personnalisation de l'horloge |
| explorer-details-better-file-sizes | Tailles de fichiers améliorées |
| icon-resource-redirect | Redirection des icônes |
| + 12 autres mods | Voir restore-windhawk-config.ps1 |

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
