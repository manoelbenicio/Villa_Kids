# FASE 7 — Deploy HostGator (Paralelo Atomic)

> **Fase**: 7 — Execução real do deploy para produção
> **Status**: Aguardando Fase 6.B `PASSED` + Fase 7-PRE concluída + SSH credentials do usuário
> **Modelo de execução**: **4 slots paralelos** (CODEX main + 3 sub-agentes)
> **Tempo estimado**: ~5min de janela real (zero downtime)
> **Bloqueador para**: Fase 8 docs finais (parcial)

---

## CONTEXTO PRÉ-CARREGADO

### Pré-requisitos hard (verificar ANTES de iniciar)
1. ✅ Fase 6.B `COMPLETED` com `QA-SUMMARY.md = PASSED` em todas 9 páginas
2. ✅ Scripts v2 paralelos disponíveis em `site/scripts/` (vide `FASE7-PRE-SCRIPTS-V2.md`)
3. ✅ Build limpo: `npm run build` em `site/` retorna 0 erros + 9 páginas + sitemap
4. ✅ `site/scripts/.env.deploy.local` existente e gitignored
5. ✅ Chave SSH HostGator configurada (`~/.ssh/id_*` ou em `.env.deploy.local`)
6. ✅ Conectividade: `ssh user@host echo ok` retorna `ok`
7. ✅ Espaço remoto: ≥ 500MB livres em `$DEPLOY_PATH`
8. ✅ HTTPS funcionando no domínio atual (sem mudança de DNS necessária)

### Arquivos críticos
1. `.planning/AGENT-CONTRACT.md` — §5 Deploy Gate
2. `.planning/ADRs.md` — ADR-003 deploy
3. `site/scripts/README.md` — fluxo de deploy v2
4. `site/docs/DEPLOY-GUIDE.md` — guia operacional
5. `site/docs/QA-SUMMARY.md` — gate de qualidade aprovado
6. `site/dist/` — artefato a publicar

### Domínio alvo (confirmar com user antes do deploy)
- Provável: `https://www.colegiovillaprime.com.br`
- Path remoto: `/home2/cri07713/public_html` (ou conforme `.env.deploy.local`)
- Staged dir: `/home2/cri07713/public_html_new`

---

## SLOT MAIN — CODEX-OPS (orquestrador)

**Skill carregada**: `deployment-pipeline-design`
**Responsabilidade**: orquestração + atomic switch + rollback-ready + reporte

### Tarefas
1. Verificar TODOS os pré-requisitos hard acima — se algum falhar, abortar e reportar
2. Registrar check-in `IN_PROGRESS` em `CHECKIN-LOG.md` com timestamp UTC
3. Confirmar com o usuário: domínio, path remoto, hora do deploy (janela ideal)
4. **Disparar 3 sub-agentes em paralelo** (Slots A, B, C abaixo)
5. **Aguardar** SLOT A (preflight + backup) e SLOT B (rsync staged) terminarem
6. **Atomic switch** (executar pessoalmente, não delegar):
   ```
   .\hostgator-atomic-switch.ps1
   ```
   - Verificar saída `SWITCH_OK`
   - Salvar timestamp do switch em variável de ambiente (referência rollback)
7. **Disparar SLOT C** (smoke + lighthouse pós-deploy) imediatamente após switch
8. Aguardar SLOT C concluir
9. Validações finais:
   - Site acessível em produção (HTTPS 200 nas 9 rotas)
   - Headers de segurança presentes
   - DNS/SSL OK
10. Se TUDO OK:
    - Registrar check-in `COMPLETED` com evidência (output dos 4 slots + smoke results)
    - Atualizar `ROADMAP.md` Fase 7 → ✅ DONE
    - Criar handoff para Fase 8 (Documentação Final)
11. Se ALGO FALHAR:
    - **Rollback automático imediato**: `.\hostgator-rollback-fast.ps1` (< 2s)
    - Verificar site voltou ao estado anterior
    - Registrar check-in `FAILED` com causa raiz
    - Escalar ao usuário com plano de fix

### Janela de deploy
- Estimativa: 3-5min total
- Switch atômico: < 1s
- Janela de "site fora do ar": **0 segundos** (atomic mv)

---

## SLOT A — Sub-agente Preflight + Backup

**Skill carregada**: `deployment-validation-config-validate`
**Spawn via**: tool `subagent` com role `kiro_default`

### Tarefas (executadas em paralelo entre si via Start-Job)

#### A.1 — Preflight
1. Executar `.\site\scripts\hostgator-preflight.ps1`
2. Verificar:
   - SSH connectivity OK
   - `.env.deploy.local` válido
   - `dist/` existe com 9 páginas
   - Espaço remoto OK
3. Capturar output em `site/docs/deploy-evidence/preflight-<timestamp>.log`
4. Exit 0 se OK; reportar para SLOT MAIN se FAIL

