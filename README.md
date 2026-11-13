# Portfólio — Jhonatan Camargo

Site pessoal de Jhonatan Camargo, desenvolvedor Full Stack com foco em agentes de IA, automação e DevOps. A página é estática, com um vídeo que avança conforme a rolagem.

## Estrutura

| Caminho | O que tem |
|---|---|
| `site/` | O site: `index.html`, `estilo.css`, `app.js`, `config.js` e `assets/` |
| `brief.md`, `brief.json` | Conteúdo e copy que alimentam o site |
| `deploy/publicar.sh` | Publica o site no nginx de uma VPS (roda como root) |
| `deploy/github-login.ps1`, `deploy/github-subir.sh` | Login no GitHub CLI e envio do código |

## Ver localmente

Não há build. Sirva a pasta `site/` com qualquer servidor estático:

```bash
cd site
python -m http.server 8080
```

Abra http://localhost:8080.

## Publicar

1. Gere o pacote: `tar -czf site.tar.gz -C site .`
2. Envie para a VPS: `scp site.tar.gz usuario@servidor:/tmp/`
3. No servidor, como root: `bash deploy/publicar.sh`

O script cria só o vhost do domínio configurado nele e não mexe nos outros sites do servidor. Para atualizar, repita os passos.

## Observações

- `site.tar.gz` e `fonte/` ficam fora do git (ver `.gitignore`).
- Os frames de vídeo ficam em `site/assets/`.
