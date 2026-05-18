# CODEX-OPS — WAVE FINAL: P3 (QA Audit) + P3.5 (Pre-Deploy Pack)

> **Arquivo**: `.planning/prompts/CODEX-WAVE-FINAL.md`
> **Disparado**: por OPUS-ARCH em 2026-05-18
> **Modelo**: 7 sub-agentes paralelos (4 P3 + 3 P3.5)
> **Tempo estimado**: ~4h (gargalo Lighthouse no P3 SLOT A)
> **Bloqueador para**: P4 Deploy HostGator

---

## ⚡ PROMPT (copiar tudo abaixo desta linha para o CODEX)

```
Você é CODEX-OPS. Vai executar AGORA a Sprint Final WAVE: P3 (QA Audit completo) + P3.5 (Pre-Deploy Pack) com 7 sub-agentes paralelos.

Working dir: /mnt/d/VMs/Projetos/Web_Devlop_EscolaVillaKids/
Repo: site Astro+Tailwind v4, 9 páginas estáticas, DS v3.0 Purple/Fredoka. Build passa em 9.33s.

═══════════════════════════════════════════════════════════════
CONTEXTO OBRIGATÓRIO — LEIA NESTA ORDEM ANTES DE COMEÇAR
═══════════════════════════════════════════════════════════════

1. .planning/AGENT-CONTRACT.md — seu contrato (file ownership, gates §5)
2. .planning/CHECKIN-LOG.md — verificar entries #016-#021 (estado atual: H-012 ⏳ READY FOR PICKUP)
3. .planning/FINAL-SPRINT-PLAN.md — plano mestre da sprint
4. .planning/prompts/FASE6-QA-AUDIT.md — prompt formal P3 (251 linhas, leia COMPLETO)
5. .planning/prompts/FASE7-DEPLOY-PARALELO.md — consumidor downstream do P3
6. site/scripts/README.md — fluxo deploy v2 (já criado)
7. site/docs/POLISH-VISUAL-DIFF.md — handoff entrada do GEMINI-UX

═══════════════════════════════════════════════════════════════
SKILLS A CARREGAR (path absoluto Windows convertido para WSL)
═══════════════════════════════════════════════════════════════

Pré-aqueça antes de disparar os subs:
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/audit-skills/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/application-performance-performance-optimization/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/accessibility-compliance-accessibility-audit/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/fixing-accessibility/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/ai-seo/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/local-legal-seo-audit/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/awt-e2e-testing/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/azure-microsoft-playwright-testing-ts/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/deployment-procedures/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/deployment-validation-config-validate/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/codebase-cleanup-deps-audit/
- /mnt/c/Users/dataops-lab/.gemini/antigravity/skills/content-creator/

═══════════════════════════════════════════════════════════════
EXECUÇÃO — 7 SUB-AGENTES PARALELOS
═══════════════════════════════════════════════════════════════

### CHECK-IN OBRIGATÓRIO ANTES DE DISPARAR
Adicione no .planning/CHECKIN-LOG.md:
| NNN | <ts UTC> | — | CODEX-OPS | Phase 6.B + 7-PRE | WAVE FINAL: P3 QA Audit + P3.5 Pre-Deploy Pack — disparando 7 subs paralelos | IN_PROGRESS | Skills carregadas; H-012 picked up |

### PREP — Servidor preview ativo
cd site && npm run build && npx serve dist -l 4321 &
Aguarde 3s. Confirme http://localhost:4321/ retorna 200.

═══════════════════════════════════════════════════════════════
P3 — QA Audit Completo (4 slots: 1 main + 3 subs paralelos)
═══════════════════════════════════════════════════════════════

──────────────────────────────────────────────
SLOT P3-MAIN — VOCÊ MESMO orquestra
──────────────────────────────────────────────
Skills: audit-skills, awt-e2e-testing, azure-microsoft-playwright-testing-ts

Ações:
1. Disparar 3 subs (P3-A, P3-B, P3-C) em paralelo
2. Em paralelo, executar Playwright E2E nas 9 rotas:
   - /, /proposta-pedagogica/, /turmas/, /estrutura/, /tecnologia/,
     /seguranca/, /contato/, /matriculas/, /politica-de-privacidade/
   - Smoke navigation: clicar todos os links do Header/Footer/CTAs
   - Form interaction em /contato/ + /matriculas/ (preencher + validar honeypot)
   - Console limpo (zero error/warn críticos)
   - Zero requests 404
   - Salvar trace + screenshots em site/docs/E2E-EVIDENCE/
3. Aguardar 3 subs concluírem
4. Consolidar site/docs/QA-SUMMARY.md:
   - Tabela 9 páginas × 4 categorias Lighthouse
   - Tabela violações A11y por severidade (critical/serious/moderate/minor)
   - Tabela checklist SEO por página
   - Bundle stats (HTML/CSS/JS sizes per page)
   - Issues classificados: 🔴 CRÍTICO / 🟡 ALTO / 🟢 MÉDIO / ⚪ BAIXO
5. Loop de fixes (se houver 🔴 ou 🟡):
   - Atribuir issue por natureza (estrutural→OPUS, visual→GEMINI, perf/server→VOCÊ)
   - Aplicar fix → re-rodar audit → atualizar QA-SUMMARY.md
   - Máximo 2 ciclos antes de escalar
6. Parar servidor preview
7. Emitir QA-SUMMARY.md PASSED ou NEEDS_REVIEW

──────────────────────────────────────────────
SLOT P3-A — sub Lighthouse + Bundle
──────────────────────────────────────────────
Skills: application-performance-performance-optimization

Para cada uma das 9 rotas, rode mobile + desktop:
npx lighthouse http://localhost:4321/<rota>/ \
  --only-categories=performance,accessibility,best-practices,seo \
  --output=json --output-path=site/docs/lighthouse-raw/<rota>.json \
  --quiet --chrome-flags="--headless --no-sandbox"

Gere site/docs/LIGHTHOUSE-REPORT.md:
- Tabela 9 páginas × 4 categorias (mobile + desktop)
- Top 5 oportunidades por página
- Métricas Core Web Vitals: LCP, FID, CLS, FCP, TBT, TTI, SI

Gere site/docs/BUNDLE-REPORT.md:
- Listar tamanho de cada arquivo em site/dist/
- Top 10 mais pesados
- CSS unused (npx purgecss --content "site/dist/**/*.html" --css "site/dist/_astro/*.css" dry-run)
- JS bundle por chunk
- Imagens > 100KB sinalizadas
- Total HTML+CSS+JS ≤ 500KB

Metas (não-negociáveis):
- Performance ≥ 90 / 9 páginas
- Accessibility ≥ 95 / 9 páginas
- Best Practices ≥ 95 / 9 páginas
- SEO ≥ 95 / 9 páginas
- Bundle total ≤ 500KB (HTML+CSS+JS)

──────────────────────────────────────────────
SLOT P3-B — sub Accessibility (WCAG 2.1 AA)
──────────────────────────────────────────────
Skills: accessibility-compliance-accessibility-audit + fixing-accessibility

1. Rodar axe-core via Playwright nas 9 rotas:
   import AxeBuilder from '@axe-core/playwright';
   const results = await new AxeBuilder({ page })
     .withTags(['wcag2a','wcag2aa','wcag21a','wcag21aa']).analyze();
   Salvar em site/docs/a11y-raw/<rota>.json

2. Verificar manualmente:
   - 1 <h1> por página, hierarquia sem pular
   - Landmarks: header/nav/main/footer
   - Alt text em 100% das imagens
   - Labels associadas a inputs
   - Focus visível em interativos
   - Tab order lógico (testar em todas as 9)
   - Skip link funcional (#main-content)
   - aria-expanded/controls/current corretos
   - Contraste WCAG AA (4.5:1 texto, 3:1 large)

3. Screen reader smoke (NVDA simulator ou descrição manual)

4. Gerar site/docs/ACCESSIBILITY-REPORT.md:
   - PASS/FAIL por página
   - Violações por severidade
   - Tabela de fixes aplicados
   - Recomendações v1.1

Metas:
- 0 violations critical em todas 9 páginas
- 0 violations serious em todas 9 páginas

──────────────────────────────────────────────
SLOT P3-C — sub SEO
──────────────────────────────────────────────
Skills: ai-seo + local-legal-seo-audit

1. Auditar cada uma das 9 rotas:
   - <title> único, ≤60 chars, com keyword principal
   - <meta name="description"> único, ≤160 chars, com CTA
   - <meta property="og:*"> completo (title/description/image/url/type/locale)
   - <meta name="twitter:*"> completo
   - <link rel="canonical"> URL absoluta correta
   - 1 <h1> por página
   - Schema.org JSON-LD válido (Node script vs https://validator.schema.org/)

2. Schema.org coverage:
   - LocalBusiness + EducationalOrganization na home
   - BreadcrumbList em internas
   - FAQPage onde houver FAQ
   - ContactPage em /contato/

3. Sitemap & robots:
   - site/dist/sitemap-index.xml válido
   - site/dist/sitemap-0.xml lista 9 páginas
   - site/dist/robots.txt OK + aponta sitemap

4. Local SEO (escola brasileira em SP):
   - Endereço estruturado, NAP consistente
   - Mapa em /contato/
   - Phone tel:, WhatsApp wa.me/55...

5. Gerar site/docs/SEO-REPORT.md:
   - Checklist por página (✅/❌)
   - Schema.org validation results
   - Lista de fixes aplicados

Metas:
- 100% Schema.org JSON-LD válido
- Lighthouse SEO ≥ 95 (cross-check com SLOT A)

═══════════════════════════════════════════════════════════════
P3.5 — Pre-Deploy Pack (3 subs paralelos adicionais)
═══════════════════════════════════════════════════════════════

──────────────────────────────────────────────
SLOT P3.5-A — sub Deploy-day Runbook detalhado
──────────────────────────────────────────────
Skills: deployment-procedures + content-creator

Criar site/docs/DEPLOY-RUNBOOK.md com:

1. Pre-flight checklist (lista verificável):
   - SSH config presente em ~/.ssh/ ou .env.deploy.local
   - .env.deploy.local com 4 vars (DEPLOY_HOST/USER/PATH/PORT)
   - npm run build retorna 0 erros, 9 páginas
   - QA-SUMMARY.md = PASSED
   - Espaço remoto ≥ 500MB
   - Ambiente PowerShell 5.1+ ou 7+

2. Janela ideal de deploy:
   - Horário com menos tráfego (sugestão: madrugada ou final de semana)
   - Avisos prévios (Stakeholders, social media off)
   - Estimativa de duração (5min janela real)

3. Comandos exatos passo-a-passo:
   - PASSO 1: cd site/scripts && .\hostgator-deploy-v2.ps1 -DryRun
   - PASSO 2 (se dry-run OK): .\hostgator-deploy-v2.ps1
   - PASSO 3: aguardar SWITCH_OK no stdout
   - PASSO 4: smoke prod já roda automático
   - PASSO 5: validar visualmente o site

4. Critérios go/no-go por gate:
   - Preflight FAIL → abort total
   - Backup FAIL → abort total
   - Rsync FAIL → não fazer switch, investigar
   - Switch OK → ponto-de-não-retorno (rollback via mv reverso disponível)
   - Smoke pós FAIL → rollback-fast imediato

5. Plano de comunicação se algo der errado:
   - Mensagem para usuário (texto pronto)
   - Mensagem para stakeholders (texto pronto)
   - ETA de resolução

6. Lista NUNCA FAZER durante deploy:
   - NUNCA editar arquivos no servidor manualmente
   - NUNCA pular o staged dir
   - NUNCA pular o backup
   - NUNCA fazer deploy sem QA PASSED
   - NUNCA pushar credenciais em logs públicos

7. Pós-deploy:
   - Monitorar 30min (logs, smoke, lighthouse prod)
   - Cache CDN/browser (esperar TTL)
   - Validar formulários reais
   - Comunicar stakeholders SUCESSO

Tempo estimado: ~45min

──────────────────────────────────────────────
SLOT P3.5-B — sub Build Optimization Deep Audit
──────────────────────────────────────────────
Skills: application-performance-performance-optimization + codebase-cleanup-deps-audit

1. Build flags max-opt:
   - astro.config.mjs: image.service astro:assets, build.inlineStylesheets 'auto'
   - Comparar bundle antes/depois

2. Pre-compression Brotli + gzip:
   - Adicionar plugin Vite ou script post-build
   - Gerar .br e .gz para todos HTML/CSS/JS
   - Atualizar .htaccess para servir versão pré-comprimida (mod_brotli + mod_deflate)

3. Image optimization:
   - Verificar og-image.jpg (35KB) → AVIF (target ~15KB)
   - SVGs em public/images/ → SVGO se ainda não rodou
   - Confirmar todos com width/height (já feito no commit Phase 6)

4. CSS purge agressivo:
   - npx purgecss --content "site/dist/**/*.html" --css "site/dist/_astro/*.css" --output site/dist/_astro/purged/
   - Comparar tamanhos
   - Aplicar se redução ≥ 5%

5. Dependency audit:
   - npm ls (verificar deps não-usadas)
   - Considerar remover @types/* não-usadas no runtime

6. Gerar site/docs/BUILD-OPT-REPORT.md:
   - Antes/depois de cada otimização
   - Decisão: aplicar ou parquear v1.1
   - Bundle final esperado vs target ≤500KB

7. Aplicar otimizações se ganho ≥ 5%; commit atômico.

Tempo estimado: ~1h (gargalo)

──────────────────────────────────────────────
SLOT P3.5-D — sub Pipeline v2 Dry-run completo
──────────────────────────────────────────────
Skills: deployment-validation-config-validate + deployment-procedures

1. Parser audit em todos os 8 scripts:
   foreach ($s in 'site/scripts/*.ps1') {
     [scriptblock]::Create((Get-Content $s -Raw)) | Out-Null
   }
   Reportar OK/FAIL por script.

2. Lint via PSScriptAnalyzer:
   Invoke-ScriptAnalyzer -Path site/scripts/ -Severity Warning
   Reportar warnings (deve ser 0).

3. Dry-run hostgator-deploy-v2.ps1 -DryRun:
   - Simular fluxo completo SEM SSH real
   - Capturar logs
   - Validar:
     * Start-Job paralelo OK
     * Detecção de .env.deploy.local OK
     * Parsing das 4 vars OK
     * Rsync paths construídos corretamente
     * Atomic switch comando bem formado
     * Smoke comandos curl bem formados

4. Edge cases:
   - .env.deploy.local ausente → mensagem clara
   - dist/ vazio → abort
   - dist/ com arquivos quebrados → detectar
   - Credenciais hardcoded → grep -r '"DEPLOY_' site/scripts/*.ps1 deve retornar 0
   - Permissões de execução: file headers presentes

5. Gerar site/docs/PIPELINE-V2-DRY-RUN-REPORT.md:
   - Resultado parser por script
   - Resultado lint
   - Resultado dry-run completo
   - Edge cases testados
   - Pronto para P4 ou bloqueios

Tempo estimado: ~30min

═══════════════════════════════════════════════════════════════
ENTREGÁVEIS CONSOLIDADOS DA WAVE
═══════════════════════════════════════════════════════════════

P3:
- site/docs/LIGHTHOUSE-REPORT.md
- site/docs/BUNDLE-REPORT.md
- site/docs/lighthouse-raw/<rota>.json (×9)
- site/docs/ACCESSIBILITY-REPORT.md
- site/docs/a11y-raw/<rota>.json (×9)
- site/docs/SEO-REPORT.md
- site/docs/E2E-EVIDENCE/* (traces/screenshots)
- site/docs/QA-SUMMARY.md (consolidado, PASSED/NEEDS_REVIEW)

P3.5:
- site/docs/DEPLOY-RUNBOOK.md
- site/docs/BUILD-OPT-REPORT.md
- site/docs/PIPELINE-V2-DRY-RUN-REPORT.md

═══════════════════════════════════════════════════════════════
COMMITS ATÔMICOS — REGRAS
═══════════════════════════════════════════════════════════════

Após cada SLOT terminar com sucesso:
- Mensagem: "feat(phase6): <slot> — <título resumido> [CODEX-OPS]"
- Exemplos:
  - feat(phase6): Lighthouse + Bundle reports — 9 pages audited [CODEX-OPS]
  - feat(phase6): A11y audit — 9 pages WCAG 2.1 AA [CODEX-OPS]
  - feat(phase6): SEO audit — 9 pages + Schema.org validated [CODEX-OPS]
  - feat(phase7-pre): deploy-day runbook + build opt + dry-run [CODEX-OPS]

═══════════════════════════════════════════════════════════════
CHECKIN-LOG — FORMATO POR SLOT
═══════════════════════════════════════════════════════════════

Após cada slot completar, adicione entrada:

| NNN | <start UTC> | <end UTC> | CODEX-OPS | Phase 6.B (slot X) | <descrição> | COMPLETED | <evidência: arquivos, scores, métricas> |

E no final da WAVE, atualize H-012 para ✅ DELIVERED + crie H-013:
| H-013 | CODEX-OPS | CODEX-OPS | Phase 7 | Deploy HostGator atomic paralelo (P4) | HIGH | site/docs/QA-SUMMARY.md PASSED + DEPLOY-RUNBOOK.md + PIPELINE-V2-DRY-RUN-REPORT.md + scripts v2 ready | ⏳ READY (aguardando SSH credentials do user) |

═══════════════════════════════════════════════════════════════
GATES DE SAÍDA (não-negociáveis)
═══════════════════════════════════════════════════════════════

P3 PASSED requer TODOS:
- Lighthouse Performance ≥ 90 (9/9 páginas)
- Lighthouse Accessibility ≥ 95 (9/9)
- Lighthouse Best Practices ≥ 95 (9/9)
- Lighthouse SEO ≥ 95 (9/9)
- Axe critical violations = 0 (9/9)
- Schema.org JSON-LD 100% válido
- Playwright E2E nas 9 rotas sem console errors / 404s
- QA-SUMMARY.md emitido com status PASSED

P3.5 DONE requer:
- DEPLOY-RUNBOOK.md completo (7 seções)
- BUILD-OPT-REPORT.md com decisões aplicadas
- PIPELINE-V2-DRY-RUN-REPORT.md PASSED

═══════════════════════════════════════════════════════════════
HANDOFF DE SAÍDA
═══════════════════════════════════════════════════════════════

Quando TUDO acima OK, criar HANDOFF-CODEX-DEPLOY.md em .planning/ com:
- Status: P3 PASSED + P3.5 DONE
- Aguardando: SSH credentials do user
- Próximo: P4 (FASE7-DEPLOY-PARALELO.md)
- Ponto de execução: cd site/scripts && .\hostgator-deploy-v2.ps1
- Estimativa P4: ~5min janela

═══════════════════════════════════════════════════════════════
REGRAS NÃO-NEGOCIÁVEIS
═══════════════════════════════════════════════════════════════

❌ NÃO modificar componentes/páginas sem registrar fix em QA-SUMMARY.md
❌ NÃO ignorar critical violations a11y mesmo que Lighthouse passe
❌ NÃO declarar PASSED se algum gate falhar
❌ NÃO commitar credenciais ou paths sensíveis
❌ NÃO disparar P4 nesta sessão (P4 espera GO do user com SSH)
❌ NÃO testar contra produção real (apenas localhost preview)
❌ NÃO mexer em arquivos .planning/* exceto CHECKIN-LOG.md

✅ Cada sub-agente roda INDEPENDENTE, sem dependência cruzada
✅ Resultados em RAW (JSON) + relatório human-readable (MD)
✅ Loop de fix máximo 2 ciclos; se 3º fix necessário, escalar via CHECKIN
✅ Servidor preview parado ao fim da fase
✅ Commits atômicos por slot completado
✅ Reportar tempo total ao fim + classificação de issues por categoria

═══════════════════════════════════════════════════════════════

INÍCIO: registrar check-in IN_PROGRESS, carregar skills, disparar 7 subs paralelos.
FIM: 8 reports + QA-SUMMARY.md PASSED + 3 commits atômicos + HANDOFF-CODEX-DEPLOY.md + check-in COMPLETED.

GO.
```

