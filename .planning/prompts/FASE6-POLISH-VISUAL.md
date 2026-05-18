# FASE 6.A — Polish Visual DS v3.0 (30% restante)

> **Fase**: 6.A — Polish Visual final do Design System v3.0
> **Status**: Migração estrutural já concluída (D-007 executado). Falta polish visual fino.
> **Modelo de execução**: **2 slots paralelos** (OPUS main + 1 sub-agente especializado)
> **Tempo estimado**: ~2h00 (paralelizado)
> **Bloqueador para**: Fase 6.B (QA Audit)

---

## CONTEXTO PRÉ-CARREGADO (LER ANTES DE EXECUTAR)

### Arquivos de governança (obrigatório)
1. `.planning/AGENT-CONTRACT.md` — papéis, gates, file ownership
2. `.planning/AGENT-ONBOARDING.md` — protocolo de check-in
3. `.planning/CHECKIN-LOG.md` — decisão D-007 e histórico
4. `.planning/DESIGN-SYSTEM-V3.md` — referência canônica do DS v3.0
5. `.planning/FINAL-SPRINT-PLAN.md` — plano mestre da sprint final

### Referências visuais (source of truth)
6. `design_system/index.html` — referência **desktop** premium
7. `design_system/styles.css` — tokens canônicos
8. `design_system/app.js` — engine de animações
9. `design_system/villaprime-mobile.html` — **DESCARTADO desta sprint** (mobile patterns extras adiados para v1.1)

### Estado atual confirmado
- ✅ `site/src/styles/global.css` (635 linhas) já com tokens DS v3.0
- ✅ `site/src/layouts/BaseLayout.astro` já carrega Fredoka + Inter
- ✅ `site/src/scripts/app.js` (11.3KB) com canvas particles + IntersectionObserver
- ✅ Todos 13 componentes em `site/src/components/` migrados (zero ocorrências de Playfair/Deep Teal)
- ✅ Todas 9 páginas em `site/src/pages/` migradas
- ✅ `npm run build` passa com 9 páginas + sitemap

---

## SLOT 1 — OPUS-ARCH (main, orquestrador)

**Skill carregada**: `design-taste-frontend`
**Responsabilidade**: diff visual + decisão de aceite + handoff

### Tarefas
1. Abrir `design_system/index.html` no navegador local e capturar layout de referência (texto + screenshot mental)
2. Rodar `npm run build && npm run preview` em `site/` e abrir as 9 páginas
3. Comparar SECTION POR SECTION cada página do site contra a referência:
   - Hero (gradient, blobs, eyebrow chip, H1 com `.accent` span gradient, KPI counters, timing stagger 0.2s/0.4s/0.6s/0.8s/1s)
   - Cards (border-radius 24px, `::before` gradient bar com scaleX(0)→scaleX(1) no hover, card-icon scale(1.1) rotate(-3deg))
   - Buttons (primary purple+glow, magic gradient animado+glow-magenta, white shadow-lg, outline)
   - Badges (5 variantes: purple, green, gold, cyan, magenta — pill shape)
   - Navbar (glassmorphism `backdrop-filter: blur(24px) saturate(180%)`, `.scrolled` shadow, links com `::after` gradient underline animado, CTA com `.btn-magic`)
   - Footer (background `--vp-gray-900`, grid 4-col 2fr/1fr/1fr/1fr, hover color `--vp-cyan`)
   - Forms (input padding 14px 18px, focus border-color purple + box-shadow glow)
   - Testimonials (`::before` quote `\201C`, avatar gradient bg, hover translateY)
4. Listar issues classificados por severidade:
   - 🔴 **CRÍTICO**: quebra identidade visual (cor errada, tipografia errada, gradiente faltando)
   - 🟡 **ALTO**: micro-interaction não funciona (hover, ripple, glassmorphism scroll)
   - 🟢 **MÉDIO**: spacing/line-height divergente do mockup
   - ⚪ **BAIXO**: refinamento opcional
5. Escrever `site/docs/POLISH-VISUAL-DIFF.md` com tabela de issues e prioridade
6. Repassar lista para SLOT 2 executar fixes
7. Validar fixes do SLOT 2: rodar build, navegar páginas, marcar issues como `RESOLVED`/`PENDING`
8. Registrar check-in em `.planning/CHECKIN-LOG.md` com Status `COMPLETED` ou `NEEDS_REVIEW`
9. Criar handoff para CODEX-OPS (Fase 6.B QA Audit) no Handoff Queue

---