#### A.2 — Backup remoto
1. Executar `.\site\scripts\hostgator-backup.ps1`
2. Confirmar:
   - tar.gz criado em `~/backups/backup_<timestamp>.tar.gz`
   - Tamanho > 0
   - Rotação aplicada (≤ 5 backups mantidos)
3. Capturar output em `site/docs/deploy-evidence/backup-<timestamp>.log`
4. Salvar timestamp do backup como ponto de rollback de emergência

#### A.3 — Build clean (em paralelo a A.1 e A.2)
1. `cd site && rm -rf dist && npm run build`
2. Confirmar:
   - 0 erros
   - 9 páginas geradas
   - sitemap-index.xml + sitemap-0.xml
   - HTML, CSS, JS minificados
3. Capturar output em `site/docs/deploy-evidence/build-<timestamp>.log`

### Critério de saída
A.1, A.2, A.3 — TODOS exit 0 — SLOT MAIN libera SLOT B

---

## SLOT B — Sub-agente Rsync Paralelo Staged

**Skill carregada**: `deployment-procedures`
**Spawn via**: tool `subagent` com role `kiro_default`

### Tarefas
1. Executar `.\site\scripts\hostgator-rsync-parallel.ps1 -StagedDir public_html_new`
2. O script roda 4 jobs rsync paralelos:
   - Job 1: `dist/_astro/` → `staged/_astro/`
   - Job 2: `dist/images/` → `staged/images/`
   - Job 3: HTML raiz + favicon + robots + sitemap → `staged/`
   - Job 4: rotas (`contato/`, `estrutura/`, `matriculas/`, etc.) → `staged/<rota>/`
3. Aguardar TODOS os 4 jobs terminarem
4. Verificar:
   - Cada job exit 0
   - Sem erros de transfer
   - Bytes transferidos > 0
   - Staged dir `public_html_new` existe e contém todos os arquivos
5. **Smoke test no staging** (antes do switch):
   - Adicionar `.htaccess` com basic-auth no staged dir (se HostGator permitir)
   - OU acessar via path direto: `https://$DOMAIN/public_html_new/` (se configurado)
   - Verificar que ao menos `/index.html` retorna 200
6. Capturar output em `site/docs/deploy-evidence/rsync-<timestamp>.log`
7. Reportar tabela: arquivos transferidos | bytes | tempo total

### Critério de saída
- 4 jobs rsync exit 0
- Staged dir verificado
- SLOT MAIN libera atomic switch

---

## SLOT C — Sub-agente Smoke + Lighthouse Pós-Deploy

**Skill carregada**: `awt-e2e-testing` + `application-performance-performance-optimization`
**Spawn via**: tool `subagent` com role `kiro_default`
**Executa APÓS atomic switch (controlado pelo SLOT MAIN)**

### Tarefas
1. Aguardar sinal do SLOT MAIN: `SWITCH_OK`
2. Executar `.\site\scripts\hostgator-smoke-parallel.ps1`:
   - 9 curls paralelos para `https://$DOMAIN<rota>`
   - Verificar HTTP 200 + `<title>` presente + headers de segurança
3. **Em paralelo**: rodar Lighthouse contra produção em 3 páginas críticas:
   ```
   npx lighthouse https://$DOMAIN/ --output=json -p site/docs/deploy-evidence/lh-prod-home.json &
   npx lighthouse https://$DOMAIN/matriculas/ --output=json -p site/docs/deploy-evidence/lh-prod-matriculas.json &
   npx lighthouse https://$DOMAIN/contato/ --output=json -p site/docs/deploy-evidence/lh-prod-contato.json &
   wait
   ```
4. Verificar scores Lighthouse em produção:
   - Performance ≥ 85 (margem de tolerância -5 vs preview)
   - Accessibility ≥ 95
   - Best Practices ≥ 95
   - SEO ≥ 95
5. Verificar HTTPS:
   - Certificado válido + não expirado em < 30 dias
   - HTTP redireciona para HTTPS (301)
   - HSTS header presente
6. Verificar DNS:
   - `nslookup $DOMAIN` retorna IP esperado
   - `dig +short $DOMAIN` retorna mesmo IP
7. Capturar output em `site/docs/deploy-evidence/smoke-prod-<timestamp>.log`
8. Gerar `site/docs/DEPLOY-REPORT.md` consolidando:
   - Tabela 9 rotas × HTTP status × tempo
   - Lighthouse 3 páginas em produção
   - HTTPS check
   - DNS check
   - Headers de segurança
   - Comparação preview vs prod (deltas de score)

### Critério de saída
- 9 rotas retornam HTTP 200
- 3 Lighthouse runs em produção atingem metas (com tolerância -5 em Perf)
- HTTPS válido
- `DEPLOY-REPORT.md` criado

---

## CRITÉRIOS DE ACEITE DA FASE 7

