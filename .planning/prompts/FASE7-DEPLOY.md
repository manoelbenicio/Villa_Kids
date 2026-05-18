# FASE 7 — Prompts (Deploy Pipeline)

---

## Task 7.1-7.7 — CODEX-OPS: Scripts de deploy

```
Você é CODEX-OPS. Leia .planning/ADRs.md (ADR-003). Use 4 sub-agentes em paralelo.

CONTEXTO: Deploy para HostGator compartilhado via SSH/rsync.
Target: /home2/cri07713/public_html
Credenciais em .env.deploy.local (gitignored).

SUB-AGENTE 1 — hostgator-preflight.ps1:
- Verificar SSH connectivity
- Verificar .env.deploy.local existe com todas vars
- Verificar npm run build sucesso
- Verificar /dist existe e não está vazio
- Listar arquivos que serão deployados
- Abort se qualquer check falhar

SUB-AGENTE 2 — hostgator-backup.ps1 + hostgator-rollback.ps1:
BACKUP:
- SSH para servidor
- tar -czf backup_{timestamp}.tar.gz do webroot
- Manter últimos 3 backups (rotacionar)
- Confirmar backup criado com ls -la
ROLLBACK:
- Listar backups disponíveis
- Restaurar último backup (tar -xzf)
- Validar restauração com curl health check

SUB-AGENTE 3 — hostgator-deploy.ps1:
- Chamar preflight primeiro
- Chamar backup
- rsync -avz --delete --exclude='.env*' --exclude='backup_*' site/dist/ user@host:path/
- Verificar rsync exit code
- Chamar validate

SUB-AGENTE 4 — hostgator-validate.ps1 + .cpanel.yml.example:
VALIDATE:
- curl -s -o /dev/null -w "%{http_code}" https://www.colegiovillaprime.com.br → deve ser 200
- curl checar se og:title existe no HTML
- curl checar se robots.txt responde
- Reportar pass/fail
CPANEL:
- .cpanel.yml.example com deployment task alternativo

TAMBÉM CRIAR: .env.deploy.example com:
DEPLOY_HOST=xxx.xxx.xxx.xxx
DEPLOY_USER=cri07713
DEPLOY_PATH=/home2/cri07713/public_html
DEPLOY_PORT=22

Registre check-in em .planning/CHECKIN-LOG.md.
```
