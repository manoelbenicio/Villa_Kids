# FASE 6.B — QA Audit Completo

> **Fase**: 6.B — Quality Audit (Lighthouse + A11y + SEO + Bundle/E2E)
> **Status**: Aguardando Fase 6.A COMPLETED
> **Modelo de execução**: **4 slots paralelos** (CODEX main + 3 sub-agentes especializados)
> **Tempo estimado**: ~4h00 (paralelizado, gargalo Lighthouse)
> **Bloqueador para**: Fase 7 (Deploy)

---

## CONTEXTO PRÉ-CARREGADO (LER ANTES DE EXECUTAR)

### Arquivos de governança
1. `.planning/AGENT-CONTRACT.md` — Quality Gates Seção 5 (Performance/Security/A11y/SEO)
2. `.planning/CHECKIN-LOG.md` — verificar se Fase 6.A está `COMPLETED` e handoff recebido
3. `.planning/REQUIREMENTS.md` — requisitos QUAL-01..10
4. `.planning/FINAL-SPRINT-PLAN.md` — plano mestre

### Estado esperado de entrada
- ✅ Fase 6.A `COMPLETED` (verificar timestamp + evidência no CHECKIN-LOG)
- ✅ `site/docs/POLISH-VISUAL-DIFF.md` com 0 issues 🔴 e ≤ 2 issues 🟡
- ✅ `npm run build` passa em `site/`
- ✅ 9 páginas geradas em `site/dist/`

### Páginas a auditar (todas)
1. `/` (home)
2. `/proposta-pedagogica/`
3. `/turmas/`
4. `/estrutura/`
5. `/tecnologia/`
6. `/seguranca/`
7. `/contato/`
8. `/matriculas/`
9. `/politica-de-privacidade/`

### Metas (não-negociáveis, AGENT-CONTRACT §5)
- Lighthouse Performance ≥ **90** em todas as 9 páginas
- Lighthouse Accessibility ≥ **95** em todas as 9 páginas
- Lighthouse Best Practices ≥ **95** em todas as 9 páginas
- Lighthouse SEO ≥ **95** em todas as 9 páginas
- Zero violações críticas de A11y (axe severity = `critical`)
- Bundle size total ≤ **500 KB** (HTML+CSS+JS, exclui imagens)

---

## SLOT MAIN — CODEX-OPS (orquestrador)

**Skill carregada**: `audit-skills`
**Responsabilidade**: orquestração + Playwright E2E + consolidação `QA-SUMMARY.md`

### Tarefas
1. Ler `CHECKIN-LOG.md` e confirmar pré-requisitos (Fase 6.A `COMPLETED`)
2. Registrar check-in `IN_PROGRESS` em `CHECKIN-LOG.md`
3. Iniciar servidor preview: `cd site && npm run build && npx serve dist -l 4321 &`
4. **Disparar 3 sub-agentes em paralelo** (Slots A, B, C abaixo)
5. **Em paralelo aos sub-agentes**, executar Playwright E2E nas 9 rotas:
   - Smoke navigation (clicar todos os links de Header/Footer/CTAs)
   - Form interaction em `/contato/` e `/matriculas/` (preencher + validar honeypot)
   - Confirmar console limpo (zero `console.error` ou `console.warn` críticos)
   - Confirmar zero requests 404
   - Salvar trace + screenshots em `site/docs/E2E-EVIDENCE/`
6. Consolidar `site/docs/QA-SUMMARY.md`:
   - Tabela 9 páginas × 4 categorias Lighthouse
   - Tabela violações A11y por severidade
   - Tabela checklist SEO por página
   - Bundle stats (HTML/CSS/JS sizes per page)
   - Issues classificados: 🔴 CRÍTICO / 🟡 ALTO / 🟢 MÉDIO / ⚪ BAIXO
7. **Loop de fixes** (se houver 🔴 ou 🟡):
   - Atribuir issue ao agente correto (estrutural→OPUS-ARCH; visual→GEMINI-UX; perf/server→CODEX-OPS)
   - Aplicar fix → re-rodar audit → atualizar `QA-SUMMARY.md`
   - Máximo 2 ciclos de fix antes de escalar ao usuário
8. Parar servidor preview após audit completo
9. Registrar check-in `COMPLETED` se todas metas atingidas (`PASSED`) ou `NEEDS_REVIEW` se parcialmente atingidas
10. Criar handoff para Fase 7 (Deploy) no Handoff Queue

---

