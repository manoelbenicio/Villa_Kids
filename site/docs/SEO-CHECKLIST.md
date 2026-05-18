<!--
  @file SEO-CHECKLIST.md
  @description Page-by-page SEO checklist based on the architecture blueprint.
  @author CODEX-OPS
  @phase 8
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
-->

# SEO Checklist

Base: `.planning/ARCHITECTURE-BLUEPRINT.md` Section 3 e `SEOHead.astro`.

## Critérios por Página

- Title único com 50-60 caracteres.
- Meta description única com 120-160 caracteres.
- H1 único e alinhado à intenção da página.
- Canonical self-referencing.
- Open Graph: `og:title`, `og:description`, `og:image`, `og:url`, `og:type`.
- Schema.org apropriado: organização global, `WebPage` por página, FAQ quando houver FAQ.
- `og:image` 1200x630 real antes do launch.

## Status Atual

| Página | URL | Title | Description | H1 | Canonical/OG | Schema.org | og:image | Status |
|---|---|---|---|---|---|---|---|---|
| Home | `/` | Implementado via `SEOHead` | Implementada via `schoolInfo.shortDescription` | Implementado no `Hero` | Implementado via `SEOHead` | Organização + FAQ na home | Placeholder `/og-image.jpg` | Parcial |
| Proposta Pedagógica | `/proposta-pedagogica/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` | Pendente | Placeholder |
| Turmas | `/turmas/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` | Pendente | Placeholder |
| Estrutura | `/estrutura/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` | Pendente | Placeholder |
| Tecnologia | `/tecnologia/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` | Pendente | Placeholder |
| Segurança | `/seguranca/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` | Pendente | Placeholder |
| Matrículas | `/matriculas/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` | Pendente | Placeholder |
| Contato | `/contato/` | Pendente | Pendente | Pendente | Depende da montagem da página | Pendente `WebPage` + LocalBusiness | Pendente | Placeholder |
| Política de Privacidade | `/politica-de-privacidade/` | Pendente | Pendente | Pendente | Noindex a avaliar | Pendente `WebPage` | Pendente | Placeholder |

## Antes do Launch

- Criar `site/public/og-image.jpg`.
- Validar `dist/sitemap-index.xml`.
- Validar `robots.txt`.
- Rodar crawl local ou produção e confirmar ausência de title/description duplicados.
- Testar rich results quando Schema.org final estiver aplicado.
