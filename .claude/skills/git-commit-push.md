# Skill: Commit & Push

## Description
Commiter et pusher les changements du repo Windhawk config.

## Repo
- **Local**: `C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk`
- **Remote**: `https://github.com/theflysurfer/windhawk-config`

## Commandes

### Vérifier le statut
```bash
cd "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk" && git status
```

### Commit & Push rapide
```bash
cd "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk" && git add . && git commit -m "$(cat <<'EOF'
Description du changement

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)" && git push
```

## Workflow typique

1. **Modifier la config Windhawk** (via l'autre skill ou manuellement)

2. **Synchroniser le backup**
```powershell
Copy-Item "C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\*.ini" "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\windhawk-config\" -Force
```

3. **Commit & Push**
```bash
cd "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk" && git add . && git status
# Vérifier les changements puis commit
```

## Messages de commit suggérés
- `Update taskbar style` - Changement de style taskbar
- `Update start menu transparency` - Changement menu start
- `Sync windhawk config` - Synchronisation générale
- `Add new mod: <nom>` - Ajout d'un nouveau mod