| Gate | Critério | Owner | Bloqueante? |
|---|---|---|---|
| Pré-deploy | QA Fase 6.B = PASSED | MAIN | SIM |
| Preflight | SSH OK, dist/ OK, espaço OK | SLOT A | SIM |
| Backup | tar.gz remoto criado e rotacionado | SLOT A | SIM |
| Build | npm run build retorna 0 erros, 9 páginas | SLOT A | SIM |
| Rsync staged | 4 jobs paralelos exit 0, staged dir OK | SLOT B | SIM |
| Atomic switch | mv executado, SWITCH_OK confirmado | MAIN | SIM |
| Smoke prod | 9 rotas HTTP 200 | SLOT C | SIM |
| Lighthouse prod | Scores ≥ targets (com tolerância) | SLOT C | NÃO (advisory) |
| HTTPS | Certificado válido, HSTS, redirect 301 | SLOT C | SIM |
| Janela | Switch < 1s, total < 5min | MAIN | NÃO (advisory) |
| Rollback ready | Versão `*_OLD_*` preservada para fast rollback | MAIN | SIM |

---

## ENTREGÁVEIS

| # | Arquivo / Estado | Owner |
|---|-----------------|-------|
| 1 | Site publicado em `https://$DOMAIN` | MAIN |
| 2 | `site/docs/deploy-evidence/preflight-<ts>.log` | SLOT A |
| 3 | `site/docs/deploy-evidence/backup-<ts>.log` | SLOT A |
| 4 | `site/docs/deploy-evidence/build-<ts>.log` | SLOT A |
| 5 | `site/docs/deploy-evidence/rsync-<ts>.log` | SLOT B |
| 6 | `site/docs/deploy-evidence/smoke-prod-<ts>.log` | SLOT C |
| 7 | `site/docs/deploy-evidence/lh-prod-*.json` (×3) | SLOT C |
| 8 | `site/docs/DEPLOY-REPORT.md` | SLOT C |
| 9 | Rollback ready (versão `*_OLD_*` no servidor) | MAIN |
| 10 | Check-in `COMPLETED` em `CHECKIN-LOG.md` | MAIN |
| 11 | Atualização `ROADMAP.md` Fase 7 → ✅ DONE | MAIN |
| 12 | Handoff para Fase 8 | MAIN |

---

## PLANO DE ROLLBACK (caso algo dê errado)

### Cenário 1: Smoke pós-deploy falha (HTTP 5xx)
1. SLOT MAIN executa: `.\site\scripts\hostgator-rollback-fast.ps1`
2. Tempo: < 2s
3. Site volta ao estado anterior
4. Investigar causa raiz no diretório `*_FAILED_*` preservado
5. Registrar `FAILED` no CHECKIN-LOG com causa

### Cenário 2: Atomic switch parcial (mv quebra)
1. SLOT MAIN executa rollback-fast (revertendo o mv)
2. Verifica que `public_html` voltou ao estado anterior
3. `public_html_new` permanece para investigação

### Cenário 3: Cenário extremo (rollback-fast também falha)
1. Restaurar via `hostgator-rollback-tar.ps1` usando o backup tar.gz
2. Tempo: ~30s
3. Pode haver downtime de 30s nesse cenário

### Cenário 4: SSH cai durante deploy
1. Verificar se atomic switch já ocorreu
2. Se ANTES do switch: deploy não afetou produção, retomar de onde parou
3. Se APÓS o switch: produção já está com versão nova; smoke valida

---

## REGRAS NÃO-NEGOCIÁVEIS

- ❌ NUNCA fazer deploy sem QA-SUMMARY = PASSED
- ❌ NUNCA fazer deploy sem backup confirmado
- ❌ NUNCA pular o staged dir (não fazer rsync direto em `public_html`)
- ❌ NUNCA logar credenciais ou paths sensíveis em logs públicos
- ❌ NUNCA executar deploy se algum sub-agente reportar `FAIL`
- ✅ TODOS os logs em `site/docs/deploy-evidence/` (gitignored)
- ✅ Atomic switch executado SOMENTE pelo SLOT MAIN (single source)
- ✅ Smoke pós-deploy ANTES de declarar `COMPLETED`
- ✅ Rollback ready DURANTE toda a fase
- ✅ Janela de deploy comunicada ao usuário antes de iniciar

---

## HANDOFF DE SAÍDA

```
H-NNN | CODEX-OPS → OPUS-ARCH | Phase 8
Task: Documentação final + fechamento de handoffs históricos
Pré-requisitos:
- Fase 7 COMPLETED
- Site publicado em produção
- DEPLOY-REPORT.md disponível
- 6 reports QA disponíveis (Lighthouse, A11y, SEO, Bundle, QA-SUMMARY, DEPLOY-REPORT)
Próximo prompt: .planning/prompts/FASE8-DOCS.md
```

---

*Prompt criado: 2026-05-18 por OPUS-ARCH*
*Substitui FASE7-DEPLOY.md (versão sequencial overwrite com downtime)*
