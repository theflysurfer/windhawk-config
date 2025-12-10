---
name: windhawk-config
description: Modifier les fichiers de configuration Windhawk (taskbar transparente, start menu translucide, etc.). Use when the user wants to change Windhawk settings, taskbar style, start menu style, or transparency settings.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

# Skill: Modification de configuration Windhawk

## When to Use

- Changer la couleur du texte de la taskbar
- Modifier la transparence du menu Start
- Ajuster les styles Windhawk (bordure, blur, couleurs)
- Synchroniser la config vers le repo Git

## Chemins importants

| Emplacement | Chemin |
|-------------|--------|
| Config active | `C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\*.ini` |
| Backup repo | `C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\windhawk-config\` |

## Fichiers principaux

- `windows-11-taskbar-styler.ini` - Taskbar (transparent, texte blanc)
- `windows-11-start-menu-styler.ini` - Menu Start (translucide, RosePine)

## Format des fichiers .ini

**IMPORTANT**: Les fichiers sont en **UTF-16**. Utiliser ce pattern :

```powershell
$iniPath = "C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\windows-11-taskbar-styler.ini"

# Lire
$content = Get-Content $iniPath -Encoding Unicode -Raw

# Modifier
$content = $content -replace 'Foreground=White', 'Foreground=Red'

# Écrire
$content | Set-Content $iniPath -Encoding Unicode -NoNewline
```

## Targets courants

### Taskbar
| Target | Usage |
|--------|-------|
| `TextBlock#LabelControl` | Texte des labels (Foreground=White/Red) |
| `Grid#RootGrid` | Fond de la taskbar |

### Start Menu
| Target | Usage |
|--------|-------|
| `Border#AcrylicBorder` | Fond principal |
| `Border#AcrylicOverlay` | Overlay (Visibility=Collapsed) |
| `Border#BorderElement` | Bordure |

## Styles de transparence

```ini
# AcrylicBrush - simple
Background:=<AcrylicBrush TintColor="#40191724" TintOpacity="0.4" />

# WindhawkBlur - plus de contrôle
Background:=<WindhawkBlur BlurAmount="25" TintColor="#20191724" />
```

## Workflow

1. Modifier le fichier `.ini` (UTF-16)
2. Redémarrer explorer : `Stop-Process -Name explorer -Force`
3. Synchroniser vers le repo (voir skill git-commit-push)

## Troubleshooting

### Les changements ne s'appliquent pas
- Vérifier l'encodage UTF-16
- Redémarrer Windhawk (pas juste explorer)
- Vérifier que le mod est activé dans Windhawk

### Erreur de syntaxe dans le .ini
- Vérifier les guillemets dans les valeurs XAML
- Pas d'espaces autour de `=`

### Conflit entre mods
- Désactiver `translucent-windows` si `taskbar-styler` ne fonctionne pas

## 🔗 Skill Chaining

### Input Expected
- Nom du fichier .ini à modifier
- Nouveau style/valeur à appliquer

### Output Produced
- Fichier .ini modifié
- Explorer redémarré

### Compatible Skills After
- **git-commit-push**: Commiter les changements vers GitHub

### Tools Used
- `Read`: Lire la config actuelle
- `Edit`/`Write`: Modifier la config (attention UTF-16)
- `Bash`: Redémarrer explorer
