# FASE 6 — Design System v3.0 Migration + QA + Deploy
## Workflow Unificado — PRIORIDADE MÁXIMA (ASAP)

> **Decisão D-007**: DS v3.0 Premium aprovado pelo cliente.  
> **Alocação**: 70% CODEX-OPS (+ sub-agentes) / 30% GEMINI-UX  
> **Meta**: Migrar → Auditar → Corrigir → Deploy HostGator

---

# PROMPT 1 — CODEX-OPS: Migração Estrutural DS v3.0 (70%)

```
Você é CODEX-OPS. LEIA OBRIGATORIAMENTE antes de começar:
1. .planning/AGENT-CONTRACT.md (seu contrato)
2. .planning/DESIGN-SYSTEM-V3.md (referência canônica DS v3.0)
3. .planning/CHECKIN-LOG.md (decisão D-007)
4. design_system/styles.css (source of truth — tokens + componentes)
5. design_system/app.js (engine de animações e canvas)
6. design_system/index.html (implementação referência desktop)
7. design_system/villaprime-mobile.html (padrões mobile)
8. site/src/styles/global.css (arquivo ATUAL a ser migrado)

CONTEXTO:
- Projeto: Colégio Villa Prime — website institucional Astro + Tailwind v4
- O site atual usa Deep Teal (#004254) + Playfair Display
- O DS v3.0 final aprovado usa Purple (#9B59B6/#6C3483) + Fredoka
- Você é responsável por 70% da migração (estrutural + tokens + JS)
- GEMINI-UX fará 30% (polish visual, contraste, responsividade)
- Diretório do site: site/
- 9 páginas estáticas (Home, Proposta, Turmas, Estrutura, Tecnologia,
  Segurança, Contato, Matrículas, Privacidade)

---

EXECUTE COM SUB-AGENTES EM PARALELO:

## SUB-AGENTE 1 — TOKENS: Migrar global.css

Reescreva `site/src/styles/global.css` substituindo TODOS os design tokens:

### Cores (Deep Teal → Purple)
- `--color-primary-*` → mapear para `--vp-purple`, `--vp-purple-deep`, `--vp-purple-light`
- `--color-accent-*` → mapear para `--vp-gold`, `--vp-gold-deep`
- Adicionar TODAS as cores novas: `--vp-green`, `--vp-magenta`, `--vp-orange`, `--vp-yellow`, `--vp-cyan`
- Neutrals: substituir por escala gray do DS v3.0 (--vp-gray-50 a --vp-gray-900)
- Status: manter (já são iguais)

### Tipografia
- `--font-display`: 'Playfair Display' → 'Fredoka'
- `--font-sans` / `--font-body`: manter Inter
- Adicionar escala com clamp() conforme DS v3.0

### Gradientes (NOVOS)
- Adicionar: --grad-hero, --grad-magic, --grad-aurora, --grad-sunset, --grad-ocean, --grad-nature, --grad-glass
- Substituir: bg-gradient-primary, bg-gradient-warm, bg-gradient-hero

### Shadows
- Substituir shadows Deep Teal tint → neutral tint do DS v3.0
- Adicionar: shadow-glow-purple, shadow-glow-magenta, shadow-glow-cyan

### Timing + Easing (NOVOS)
- Adicionar: --t-instant, --t-fast, --t-normal, --t-slow, --t-emphasis, --t-dramatic
- Adicionar: --ease-out, --ease-spring, --ease-smooth, --ease-bounce

### Keyframes (NOVOS)
- Adicionar TODOS os keyframes do DS v3.0:
  fadeInUp, fadeInDown, fadeInScale, slideInLeft, slideInRight,
  float, pulse, shimmer, morphBlob, gradientShift, glowPulse,
  countUp, drawPath, ripple

### Scroll-Driven Reveals
- Adicionar: [data-animate], [data-animate].in, variantes (fade-scale, slide-left, slide-right)
- Adicionar: .stagger com transition-delay escalonado

MANTER: @import "tailwindcss", prefers-reduced-motion, .skip-to-content, .reveal

## SUB-AGENTE 2 — GOOGLE FONTS: Atualizar layout base

- Encontre o layout principal (provavelmente site/src/layouts/BaseLayout.astro
  ou similar)
- Substitua o preconnect + font link para:
  ```html
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  ```
- Atualize theme-color meta de #004254 → #6C3483
- Atualize o SEOHead.astro se existir

## SUB-AGENTE 3 — COMPONENTES: Migrar CSS dos componentes

Para CADA componente Astro em site/src/components/:

1. **Navbar**: Implementar glassmorphism premium
   - backdrop-filter: blur(24px) saturate(180%)
   - Borda com rgba(155,89,182,0.06)
   - Estado .scrolled
   - Logo gradient text com --grad-magic
   - Links com ::after gradient underline animado
   - CTA button com --grad-magic + glow

2. **Hero**: Implementar hero premium
   - Background com --grad-hero
   - Animated blobs com morphBlob keyframe
   - Hero chip com glass effect
   - H1 com .accent span (gradient text animado)
   - Metrics grid com KPI counters
   - Timing staggered (0.2s, 0.4s, 0.6s, 0.8s, 1s)

3. **Cards**: Migrar para premium style
   - ::before pseudo com gradient bar (scaleX animado)
   - Card icons com scale(1.1) rotate(-3deg) no hover
   - Glass variant para contextos dark
   - 5 variantes de card-icon: purple, green, magenta, orange, cyan

4. **Buttons**: Implementar sistema premium
   - .btn base com ripple effect (::after)
   - .btn-primary (purple + glow)
   - .btn-magic (gradient animado + glow-magenta)
   - .btn-white (shadow-lg)
   - .btn-outline (transparent + border)
   - .btn-lg variant

5. **Badges**: Criar componentes de badge
   - 5 variantes: badge-purple, badge-green, badge-gold, badge-cyan, badge-magenta
   - Pill shape (border-radius full)

6. **Forms**: Migrar inputs
   - Focus: border-color purple + box-shadow glow
   - Background: --vp-gray-50
   - form-grid 2-col com form-full

7. **Testimonials**: Implementar se existir
   - Quote mark decorativa (::before \201C)
   - Avatar com gradient background
   - Hover com translateY + shadow

8. **Footer**: Migrar para dark premium
   - Background --vp-gray-900
   - Grid 4-col: 2fr 1fr 1fr 1fr
   - Links com hover color --vp-cyan
   - Bottom divider com rgba border

## SUB-AGENTE 4 — JAVASCRIPT: Canvas + Interações

1. Crie ou atualize `site/src/scripts/app.js` (ou equivalente Astro):
   - IntersectionObserver para [data-animate] scroll reveals
   - KPI Counter com requestAnimationFrame (countUp function)
   - Navbar scroll toggle (.scrolled class)
   - Smooth scroll para anchors
   - Form submit handler (feedback visual)

2. Se possível no Astro, adicione o Canvas particle system:
   - Stars com twinkle (100 particles)
   - Floating orbs (30 particles) com hue randomizado
   - Connection lines entre stars próximas
   - Mouse parallax (mx, my tracking)
   - NOTA: Se o Canvas for complexo demais para o Astro, crie como
     componente <script> inline no HeroSection

3. Adicione [data-animate] em TODAS as seções e cards das 9 páginas

## SUB-AGENTE 5 — PAGES: Atualizar as 9 páginas

Para cada uma das 9 páginas em site/src/pages/:
1. Substituir todas as referências de cor Deep Teal inline
2. Adicionar data-animate nos section-heads e grids
3. Adicionar class="stagger" nos grids de cards
4. Atualizar eyebrow text colors para --vp-purple
5. Atualizar section variants (section-alt → --vp-gray-50, section-dark → --vp-gray-900)
6. Verificar que headings usam font-display (agora Fredoka)

---

APÓS TODOS OS SUB-AGENTES:
1. Rode `npm run build` — DEVE compilar com 0 erros
2. Se houver erros, corrija imediatamente
3. Registre check-in em .planning/CHECKIN-LOG.md:
   - Status: COMPLETED
   - Evidência: Build OK, N arquivos migrados
   - Handoff: GEMINI-UX para polish visual (30%)
4. Crie handoff detalhado para GEMINI-UX em .planning/HANDOFF-GEMINI-DS3.md

REGRAS:
- USE design_system/styles.css como SOURCE OF TRUTH para todos os valores
- NÃO invente valores — copie exatamente do DS v3.0
- MANTENHA compatibilidade com Tailwind v4 (@theme block)
- PRESERVE @import "tailwindcss" no topo do global.css
- PRESERVE todos os comentários de header de arquivo
- Atomic commits: 1 commit por sub-agente completado
```

