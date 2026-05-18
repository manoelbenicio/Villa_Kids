# FASE 1 — Prompts para GEMINI-UX

> Cole cada prompt na IDE do GEMINI-UX.

---

## Task 1.8-1.11 — Revisar Design System

```
Você é GEMINI-UX, o agente de UI/UX do projeto Colégio Villa Prime.

PRIMEIRO: Leia `.planning/AGENT-ONBOARDING.md` e `.planning/AGENT-CONTRACT.md`.

CONTEXTO: Projeto PREMIUM nível Fortune 500. Deve esbanjar tecnologia disruptiva e efeitos visuais de tirar o fôlego. O OPUS-ARCH criou o Design System em `site/src/styles/global.css` e as ADRs em `.planning/ADRs.md` (ADR-002).

SUA MISSÃO — Revisar e finalizar o Design System:

1. REVISAR `site/src/styles/global.css`:
   - Validar que TODOS os tokens estão corretos e completos
   - Verificar contraste WCAG 2.1 AA para TODAS as combinações:
     * Texto primary-800 (#004254) sobre surface (#ffffff) → deve ser ≥ 4.5:1
     * Texto branco sobre primary-800 → deve ser ≥ 4.5:1
     * Texto accent-500 (#d4a910) sobre surface → verificar
     * Texto sobre surface-muted → verificar
   - Se algum contraste falhar, ajuste o token mantendo a identidade Deep Teal

2. CONFIGURAR Google Fonts (Inter + Playfair Display):
   - Adicionar preconnect e link tags otimizados para performance
   - Font-display: swap para evitar FOIT
   - Weights: Inter 400,500,600,700 | Playfair Display 700

3. DOCUMENTAR breakpoints responsivos:
   - Mobile: < 640px
   - Tablet: 640px-1024px
   - Desktop: > 1024px
   - Verificar que global.css tem media queries adequados

4. ADICIONAR tokens PREMIUM que faltam (se necessário):
   - Mais animações sofisticadas (parallax, morphing, scroll-triggered)
   - Glassmorphism refinado
   - Gradient overlays premium
   - Micro-interações (hover states elaborados)

Este é um site Fortune 500 — o design deve ser IMPECÁVEL e IMPRESSIONANTE à primeira vista.

AO TERMINAR: Registre check-in em `.planning/CHECKIN-LOG.md`.
```
