#!/usr/bin/env bash
# Cria o repositório no GitHub (se ainda não existir) e envia o código.
# Uso (Git Bash):  bash deploy/github-subir.sh [private|public]     (padrão: private)
set -euo pipefail

REPO="jhonatan-portfolio-pessoal"
VIS="${1:-private}"
cd "$(dirname "$0")/.."

gh auth status >/dev/null 2>&1 || { echo "ERRO: faça o login antes (deploy/github-login.ps1 no PowerShell)"; exit 1; }
DONO="$(gh api user --jq .login)"

if ! git remote get-url origin >/dev/null 2>&1; then
  if gh repo view "$DONO/$REPO" >/dev/null 2>&1; then
    git remote add origin "https://github.com/$DONO/$REPO.git"
  else
    gh repo create "$REPO" "--$VIS" --source . --remote origin \
      --description "Portfólio pessoal de Jhonatan Camargo: site cinematográfico com vídeo na rolagem"
  fi
fi

git push -u origin main
echo "OK: https://github.com/$DONO/$REPO"
