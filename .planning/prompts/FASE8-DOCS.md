# FASE 8 — Prompts (Documentation — RESTANTE)

> ⚠️ 6 docs foram antecipados para `FASE7+8-CODEX-OPS-PARALELO.md`.
> Este arquivo contém APENAS os docs que dependem de fases posteriores.

---

## Docs já antecipados (NÃO ACIONAR — já em paralelo)

| Doc | Movido para | Agente |
|-----|------------|--------|
| DEPLOY-GUIDE.md | FASE7+8-CODEX-OPS-PARALELO.md | CODEX-OPS |
| BACKUP-STRATEGY.md | FASE7+8-CODEX-OPS-PARALELO.md | CODEX-OPS |
| TROUBLESHOOTING.md | FASE7+8-CODEX-OPS-PARALELO.md | CODEX-OPS |
| SECURITY-HEADERS.md | FASE7+8-CODEX-OPS-PARALELO.md | CODEX-OPS |
| SEO-CHECKLIST.md | FASE7+8-CODEX-OPS-PARALELO.md | CODEX-OPS |
| CONTENT-GUIDE.md | FASE7+8-CODEX-OPS-PARALELO.md | CODEX-OPS |

---

## Task 8.A — GEMINI-UX: Docs de Design (após Fase 2 concluída)

```
Você é GEMINI-UX. Após concluir a Fase 2, crie a documentação visual:

1. site/docs/DESIGN-SYSTEM.md:
   - Paleta de cores com hex codes e uso recomendado
   - Tipografia (Inter, Playfair Display) com escala
   - Espaçamento, border-radius, shadows
   - Gradients e glass effects
   - Animações disponíveis (fadeIn, slideUp, etc.)
   - Breakpoints responsivos
   - Inclua diagrama Mermaid da hierarquia de tokens

2. site/docs/COMPONENT-CATALOG.md:
   - Lista de todos os 15 componentes criados
   - Props de cada um com tipos TypeScript
   - Exemplo de uso em código Astro
   - Variantes disponíveis
   - Screenshots ou descrição visual

Registre check-in em .planning/CHECKIN-LOG.md.
```

---

## Task 8.B — CODEX-OPS: Reports (após Fase 6 QA concluída)

```
Você é CODEX-OPS. Após a Fase 6 (QA), crie:

1. site/docs/PERFORMANCE-REPORT.md:
   - Scores Lighthouse finais de TODAS as páginas
   - Performance, Accessibility, Best Practices, SEO
   - Tabela comparativa
   - Recomendações pendentes (se houver)

2. site/docs/ACCESSIBILITY-REPORT.md:
   - Compliance WCAG 2.1 AA
   - Contraste de cores validado
   - Navegação por teclado
   - Screen reader compatibility
   - Issues encontrados e resolvidos

Registre check-in em .planning/CHECKIN-LOG.md.
```

---

## Task 8.C — OPUS-ARCH: README final + Validação (ÚLTIMA task do projeto)

```
Valide que TODOS os docs existem e crie:

1. README.md na raiz do projeto com:
   - Visão geral do projeto (Colégio Villa Prime)
   - Stack: Astro + TypeScript + Tailwind CSS v4
   - Como instalar: npm install → npm run dev → npm run build
   - Estrutura de diretórios resumida (tree)
   - Como fazer deploy (link para docs/DEPLOY-GUIDE.md)
   - Links para todos os docs/
   - Créditos dos agentes (OPUS-ARCH, CODEX-OPS, GEMINI-UX)

2. Verificar que existem ≥ 5 diagramas Mermaid nos docs.

3. Registre check-in FINAL em .planning/CHECKIN-LOG.md marcando projeto como ENTREGUE.
```
