# Design System v3.0 — Colégio Villa Prime
## Referência Canônica para Migração

> **Status**: APROVADO pelo cliente  
> **Source**: `design_system/` (5 arquivos)  
> **Decisão**: D-007 — Este DS substitui o Deep Teal temporário

---

## 1. Mapeamento de Cores (ANTES → DEPOIS)

### Paleta Principal
| Token Atual (Deep Teal)       | Valor Atual | Token DS v3.0        | Valor DS v3.0 |
|-------------------------------|-------------|----------------------|---------------|
| `--color-primary-800`         | `#004254`   | `--vp-purple-deep`   | `#6C3483`     |
| `--color-primary-500`         | `#006d84`   | `--vp-purple`        | `#9B59B6`     |
| `--color-primary-200`         | `#80c0cd`   | `--vp-purple-light`  | `#D2B4DE`     |
| `--color-accent-400`          | `#f6c91f`   | `--vp-gold`          | `#FFD700`     |
| `--color-accent-500`          | `#d4a910`   | `--vp-gold-deep`     | `#DAA520`     |
| *(não existia)*               | —           | `--vp-green`         | `#7ED321`     |
| *(não existia)*               | —           | `--vp-magenta`       | `#FF0080`     |
| *(não existia)*               | —           | `--vp-orange`        | `#F5A623`     |
| *(não existia)*               | —           | `--vp-yellow`        | `#F8E71C`     |
| *(não existia)*               | —           | `--vp-cyan`          | `#50E3C2`     |

### Cores de Status (mantidas)
| Semântica | Valor (ambos) |
|-----------|---------------|
| Success   | `#10B981`     |
| Warning   | `#F59E0B`     |
| Error     | `#EF4444`     |
| Info      | `#3B82F6`     |

### Neutrals
| DS v3.0 Token     | Valor     | Equivalente Atual       |
|--------------------|-----------|------------------------|
| `--vp-gray-50`     | `#F9FAFB` | `--color-neutral-50`   |
| `--vp-gray-100`    | `#F3F4F6` | `--color-neutral-100`  |
| `--vp-gray-200`    | `#E5E7EB` | `--color-neutral-200`  |
| `--vp-gray-300`    | `#D1D5DB` | `--color-neutral-300`  |
| `--vp-gray-400`    | `#9CA3AF` | `--color-neutral-400`  |
| `--vp-gray-500`    | `#6B7280` | `--color-neutral-500`  |
| `--vp-gray-600`    | `#4B5563` | `--color-neutral-600`  |
| `--vp-gray-700`    | `#374151` | `--color-neutral-700`  |
| `--vp-gray-800`    | `#1F2937` | `--color-neutral-800`  |
| `--vp-gray-900`    | `#111827` | `--color-neutral-900`  |

---

## 2. Mapeamento de Tipografia

| Tipo     | Atual                   | DS v3.0                              |
|----------|-------------------------|--------------------------------------|
| Display  | Playfair Display (serif)| **Fredoka** (sans, rounded, playful) |
| Body     | Inter                   | Inter *(mantém)*                     |
| Mono     | JetBrains Mono          | JetBrains Mono *(mantém)*           |

### Google Fonts URL
```
https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700;800&display=swap
```

### Escala Tipográfica DS v3.0
| Uso       | Font           | Size                      | Weight |
|-----------|----------------|---------------------------|--------|
| Display   | Fredoka        | `clamp(42px, 7vw, 80px)` | 700    |
| H1        | Fredoka        | `clamp(28px, 4vw, 48px)` | 700    |
| H2        | Fredoka        | `clamp(24px, 3vw, 36px)` | 600    |
| H3        | Fredoka        | `20px`                    | 600    |
| Body      | Inter          | `16px`                    | 400    |
| Small     | Inter          | `14px`                    | 400    |
| Eyebrow   | Inter          | `13px` uppercase, 0.1em  | 600    |
| Caption   | Inter          | `12px`                    | 500    |

