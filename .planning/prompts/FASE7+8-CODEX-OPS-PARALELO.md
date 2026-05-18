# FASE 7+8 PARALELA — CODEX-OPS: Deploy Scripts + Docs Independentes

> **Acionar AGORA** enquanto GEMINI-UX trabalha na Fase 2.
> Nenhuma dependência de componentes UI.

---

## PROTOCOLO OBRIGATÓRIO

1. Leia `.planning/AGENT-ONBOARDING.md` → `.planning/AGENT-CONTRACT.md`
2. Registre check-in START em `.planning/CHECKIN-LOG.md`
3. Ao finalizar, registre check-in END com evidências

---

## BLOCO 1 — Deploy Scripts (Fase 7, Tasks 7.1-7.7)

```
Você é CODEX-OPS. Leia .planning/ADRs.md (ADR-003). Use 4 sub-agentes em paralelo.

CONTEXTO: Deploy para HostGator compartilhado via SSH/rsync.
Target: /home2/cri07713/public_html
Credenciais em .env.deploy.local (gitignored).

SUB-AGENTE 1 — site/scripts/hostgator-preflight.ps1:
- Verificar SSH connectivity (Test-Connection + ssh test)
- Verificar .env.deploy.local existe com todas vars (DEPLOY_HOST, DEPLOY_USER, DEPLOY_PATH, DEPLOY_PORT)
- Verificar npm run build sucesso
- Verificar /dist existe e não está vazio
- Listar arquivos que serão deployados (count + size total)
- Abort com mensagem clara se qualquer check falhar
- Exit codes: 0=OK, 1=FAIL

SUB-AGENTE 2 — site/scripts/hostgator-backup.ps1 + site/scripts/hostgator-rollback.ps1:
BACKUP:
- SSH para servidor
- tar -czf backup_{timestamp}.tar.gz do webroot
- Manter últimos 3 backups (rotacionar, deletar mais antigos)
- Confirmar backup criado com ls -la
- Exit code 0 se OK
ROLLBACK:
- Listar backups disponíveis no servidor
- Aceitar parâmetro -BackupFile ou usar último automaticamente
- Restaurar backup (tar -xzf)
- Validar restauração com curl health check
- Exit code 0 se OK

SUB-AGENTE 3 — site/scripts/hostgator-deploy.ps1:
- Chamar preflight primeiro → abort se falhar
- Chamar backup → abort se falhar
- rsync -avz --delete --exclude='.env*' --exclude='backup_*' site/dist/ user@host:path/
- Verificar rsync exit code
- Chamar validate → warn se falhar mas não rollback automático
- Reportar tempo total de deploy
- Exit code 0 se OK

SUB-AGENTE 4 — site/scripts/hostgator-validate.ps1:
- curl -s -o /dev/null -w "%{http_code}" https://www.colegiovillaprime.com.br → deve ser 200
- curl checar se og:title existe no HTML retornado
- curl checar se robots.txt responde 200
- curl checar se sitemap-index.xml responde 200
- Reportar pass/fail para cada check
- Exit code 0 se todos passaram

TAMBÉM CRIAR:
- site/scripts/.env.deploy.example com:
  DEPLOY_HOST=xxx.xxx.xxx.xxx
  DEPLOY_USER=cri07713
  DEPLOY_PATH=/home2/cri07713/public_html
  DEPLOY_PORT=22

- .cpanel.yml.example na raiz de site/ com deployment task alternativo
```

---

## BLOCO 2 — Docs Independentes (Fase 8, Tasks parciais)

Estes docs NÃO dependem de componentes. Podem ser escritos agora com base nos artefatos existentes.

```
Após concluir o BLOCO 1, crie os seguintes documentos em site/docs/:

1. site/docs/DEPLOY-GUIDE.md:
   - Leia os scripts que você acabou de criar
   - Passo a passo: install → build → preflight → backup → deploy → validate → rollback
   - Inclua diagrama Mermaid do pipeline
   - Pré-requisitos (SSH key, .env.deploy.local)
   - Troubleshooting de deploy

2. site/docs/BACKUP-STRATEGY.md:
   - Baseado no ADR-003 e hostgator-backup.ps1
   - Procedimento de backup manual e automático
   - Política de rotação (últimos 3)
   - Como restaurar (rollback)

3. site/docs/TROUBLESHOOTING.md:
   - Build falha (npm run build)
   - SSH timeout / connection refused
   - rsync permission denied
   - 404 após deploy
   - Cache stale (browser/CDN)
   - .htaccess syntax error
   - Fallback: deploy manual via cPanel File Manager

4. site/docs/SECURITY-HEADERS.md:
   - Leia public/.htaccess
   - Explique CADA header e o motivo de segurança
   - CSP, X-Frame-Options, X-Content-Type-Options, HSTS, Referrer-Policy
   - Como testar (securityheaders.com)

5. site/docs/SEO-CHECKLIST.md:
   - Leia .planning/ARCHITECTURE-BLUEPRINT.md Seção 3
   - Checklist por página: title, meta description, h1, schema.org, canonical, og:image
   - Status de cada uma (placeholder se página não montada ainda)

6. site/docs/CONTENT-GUIDE.md:
   - Leia os arquivos em src/data/ (faq.ts, features.ts, navigation.ts, school-info.ts, testimonials.ts)
   - Como editar cada arquivo de dados
   - Como trocar imagens em public/images/
   - Como adicionar nova página
   - Formato esperado (TypeScript interfaces)
```

---

## ENTREGÁVEIS ESPERADOS

| # | Arquivo | Tipo |
|---|---------|------|
| 1 | `site/scripts/hostgator-preflight.ps1` | Script |
| 2 | `site/scripts/hostgator-backup.ps1` | Script |
| 3 | `site/scripts/hostgator-deploy.ps1` | Script |
| 4 | `site/scripts/hostgator-rollback.ps1` | Script |
| 5 | `site/scripts/hostgator-validate.ps1` | Script |
| 6 | `site/scripts/.env.deploy.example` | Config |
| 7 | `site/.cpanel.yml.example` | Config |
| 8 | `site/docs/DEPLOY-GUIDE.md` | Doc |
| 9 | `site/docs/BACKUP-STRATEGY.md` | Doc |
| 10 | `site/docs/TROUBLESHOOTING.md` | Doc |
| 11 | `site/docs/SECURITY-HEADERS.md` | Doc |
| 12 | `site/docs/SEO-CHECKLIST.md` | Doc |
| 13 | `site/docs/CONTENT-GUIDE.md` | Doc |

**Total: 7 scripts/configs + 6 docs = 13 entregáveis.**

Registre check-in START e END em `.planning/CHECKIN-LOG.md` com timestamps.