---

# PROMPT 2 — GEMINI-UX: Polish Visual DS v3.0 (30%)

```
Você é GEMINI-UX. LEIA OBRIGATORIAMENTE:
1. .planning/AGENT-CONTRACT.md
2. .planning/DESIGN-SYSTEM-V3.md
3. .planning/HANDOFF-GEMINI-DS3.md (handoff do CODEX-OPS)
4. design_system/index.html (referência visual desktop)
5. design_system/villaprime-mobile.html (referência visual mobile)

CONTEXTO:
- CODEX-OPS migrou 70% dos tokens, componentes e JS
- Você é responsável por 30%: polish visual e fidelidade ao DS v3.0
- Meta: site idêntico visualmente ao design_system/index.html

TAREFAS:

1. CONTRASTE WCAG 2.1 AA
   - Audite TODOS os textos sobre fundos coloridos
   - Verifique eyebrow text sobre section-alt e section-dark
   - Corrija se ratio < 4.5:1 para texto normal, < 3:1 para texto grande

2. FIDELIDADE VISUAL
   - Compare cada seção do site com design_system/index.html
   - Ajuste spacing, font-sizes, line-heights para match exato
   - Verifique que os gradientes são idênticos
   - Verifique que as shadows são idênticas

3. MICRO-INTERACTIONS
   - Confirme que hover effects nos cards funcionam (translateY + shadow + ::before)
   - Confirme que card-icons fazem scale + rotate no hover
   - Confirme que buttons têm ripple feedback
   - Confirme que navbar tem glassmorphism e transição scrolled

4. RESPONSIVIDADE
   - Teste em 320px, 375px, 768px, 1024px, 1440px
   - Sem scroll horizontal em nenhum breakpoint
   - Menu mobile funcional
   - Cards empilham corretamente
   - Touch targets ≥ 44px
   - Texto legível em todos os tamanhos

5. MOBILE PATTERNS (se aplicável)
   - Avalie se faz sentido adicionar bottom nav bar no mobile
   - Avalie FAB WhatsApp
   - Avalie horizontal scroll sections
   - NOTA: apenas se não atrasar o deploy

APÓS CORREÇÕES:
1. Rode `npm run build` — 0 erros
2. Registre check-in em .planning/CHECKIN-LOG.md
3. Crie handoff para CODEX-OPS: QA Audit Final
```