## SLOT A — Sub-agente Lighthouse + Bundle

**Skill carregada**: `application-performance-performance-optimization`
**Spawn via**: tool `subagent` com role `kiro_default`

### Tarefas
1. Aguardar servidor preview ativo em `http://localhost:4321`
2. Para cada uma das 9 páginas, rodar Lighthouse mobile + desktop:
   ```
   npx lighthouse http://localhost:4321/<rota>/ \
     --only-categories=performance,accessibility,best-practices,seo \
     --output=json --output-path=site/docs/lighthouse-raw/<rota>.json \
     --quiet --chrome-flags="--headless --no-sandbox"
   ```
3. Extrair scores e gerar `site/docs/LIGHTHOUSE-REPORT.md`:
   - Tabela 9 páginas × 4 categorias
   - Top 5 oportunidades de otimização por página
   - Métricas Core Web Vitals: LCP, FID, CLS, FCP, TBT, TTI, SI
4. Bundle analysis (`site/docs/BUNDLE-REPORT.md`):
   - Listar tamanho de cada arquivo em `site/dist/`
   - Top 10 arquivos mais pesados
   - CSS unused (rodar `npx purgecss --content "site/dist/**/*.html" --css "site/dist/_astro/*.css"` em modo dry-run)
   - JS bundle por chunk
   - Imagens > 100KB sinalizadas
   - Total HTML+CSS+JS (sem imagens) deve ser ≤ 500KB
5. Identificar issues que IMPEDEM atingir as metas:
   - Performance < 90 → listar oportunidades específicas
   - Acessibilidade < 95 → listar violações
   - SEO < 95 → listar campos faltantes
6. Registrar check-in em `CHECKIN-LOG.md` (sub-agente reportando ao main)

---

## SLOT B — Sub-agente Accessibility (WCAG 2.1 AA)

**Skill carregada**: `accessibility-compliance-accessibility-audit` + `fixing-accessibility`
**Spawn via**: tool `subagent` com role `kiro_default`

### Tarefas
1. Rodar `axe-core` via Playwright nas 9 páginas:
   ```javascript
   import { test, expect } from '@playwright/test';
   import AxeBuilder from '@axe-core/playwright';

   for (const route of ROUTES) {
     test(`a11y ${route}`, async ({ page }) => {
       await page.goto(`http://localhost:4321${route}`);
       const results = await new AxeBuilder({ page })
         .withTags(['wcag2a','wcag2aa','wcag21a','wcag21aa'])
         .analyze();
       // salvar results em site/docs/a11y-raw/${route}.json
     });
   }
   ```
2. Verificar manualmente cada página:
   - 1 `<h1>` por página, hierarquia sem pular níveis
   - Landmarks: `<header>`, `<nav>`, `<main>`, `<footer>`
   - Alt text em 100% das imagens (`<img alt="...">` ou role="presentation" se decorativa)
   - Labels associadas a inputs (`<label for="">` ou `aria-label`)
   - Focus visível em todos os elementos interativos (`:focus-visible` outline)
   - Tab order lógico (testar com Tab nas 9 páginas)
   - Skip link funcional (`#main-content`)
   - `aria-expanded`, `aria-controls`, `aria-current` corretos onde aplicável
   - Contraste validado (já feito em 6.A, re-conferir)
3. Screen reader smoke test (NVDA simulator ou descrição manual de leitura esperada)
4. Gerar `site/docs/ACCESSIBILITY-REPORT.md`:
   - Compliance WCAG 2.1 AA: PASS/FAIL por página
   - Violações por severidade: critical / serious / moderate / minor
   - Tabela de fixes aplicados (se houver) com diff
   - Recomendações para v1.1
5. Registrar check-in em `CHECKIN-LOG.md`

---

## SLOT C — Sub-agente SEO

**Skill carregada**: `ai-seo` + `local-legal-seo-audit`
**Spawn via**: tool `subagent` com role `kiro_default`

