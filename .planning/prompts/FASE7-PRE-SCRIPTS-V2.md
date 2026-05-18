# FASE 7-PRE — Reescrita dos Scripts de Deploy v2 (Atomic Staged + Paralelo)

> **Fase**: 7-PRE — Pré-trabalho para Deploy
> **Status**: Pode rodar em paralelo à Fase 6.A/6.B (não bloqueia)
> **Modelo de execução**: **1 slot** (sub-agente único especializado)
> **Tempo estimado**: ~45min
> **Bloqueador para**: Fase 7 (execução do deploy real)

---

## CONTEXTO PRÉ-CARREGADO

### Por que reescrever os scripts?

Os 5 scripts atuais em `site/scripts/hostgator-*.ps1` (criados em 2026-05-18T00:31 pela CODEX-OPS, CHECKIN #011) usam **modelo sequencial overwrite**:

```
preflight → backup → build → rsync OVERWRITE em public_html/ → validate
```

**Problemas:**
- ⏱️ Janela de downtime de ~30s (CSS antigo + HTML novo coexistindo)
- 🔄 Rollback lento (precisa restaurar tar.gz de backup)
- 🐌 rsync single-thread, ~60s para transferir
- 🔒 Sem verificação de integridade pós-transfer

### O que vamos entregar (v2)

Modelo **Atomic Staged Deploy + Paralelo**:

```
preflight ┐
backup    ├─ paralelo (Start-Job background)
build     ┘
                ↓
rsync 4-jobs paralelos → public_html_new/ (sem tocar produção)
                ↓
smoke staging (basic-auth via .htaccess)
                ↓
atomic switch: mv public_html public_html_old && mv public_html_new public_html
                ↓
smoke prod 9 URLs paralelas (xargs -P 9)
                ↓
✅ Deploy ~3-5min, ZERO DOWNTIME, ROLLBACK <2s
```

### Arquivos de referência
1. `.planning/ADRs.md` (ADR-003 — deploy SSH/rsync)
2. `.planning/AGENT-CONTRACT.md` — file ownership de `scripts/*` é CODEX-OPS
3. `site/scripts/hostgator-*.ps1` — versão v1 atual (manter como `v1` arquivado)
4. `site/scripts/.env.deploy.example` — variáveis necessárias

---

## SLOT ÚNICO — Sub-agente Deployment Pipeline Designer

**Skill carregada**: `deployment-pipeline-design` + `deployment-procedures`
**Spawn via**: tool `subagent` com role `kiro_default`
**Owner formal no contrato**: CODEX-OPS (executando como sub-agente)

---

## ENTREGÁVEIS

### 1. Arquivar v1 (preservar para referência/rollback)
```
site/scripts/v1-archive/
├── hostgator-preflight.ps1  (mover do raiz scripts/)
├── hostgator-backup.ps1
├── hostgator-deploy.ps1
├── hostgator-rollback.ps1
└── hostgator-validate.ps1
```

### 2. Scripts v2 paralelos (novos)

#### `site/scripts/hostgator-deploy-v2.ps1` (orquestrador principal)
- Aceita flags: `-DryRun`, `-SkipBackup`, `-SkipPreflight`, `-StagedDir <name>`
- Lê `.env.deploy.local`
- Chama subscripts em paralelo via `Start-Job`:
  ```powershell
  $j1 = Start-Job -ScriptBlock { .\hostgator-preflight.ps1 }
  $j2 = Start-Job -ScriptBlock { .\hostgator-backup.ps1 }
  $j3 = Start-Job -ScriptBlock { Set-Location site; npm run build }
  Wait-Job $j1, $j2, $j3
  Receive-Job $j1, $j2, $j3
  ```
- Após paralelo concluir, chama `hostgator-rsync-parallel.ps1`
- Chama `hostgator-atomic-switch.ps1`
- Chama `hostgator-smoke-parallel.ps1`
- Reporta tempo total decorrido por etapa
- Exit codes: `0` OK, `1` preflight falhou, `2` build falhou, `3` rsync falhou, `4` smoke falhou

#### `site/scripts/hostgator-preflight.ps1` (mantido, mas atualizado)
- Verifica SSH connectivity (`ssh -o BatchMode=yes -o ConnectTimeout=5 user@host echo ok`)
- Verifica `.env.deploy.local` com 4 vars: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_PATH`, `DEPLOY_PORT`
- Verifica disco remoto (`ssh user@host "df -h $DEPLOY_PATH"` — pelo menos 500MB livre)
- Verifica `site/dist/` existe e tem ao menos 9 `index.html` (uma por rota)
- Lista contagem + tamanho total dos arquivos a deployar
- Exit 0 se OK, 1 se qualquer check falhar

#### `site/scripts/hostgator-backup.ps1` (mantido, otimizado)
- SSH para servidor
- `tar -czf ~/backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz -C $(dirname $DEPLOY_PATH) $(basename $DEPLOY_PATH)`
- Manter últimos 5 backups (rotacionar deletando mais antigos)
- Confirmar backup criado com `ls -la` + tamanho
- Exit 0 se OK

#### `site/scripts/hostgator-rsync-parallel.ps1` (NOVO)
- Recebe `-StagedDir` (default: `public_html_new`)
- Cria diretório staged remoto: `ssh user@host "mkdir -p $DEPLOY_PATH_STAGED"`
- Split por top-level dirs em `dist/`:
  - Job 1: `dist/_astro/` → `$STAGED/_astro/`
  - Job 2: `dist/images/` → `$STAGED/images/`
  - Job 3: HTMLs raiz (`*.html`, `favicon.*`, `og-image.*`, `robots.txt`, `*.xml`) → `$STAGED/`
  - Job 4: rotas (`contato/`, `estrutura/`, `matriculas/`, etc.) → `$STAGED/<rota>/`
- Executar 4 jobs em paralelo via `Start-Job` ou `xargs -P 4` (PowerShell ParallelForEach se PS 7+)
- rsync flags: `-avz --delete --checksum --exclude='.env*' --exclude='backup_*'`
- Verificar exit code de cada job; se qualquer falhar, abort
- Reportar bytes transferidos + tempo
- Exit 0 se OK

#### `site/scripts/hostgator-atomic-switch.ps1` (NOVO)
- Recebe `-StagedDir` (default: `public_html_new`)
- Em uma única conexão SSH:
  ```bash
  ssh user@host "
    set -e
    mv $DEPLOY_PATH $DEPLOY_PATH_OLD_$(date +%s)
    mv $DEPLOY_PATH_STAGED $DEPLOY_PATH
    ls -ld $DEPLOY_PATH
    echo SWITCH_OK
  "
  ```
- Verificar saída `SWITCH_OK` no stdout
- Manter últimas 3 versões `*_OLD_*` (rotacionar)
- Reportar timestamp do switch (referência para rollback)
- Exit 0 se OK

#### `site/scripts/hostgator-smoke-parallel.ps1` (NOVO)
- Lista das 9 rotas:
  ```
  /
  /proposta-pedagogica/
  /turmas/
  /estrutura/
  /tecnologia/
  /seguranca/
  /contato/
  /matriculas/
  /politica-de-privacidade/
  ```
- Para cada rota, em paralelo (ParallelForEach -ThrottleLimit 9):
  - `curl -sS -o /dev/null -w "%{http_code} %{time_total}" https://$DOMAIN<rota>`
  - Verificar HTTP 200
  - Verificar conteúdo: `curl -sS https://$DOMAIN<rota> | grep -i "<title>"` retorna match
  - Verificar headers de segurança: `X-Frame-Options`, `Strict-Transport-Security`
- Verificar `robots.txt` e `sitemap-index.xml` HTTP 200
- Reportar tabela: rota | status | tempo | OK/FAIL
- Exit 0 se 100% PASS, 1 se qualquer falhar

#### `site/scripts/hostgator-rollback-fast.ps1` (NOVO)
- Lista versões `public_html_OLD_*` no servidor
- Aceita `-Version <timestamp>` ou usa última automaticamente
- Em uma conexão SSH:
  ```bash
  ssh user@host "
    set -e
    mv $DEPLOY_PATH $DEPLOY_PATH_FAILED_$(date +%s)
    mv $DEPLOY_PATH_OLD_$VERSION $DEPLOY_PATH
    echo ROLLBACK_OK
  "
  ```
- Reportar tempo decorrido (esperado < 2s)
- Exit 0 se OK

#### `site/scripts/hostgator-rollback-tar.ps1` (mantido — fallback)
- Versão antiga baseada em tar.gz, para casos extremos
- Marcar como "EMERGENCY ROLLBACK — usar apenas se rollback-fast falhar"

### 3. Documentação atualizada

#### `site/scripts/README.md` (NOVO)
- Tabela com cada script + descrição + uso
- Diagrama Mermaid do fluxo paralelo
- Comparação v1 vs v2 (downtime, tempo, rollback speed)
- Exemplos de uso:
  ```
  # Deploy completo paralelo
  .\hostgator-deploy-v2.ps1
  
  # Dry-run (não transfere, só simula)
  .\hostgator-deploy-v2.ps1 -DryRun
  
  # Rollback rápido (< 2s)
  .\hostgator-rollback-fast.ps1
  
  # Rollback de emergência (tar.gz)
  .\hostgator-rollback-tar.ps1
  ```

### 4. Atualização de docs existentes

- Atualizar `site/docs/DEPLOY-GUIDE.md` para refletir o pipeline v2
- Atualizar `site/docs/BACKUP-STRATEGY.md` com a estratégia de versões `*_OLD_*` (3 últimas) + tar.gz (5 últimos)
- Atualizar `site/docs/TROUBLESHOOTING.md` com cenários novos (atomic switch falha, mv permission denied, staged dir órfão)

---

## CRITÉRIOS DE ACEITE

| Gate | Critério |
|---|---|
| Sintaxe PS | `Get-Command` parse sem erros para todos os 8 scripts |
| Lint | `Invoke-ScriptAnalyzer` sem warnings de severity ≥ Warning |
| Idempotência | Rodar deploy 2× seguidas funciona (segundo run detecta sem mudanças) |
| Rollback | Rollback-fast restaura em < 2s confirmado em dry-run |
| Documentação | `site/scripts/README.md` criado com diagrama Mermaid |
| v1 preservado | `site/scripts/v1-archive/` contém os 5 scripts originais |
| `.env.deploy.example` | Atualizado com variáveis novas (se houver) |

---

## ENTREGÁVEIS RESUMIDO

| # | Arquivo | Tipo |
|---|---------|------|
| 1 | `site/scripts/hostgator-deploy-v2.ps1` | Script (orquestrador) |
| 2 | `site/scripts/hostgator-preflight.ps1` | Script (atualizado) |
| 3 | `site/scripts/hostgator-backup.ps1` | Script (atualizado) |
| 4 | `site/scripts/hostgator-rsync-parallel.ps1` | Script (novo) |
| 5 | `site/scripts/hostgator-atomic-switch.ps1` | Script (novo) |
| 6 | `site/scripts/hostgator-smoke-parallel.ps1` | Script (novo) |
| 7 | `site/scripts/hostgator-rollback-fast.ps1` | Script (novo) |
| 8 | `site/scripts/hostgator-rollback-tar.ps1` | Script (mantido como fallback) |
| 9 | `site/scripts/README.md` | Doc (novo) |
| 10 | `site/scripts/v1-archive/*` (5 scripts) | Arquivamento |
| 11 | `site/docs/DEPLOY-GUIDE.md` | Doc (atualizado) |
| 12 | `site/docs/BACKUP-STRATEGY.md` | Doc (atualizado) |
| 13 | `site/docs/TROUBLESHOOTING.md` | Doc (atualizado) |
| 14 | Check-in `COMPLETED` em `CHECKIN-LOG.md` | Log |

---

## REGRAS NÃO-NEGOCIÁVEIS

- ❌ NÃO testar contra produção real (apenas dry-run + sintaxe + parser)
- ❌ NÃO commitar `.env.deploy.local` ou credenciais
- ❌ NÃO remover v1 — arquivar em `v1-archive/`
- ❌ NÃO usar `rm -rf` sem confirmação dupla
- ✅ TODOS os scripts devem rodar em PowerShell 5.1+ (Windows nativo) e PS 7+ (cross-platform)
- ✅ Comentários inline explicando cada bloco crítico
- ✅ Header de arquivo no topo de cada script (vide AGENT-CONTRACT §8.2)
- ✅ Testar parser via `[scriptblock]::Create((Get-Content $script -Raw))`
- ✅ Sem credenciais hardcoded — sempre via `.env.deploy.local`

---

## HANDOFF DE SAÍDA

```
H-NNN | CODEX-OPS sub → CODEX-OPS main | Phase 7
Task: Scripts v2 paralelos prontos para uso na Fase 7 (Deploy)
Pré-requisitos:
- Scripts em site/scripts/v2 prontos
- Documentação atualizada
- Parser validado em todos os scripts
- v1 arquivado preservado
Próximo prompt: .planning/prompts/FASE7-DEPLOY-PARALELO.md
```

---

*Prompt criado: 2026-05-18 por OPUS-ARCH*