---

## 📤 Como usar

1. Copie o bloco entre os triplos backticks acima (do `Você é CODEX-OPS...` até o `GO.`).
2. Cole na sua sessão do CODEX-OPS.
3. CODEX dispara 7 subs paralelos.
4. Quando terminar, ele cria `HANDOFF-CODEX-DEPLOY.md` aguardando seu SSH para a P4.

## ⏱️ Timeline esperado

```
T+0:00   Disparo (skills load + check-in)
T+0:05   7 subs paralelos rodando
T+1:00   P3.5-A (Runbook) ✅ + P3.5-D (Dry-run) ✅
T+1:00   P3.5-B (Build opt) ✅
T+1:30   P3-A (Lighthouse) parcial — primeiras 5 páginas
T+2:30   P3-A completo
T+3:00   P3-B (A11y) ✅ + P3-C (SEO) ✅
T+3:30   QA-SUMMARY consolidado
T+4:00   Fix loop se houver issues 🔴/🟡
T+4:30   Re-audit + PASSED
T+5:00   ✅ HANDOFF-CODEX-DEPLOY.md criado, aguardando seu SSH
```

Quando o CODEX confirmar `HANDOFF-CODEX-DEPLOY.md` criado, me avisa e me manda SSH — disparo P4 imediato.

**Em paralelo a essa WAVE do CODEX**, eu já vou disparar **P5 (Docs Final, OPUS 2 slots)** do meu lado para encerrar a sprint. Quer que eu dispare P5 agora?
