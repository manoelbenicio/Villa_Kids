# FASE 6 — Prompts (Quality & QA)

---

## Task 6.1-6.8 — CODEX-OPS: Audit completo

```
Você é CODEX-OPS. Use 4 sub-agentes em paralelo para auditar TODAS as 9 páginas.

CONTEXTO: Projeto PREMIUM Fortune 500. Todas as páginas estão prontas. Agora QA rigoroso.

SUB-AGENTE 1 — LIGHTHOUSE PERFORMANCE + BEST PRACTICES:
- Rodar Lighthouse em TODAS as 9 páginas
- Meta: Performance ≥ 90, Best Practices ≥ 90
- Reportar cada página com score
- Otimizar imagens para WebP/AVIF se necessário
- Verificar lazy loading em todas as imagens abaixo do fold

SUB-AGENTE 2 — LIGHTHOUSE ACCESSIBILITY + SEO:
- Meta: Accessibility ≥ 90, SEO ≥ 95
- Verificar: alt texts, aria labels, heading hierarchy, color contrast
- Verificar: meta descriptions únicos, canonical URLs, og tags, schema.org

SUB-AGENTE 3 — CROSS-BROWSER:
- Testar em: Chrome, Firefox, Edge (mínimo)
- Verificar: layout, animações, fontes, glass effects
- Testar mobile (375px), tablet (768px), desktop (1280px, 1920px)

SUB-AGENTE 4 — VALIDAÇÃO HTML + LINKS:
- W3C HTML Validator — 0 errors permitidos
- Verificar TODOS os links internos funcionam
- Verificar links externos abrem em nova aba
- Verificar 404 page existe

GERAR RELATÓRIO: Criar site/docs/PERFORMANCE-REPORT.md e site/docs/ACCESSIBILITY-REPORT.md com todos os scores e issues.

Registre check-in em .planning/CHECKIN-LOG.md.
```

---

## Task 6.9 — GEMINI-UX: Fix de issues

```
Você é GEMINI-UX. CODEX-OPS gerou relatórios de QA em site/docs/PERFORMANCE-REPORT.md e site/docs/ACCESSIBILITY-REPORT.md.

MISSÃO: Leia os relatórios e corrija TODOS os issues encontrados:
- Contrast failures → ajustar cores mantendo Design System
- Missing alt texts → adicionar descrições semânticas
- Heading hierarchy → corrigir h1/h2/h3 order
- Performance issues → otimizar CSS, remover unused, lazy load
- Layout bugs → corrigir responsividade

Registre check-in em .planning/CHECKIN-LOG.md.
```