## SLOT 2 — GEMINI-UX (sub-agente, executor)

**Skill carregada**: `frontend-developer`
**Spawn via**: tool `subagent` com role `kiro_default`
**Responsabilidade**: aplicar fixes CSS conforme diff do SLOT 1

### Tarefas (executadas APÓS slot 1 entregar `POLISH-VISUAL-DIFF.md`)

1. Ler `site/docs/POLISH-VISUAL-DIFF.md`
2. Para cada issue 🔴 CRÍTICO e 🟡 ALTO:
   - Localizar arquivo afetado em `site/src/components/*` ou `site/src/styles/global.css`
   - Aplicar correção mínima e cirúrgica (não reescrever, só ajustar)
   - Manter compatibilidade com Tailwind v4 e tokens DS v3.0
3. Para issues 🟢 MÉDIO: aplicar somente se não atrasar a entrega
4. Para issues ⚪ BAIXO: registrar em `site/docs/V1.1-BACKLOG.md` para próxima rodada
5. Validações obrigatórias após cada fix:
   - `npm run build` passa sem erros
   - Sem novas violações de WCAG 2.1 AA (contraste mínimo 4.5:1 texto normal, 3:1 texto grande)
   - Sem layout shift novo no hover (CLS neutro)
   - `prefers-reduced-motion` respeitado (animações desativam)
6. Atualizar `POLISH-VISUAL-DIFF.md` marcando cada issue como `FIXED` com:
   - Arquivo modificado
   - Linhas alteradas (start-end)
   - Diff resumido (3-5 linhas)
7. Registrar check-in em `.planning/CHECKIN-LOG.md` como `NEEDS_REVIEW` para SLOT 1 validar

---

## CRITÉRIOS DE ACEITE DA FASE 6.A

| Gate | Critério | Owner |
|---|---|---|
| Build | `npm run build` passa, 9 páginas geradas, sitemap OK | SLOT 2 |
| Visual | Zero issues 🔴 CRÍTICO; ≤ 2 issues 🟡 ALTO restantes (justificados) | SLOT 1 |
| A11y | Contraste WCAG 2.1 AA em 100% dos textos sobre fundos coloridos | SLOT 2 |
| Responsivo | Sem scroll horizontal em 320/375/768/1024/1440 px | SLOT 2 |
| Performance | Sem regressão de bundle size > 5% vs antes do polish | SLOT 1 |
| `prefers-reduced-motion` | Animações desativam corretamente | SLOT 2 |

---

## ENTREGÁVEIS

| # | Arquivo | Owner |
|---|---------|-------|
| 1 | `site/docs/POLISH-VISUAL-DIFF.md` | SLOT 1 → SLOT 2 atualiza |
| 2 | `site/docs/V1.1-BACKLOG.md` (se houver issues ⚪) | SLOT 2 |
| 3 | Componentes/CSS atualizados | SLOT 2 |
| 4 | Check-in `COMPLETED` em `CHECKIN-LOG.md` | SLOT 1 |
| 5 | Handoff para CODEX-OPS (Fase 6.B) no Handoff Queue | SLOT 1 |

---

## HANDOFF DE SAÍDA

```
H-NNN | OPUS-ARCH → CODEX-OPS | Phase 6.B
Task: Disparar QA Audit completo (Lighthouse + A11y + SEO + Bundle/E2E)
Pré-requisitos:
- Fase 6.A COMPLETED
- POLISH-VISUAL-DIFF.md com 0 issues 🔴 e ≤ 2 issues 🟡
- npm run build sem erros
- Branch limpa
Próximo prompt: .planning/prompts/FASE6-QA-AUDIT.md
```

---

## REGRAS NÃO-NEGOCIÁVEIS

- ❌ NÃO reescrever componentes do zero — apenas ajustar fino
- ❌ NÃO adicionar dependências externas
- ❌ NÃO mexer em scripts de deploy (`site/scripts/*`) — domínio CODEX-OPS
- ❌ NÃO modificar arquivos `.planning/*` exceto `CHECKIN-LOG.md`
- ✅ USAR exatamente os valores de `design_system/styles.css` como source of truth
- ✅ PRESERVAR `@import "tailwindcss"` no topo do `global.css`
- ✅ PRESERVAR file headers existentes nos componentes
- ✅ COMMITS atômicos: 1 commit por issue 🔴 ou 🟡 resolvido

---

*Prompt criado: 2026-05-18 por OPUS-ARCH*
*Substitui implicitamente o BLOCO 1 antigo de FASE6-QA.md*