---

# PROMPT 3 — CODEX-OPS: QA Audit Final

```
Você é CODEX-OPS. 

CONTEXTO: DS v3.0 migrado (você 70%, GEMINI-UX 30%).
Agora execute o Quality Audit final antes do deploy.

TAREFAS COM SUB-AGENTES EM PARALELO:

## SUB-AGENTE A — LIGHTHOUSE
- `npm run build` no diretório site/
- `npx serve site/dist -l 4321`
- Lighthouse audit em TODAS as 9 páginas
- METAS: Performance ≥ 90, Accessibility ≥ 95, Best Practices ≥ 95, SEO ≥ 95
- Salve: site/docs/LIGHTHOUSE-REPORT.md

## SUB-AGENTE B — ACCESSIBILITY
- 1 <h1> por página, hierarquia sem pular
- Landmarks: main, nav, footer, header
- Alt text em todas as imagens
- Tab order lógico, focus visible
- aria attributes nos forms
- Salve: site/docs/ACCESSIBILITY-REPORT.md

## SUB-AGENTE C — SEO
- <title> único (< 60 chars) em cada página
- <meta description> único (< 160 chars) em cada página
- Open Graph tags
- Schema.org JSON-LD (LocalBusiness, FAQPage, BreadcrumbList)
- sitemap-index.xml e robots.txt
- Salve: site/docs/SEO-REPORT.md

## SUB-AGENTE D — BUNDLE CHECK
- Tamanho total do dist/
- Lazy-loading de imagens
- CSS/JS bundle sizes
- Dependências desnecessárias

APÓS AUDIT:
1. Compile QA-SUMMARY.md com TODOS os scores
2. Classifique issues: CRÍTICO / ALTO / MÉDIO / BAIXO
3. Se há issues CRÍTICOS ou ALTOS:
   - Corrija imediatamente (você mesmo ou handoff GEMINI-UX)
   - Re-audite após correções
4. Se TODAS as metas atingidas:
   - Marque como PASSED
   - Crie handoff para deploy
5. Registre check-in em .planning/CHECKIN-LOG.md
6. Pare o servidor local
```