---

## 3. Gradientes Premium

| Nome    | Valor CSS                                                              | Uso           |
|---------|------------------------------------------------------------------------|---------------|
| Hero    | `linear-gradient(135deg, #6C3483 0%, #9B59B6 40%, #BB8FCE 100%)`      | Hero sections |
| Magic   | `linear-gradient(135deg, #FF0080 0%, #9B59B6 50%, #50E3C2 100%)`      | CTAs, buttons |
| Aurora  | `linear-gradient(135deg, #667EEA 0%, #764BA2 50%, #F093FB 100%)`      | Backgrounds   |
| Sunset  | `linear-gradient(135deg, #FA709A 0%, #FEE140 100%)`                   | Accents       |
| Ocean   | `linear-gradient(135deg, #50E3C2 0%, #3B82F6 100%)`                   | Info sections |
| Nature  | `linear-gradient(135deg, #7ED321 0%, #50E3C2 100%)`                   | Eco sections  |
| Glass   | `linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05))` | Overlays  |

---

## 4. Shadows & Glow

| Nome             | Valor                                       |
|------------------|---------------------------------------------|
| `shadow-sm`      | `0 1px 3px rgba(0,0,0,0.06)`              |
| `shadow-md`      | `0 4px 12px rgba(0,0,0,0.08)`             |
| `shadow-lg`      | `0 12px 32px rgba(0,0,0,0.12)`            |
| `shadow-xl`      | `0 24px 48px rgba(0,0,0,0.16)`            |
| `shadow-2xl`     | `0 32px 64px rgba(0,0,0,0.2)`             |
| `glow-purple`    | `0 0 60px rgba(155,89,182,0.3)`           |
| `glow-magenta`   | `0 0 60px rgba(255,0,128,0.2)`            |
| `glow-cyan`      | `0 0 60px rgba(80,227,194,0.2)`           |

---

## 5. Componentes Novos (DS v3.0)

### 5.1 Navbar Glassmorphism
- Fixed, z-index 9999
- `backdrop-filter: blur(24px) saturate(180%)`
- Borda inferior com `rgba(155,89,182,0.06)`
- Estado `.scrolled` com shadow

### 5.2 Hero com Canvas
- WebGL/Canvas 2D particle system (stars + floating orbs)
- Animated blobs com `morphBlob` keyframe
- Parallax com mouse tracking
- KPI counters animados (count-up)

### 5.3 Cards Premium
- Border-radius: 24px (`--r-xl`)
- `::before` pseudo com gradient bar animada no hover
- Card icons com scale + rotate no hover
- Glass variant para contextos dark

### 5.4 Badges
- 5 variantes: purple, green, gold, cyan, magenta
- Border-radius full (pill)
- Ícones inline com emoji

### 5.5 Testimonials
- Quote mark decorativa (`::before` content `\201C`)
- Avatar circular com gradient background
- Hover com translateY + shadow

### 5.6 Forms
- Input padding: 14px 18px
- Focus: `border-color: var(--vp-purple)` + box-shadow glow
- Grid 2-col com `.form-full` para full width

### 5.7 Mobile Patterns (villaprime-mobile.html)
- Bottom navigation bar (fixed)
- FAB (WhatsApp)
- Stories (horizontal scroll, Instagram-like rings)
- Quick actions grid (4-col)
- Horizontal scroll sections com `scroll-snap`

---

## 6. Animações & Keyframes

| Keyframe        | Uso                              |
|-----------------|----------------------------------|
| `fadeInUp`      | Scroll reveal padrão             |
| `fadeInDown`    | Hero chip entrada                |
| `fadeInScale`   | Cards entrance                   |
| `slideInLeft`   | Elementos laterais               |
| `slideInRight`  | Elementos laterais               |
| `float`         | Elementos decorativos            |
| `pulse`         | Atenção suave                    |
| `shimmer`       | Loading/skeleton                 |
| `morphBlob`     | Blobs do hero                    |
| `gradientShift` | Botão magic, hero accent         |
| `glowPulse`     | Cards premium hover              |
| `countUp`       | KPI counters                     |
| `ripple`        | Button click feedback            |

