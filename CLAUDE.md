# dotfiles — Claude Code Notes

## This is a Public Repository

Before committing, always verify staged changes pass the **Public Repo Safety Checklist** in `AGENTS.md`.

Quick scan commands:

```bash
# Secrets (API keys, tokens, passwords)
git diff --staged | grep -iE "(api[_-]?key|token|password|secret|credential)\s*[=:]\s*\S"

# Hardcoded home directory paths
git diff --staged | grep -E "/(home|Users)/[a-zA-Z0-9_-]+"
```