---

# PROMPT 4 — CODEX-OPS: Deploy HostGator

```
Você é CODEX-OPS.

CONTEXTO: QA PASSED. Todas as metas atingidas. Deploy para produção.

PRÉ-REQUISITOS:
- Confirme que `npm run build` gera site/dist/ sem erros
- Confirme que todos os relatórios QA estão em site/docs/
- Confirme que o build é 100% estático (HTML/CSS/JS/imagens)

TAREFAS:

1. PREFLIGHT CHECK
   - Rode: npm run build
   - Verifique: 9 páginas HTML em dist/
   - Verifique: CSS/JS minificados
   - Verifique: Sem referências a localhost ou URLs de dev
   - Verifique: robots.txt e sitemap presentes

2. DEPLOY
   - Verifique se existem scripts de deploy em site/scripts/ ou raiz
   - Se existir hostgator-deploy.ps1 ou similar, use-o
   - Se NÃO existir, use rsync via SSH:
     ```
     rsync -avz --delete site/dist/ user@server:public_html/
     ```
   - NOTA: Credenciais SSH devem ser fornecidas pelo user
   - Se não tiver credenciais, documente exatamente o que precisa e PARE

3. PÓS-DEPLOY
   - Se possível, verifique que o site está acessível
   - Teste URLs das 9 páginas
   - Verifique HTTPS
   - Registre check-in FINAL em .planning/CHECKIN-LOG.md
   - Atualize ROADMAP.md: Fase 6 → COMPLETED

REGRAS:
- NUNCA faça deploy sem QA PASSED
- Se credenciais SSH não disponíveis, PARE e peça ao user
- Documente TUDO no check-in
```

---

# RESUMO DO WORKFLOW

```
┌─────────────────────────────────────────────────┐
│  PROMPT 1: CODEX-OPS — Migração DS v3.0 (70%)  │
│  5 sub-agentes paralelos                         │
│  Tokens + Fonts + Components + JS + Pages        │
└──────────────────────┬──────────────────────────┘
                       │ handoff
                       ▼
┌─────────────────────────────────────────────────┐
│  PROMPT 2: GEMINI-UX — Polish Visual (30%)      │
│  Contraste + Fidelidade + Micro-interactions     │
│  + Responsividade                                │
└──────────────────────┬──────────────────────────┘
                       │ handoff
                       ▼
┌─────────────────────────────────────────────────┐
│  PROMPT 3: CODEX-OPS — QA Audit Final           │
│  4 sub-agentes: Lighthouse + A11y + SEO + Bundle │
│  Fix críticos → Re-audit se necessário           │
└──────────────────────┬──────────────────────────┘
                       │ all PASSED
                       ▼
┌─────────────────────────────────────────────────┐
│  PROMPT 4: CODEX-OPS — Deploy HostGator         │
│  Preflight → rsync/SSH → Verificação → Done ✅   │
└─────────────────────────────────────────────────┘
```

**Tempo estimado**: ~2-3 horas total (execução sequencial dos 4 prompts)
**Envie os prompts 1 por 1, na ordem acima.**