### Tarefas
1. Auditar cada uma das 9 páginas:
   - `<title>` único, ≤ 60 chars, com keyword principal
   - `<meta name="description">` único, ≤ 160 chars, com CTA
   - `<meta property="og:*">` completo (title, description, image, url, type, locale)
   - `<meta name="twitter:*">` completo
   - `<link rel="canonical">` apontando para URL absoluta correta
   - 1 `<h1>` por página
   - Alt text em imagens (cross-check com SLOT B)
   - Schema.org JSON-LD válido (validar via https://validator.schema.org/ — usar Node script)
2. Schema.org coverage:
   - `LocalBusiness` + `EducationalOrganization` na home
   - `BreadcrumbList` em páginas internas
   - `FAQPage` onde houver FAQ
   - `ContactPage` em `/contato/`
3. Sitemap & robots:
   - `site/dist/sitemap-index.xml` válido (XML well-formed)
   - `site/dist/sitemap-0.xml` lista todas 9 páginas
   - `site/dist/robots.txt` permite crawl + aponta para sitemap
4. Local SEO (escola brasileira em SP):
   - Endereço presente e estruturado
   - NAP (Nome/Address/Phone) consistente
   - Mapa embed em `/contato/`
   - Phone com `tel:` link
   - WhatsApp com `wa.me/55...`
5. Gerar `site/docs/SEO-REPORT.md`:
   - Checklist por página (✅/❌)
   - Schema.org validation results
   - Lista de fixes aplicados
6. Registrar check-in em `CHECKIN-LOG.md`

---

## CRITÉRIOS DE ACEITE DA FASE 6.B

| Gate | Critério | Owner | Bloqueia Fase 7? |
|---|---|---|---|
| Lighthouse Performance | ≥ 90 em todas 9 páginas | SLOT A | SIM |
| Lighthouse Accessibility | ≥ 95 em todas 9 páginas | SLOT A + B | SIM |
| Lighthouse Best Practices | ≥ 95 em todas 9 páginas | SLOT A | SIM |
| Lighthouse SEO | ≥ 95 em todas 9 páginas | SLOT A + C | SIM |
| Axe critical violations | 0 em todas 9 páginas | SLOT B | SIM |
| Schema.org validation | 100% válido | SLOT C | SIM |
| Bundle size | HTML+CSS+JS ≤ 500KB total | SLOT A | NÃO (advisory) |
| E2E Playwright | 100% das rotas navegáveis sem erro | MAIN | SIM |

---

## ENTREGÁVEIS

| # | Arquivo | Owner |
|---|---------|-------|
| 1 | `site/docs/LIGHTHOUSE-REPORT.md` | SLOT A |
| 2 | `site/docs/BUNDLE-REPORT.md` | SLOT A |
| 3 | `site/docs/lighthouse-raw/<rota>.json` (×9) | SLOT A |
| 4 | `site/docs/ACCESSIBILITY-REPORT.md` | SLOT B |
| 5 | `site/docs/a11y-raw/<rota>.json` (×9) | SLOT B |
| 6 | `site/docs/SEO-REPORT.md` | SLOT C |
| 7 | `site/docs/E2E-EVIDENCE/*` (traces/screenshots) | MAIN |
| 8 | `site/docs/QA-SUMMARY.md` (consolidado) | MAIN |
| 9 | Check-in `COMPLETED` em `CHECKIN-LOG.md` | MAIN |
| 10 | Handoff para Fase 7 (Deploy) | MAIN |

---

## HANDOFF DE SAÍDA

```
H-NNN | CODEX-OPS → CODEX-OPS | Phase 7
Task: Deploy paralelo otimizado para HostGator (atomic staged)
Pré-requisitos:
- Fase 6.B COMPLETED
- QA-SUMMARY.md = PASSED em todas as 9 páginas
- Scripts v2 paralelos disponíveis (criados pré-fase)
- SSH credentials disponíveis (a fornecer pelo user)
Próximo prompt: .planning/prompts/FASE7-DEPLOY-PARALELO.md
```

---

## REGRAS NÃO-NEGOCIÁVEIS

- ❌ NÃO disparar Fase 7 se algum gate `SIM (bloqueia)` falhar
- ❌ NÃO modificar componentes/páginas sem registrar fix em `QA-SUMMARY.md`
- ❌ NÃO ignorar violations `critical` de a11y, mesmo que o score Lighthouse passe
- ✅ Cada sub-agente roda INDEPENDENTE — sem dependência cruzada
- ✅ Resultados salvos em RAW (JSON) + relatório human-readable (MD)
- ✅ Loop de fix máximo 2 ciclos; após isso, escalar
- ✅ Servidor preview parado ao fim da fase
- ✅ COMMITS atômicos por fix (com prefixo `[CODEX-OPS] phase-6:`)

---

*Prompt criado: 2026-05-18 por OPUS-ARCH*
*Substitui FASE6-QA.md (versão antiga misturava migração DS v3.0 + QA + Deploy)*