### Scroll-Driven Reveals
```css
[data-animate] → .in (via IntersectionObserver)
[data-animate="fade-scale"]
[data-animate="slide-left"]
[data-animate="slide-right"]
```

### Stagger
```css
.stagger > *:nth-child(N) { transition-delay: (N-1)*80ms }
```

---

## 7. Timing & Easing

| Token          | Valor                                    |
|----------------|------------------------------------------|
| `--t-instant`  | 100ms                                    |
| `--t-fast`     | 200ms                                    |
| `--t-normal`   | 300ms                                    |
| `--t-slow`     | 500ms                                    |
| `--t-emphasis` | 800ms                                    |
| `--t-dramatic` | 1200ms                                   |
| `--ease-out`   | `cubic-bezier(0.16, 1, 0.3, 1)`         |
| `--ease-spring`| `cubic-bezier(0.34, 1.56, 0.64, 1)`     |
| `--ease-smooth`| `cubic-bezier(0.4, 0, 0.2, 1)`          |
| `--ease-bounce`| `cubic-bezier(0.68, -0.55, 0.265, 1.55)`|

---

## 8. Responsive Breakpoints

| Breakpoint | Comportamento                                         |
|------------|-------------------------------------------------------|
| ≤1024px    | Grid 3/4 → 2 col, hero metrics 2 col, footer 2 col  |
| ≤768px     | Grids → 1 col, nav menu hidden, form single col       |
|            | Hero h1 clamped, hero padding reduced                  |
|            | Footer bottom stacked                                 |

---

## 9. Arquivos de Referência

| Arquivo                     | Tipo          | Conteúdo                                    |
|-----------------------------|---------------|---------------------------------------------|
| `design_system/styles.css`  | Tokens + CSS  | Design tokens completos + componentes       |
| `design_system/app.js`      | JS Engine     | Canvas particles, scroll reveals, counters  |
| `design_system/index.html`  | Demo Desktop  | Implementação referência desktop            |
| `design_system/design-system.html` | Showcase | Catálogo de componentes                     |
| `design_system/villaprime-mobile.html` | Demo Mobile | Padrões mobile (stories, FAB, bottom bar) |

---

## 10. Delta de Migração: Site Atual vs DS v3.0

### CRÍTICO (Visual Identity)
- [ ] Substituir Playfair Display por Fredoka em todos os headings
- [ ] Migrar paleta Deep Teal → Purple
- [ ] Substituir gradientes (hero, warm, primary → hero, magic, aurora)
- [ ] Atualizar theme-color meta de `#004254` → `#6C3483`
- [ ] Atualizar shadows de Deep Teal tint → neutral/purple tint

### ALTO (Componentes)
- [ ] Implementar navbar glassmorphism com backdrop-filter
- [ ] Adicionar hero canvas particle system (app.js)
- [ ] Migrar cards para premium style com `::before` gradient bar
- [ ] Implementar badges (5 variantes)
- [ ] Implementar KPI counters com count-up animation
- [ ] Implementar testimonials com quote marks decorativas

### MÉDIO (Interações)
- [ ] Adicionar `data-animate` scroll reveal system
- [ ] Implementar stagger delay em grids
- [ ] Adicionar glowPulse, morphBlob, gradientShift keyframes
- [ ] Adicionar timing tokens (--t-instant..--t-dramatic)
- [ ] Adicionar easing tokens (--ease-out, --ease-spring, etc.)

### BAIXO (Mobile Enhancements)
- [ ] Bottom navigation bar
- [ ] FAB WhatsApp
- [ ] Stories component (Instagram-like)
- [ ] Quick actions grid
- [ ] Horizontal scroll sections com scroll-snap
