---
name: git-commit-push
description: Commiter et pusher les changements du repo Windhawk config vers GitHub. Use when user says "commit", "push", "commit & push", "save changes", or wants to sync config to GitHub.
allowed-tools:
  - Bash
---

# Skill: Commit & Push

## When to Use

- L'utilisateur dit "commit", "push", "commit & push"
- Après modification de la config Windhawk
- Pour synchroniser les changements vers GitHub

## Repo

| Info | Valeur |
|------|--------|
| Local | `C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk` |
| Remote | `https://github.com/theflysurfer/windhawk-config` |

## Workflow rapide

### 1. Synchroniser le backup (si config modifiée)

```powershell
Copy-Item "C:\Users\julien\OneDrive\Portable Softwares\Windhawk\AppData\Engine\Mods\*.ini" "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\windhawk-config\" -Force
```

### 2. Vérifier le statut

```bash
cd "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk" && git status
```

### 3. Commit & Push

```bash
cd "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk" && git add . && git commit -m "$(cat <<'EOF'
Description du changement

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)" && git push
```

## Messages de commit suggérés

| Situation | Message |
|-----------|---------|
| Style taskbar | `Update taskbar style` |
| Transparence menu | `Update start menu transparency` |
| Sync général | `Sync windhawk config` |
| Nouveau mod | `Add new mod: <nom>` |
| Skills | `Update skills` |

## Troubleshooting

### "nothing to commit, working tree clean"
- Pas de changements à commiter, tout est déjà synchronisé

### "failed to push"
- Vérifier la connexion internet
- `git pull` d'abord si le remote a changé

### Fichiers .ini non détectés
- Vérifier que la copie depuis Windhawk a été faite (étape 1)

## 🔗 Skill Chaining

### Skills Required Before
- **windhawk-config** (optionnel): Si on a modifié la config Windhawk

### Input Expected
- Aucun (ou message de commit optionnel)

### Output Produced
- Commit créé
- Push vers GitHub
- URL du repo confirmé

### Tools Used
- `Bash`: git status, git add, git commit, git push
