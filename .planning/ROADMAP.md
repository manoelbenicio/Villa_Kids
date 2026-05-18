# Roadmap: Colégio Villa Prime — Website Institucional

**Created:** 2026-05-17
**Granularity:** Standard (8 phases)
**Core Value:** Converter visitantes em matrículas
**Orchestration:** Multi-Agent (see AGENT-CONTRACT.md)

---

## Phase Overview

| Phase | Name | Primary | Secondary | Reviewer | Status |
|-------|------|---------|-----------|----------|--------|
| Pre-0 | Discovery & Setup | OPUS-ARCH | — | — | ✅ DONE |
| 1 | Foundation | OPUS-ARCH | GEMINI-UX | CODEX-OPS | 🔄 OPUS✅ CODEX⏳ GEMINI⏳ |
| 2 | Components | GEMINI-UX | OPUS-ARCH | CODEX-OPS | 📋 PLANNED |
| 3 | Home Page | GEMINI-UX | OPUS-ARCH | CODEX-OPS | 📋 PLANNED |
| 4 | Internal Pages | OPUS-ARCH | GEMINI-UX | CODEX-OPS | 📋 PLANNED |
| 5 | Conversion Pages | OPUS-ARCH | GEMINI-UX | CODEX-OPS | 📋 PLANNED |
| 6 | Quality & QA | CODEX-OPS | GEMINI-UX | OPUS-ARCH | 📋 PLANNED |
| 7 | Deploy Pipeline | CODEX-OPS | OPUS-ARCH | GEMINI-UX | 📋 PLANNED |
| 8 | Documentation | OPUS-ARCH | CODEX-OPS | GEMINI-UX | 📋 PLANNED |

---

## Phase 1: Foundation — Scaffolding & Design System

**Owner:** OPUS-ARCH | **Support:** GEMINI-UX | **Review:** CODEX-OPS

**Goal:** Projeto Astro scaffolded, buildando, com design system configurado e layout base funcional.

**Requirements:** INFRA-01, INFRA-02, INFRA-03, INFRA-04, INFRA-05, INFRA-06, INFRA-07

**Deliverables:**
- Astro + TypeScript + Tailwind project scaffolded
- Design System tokens (cores, tipografia, espaçamento)
- Layout base com Header e Footer
- Navegação principal responsiva
- SEO base (sitemap, robots.txt, meta tags)
- Schema.org base configuration
- .htaccess para Apache/HostGator
- Git repo configurado com .gitignore

**Acceptance Criteria:**
- `npm run dev` funciona
- `npm run build` gera `/dist` sem erros
- Header e Footer renderizam em mobile e desktop
- Navegação funcional entre páginas

---

## Phase 2: Components — UI Component Library

**Owner:** GEMINI-UX | **Support:** OPUS-ARCH | **Review:** CODEX-OPS

**Goal:** Todos os componentes UI construídos, estilizados e responsivos.

**Requirements:** COMP-01..14

**Deliverables:**
- Header (sticky, transparência, menu mobile)
- Footer (contato, redes, links, copyright)
- Hero (background, título, CTA)
- SectionTitle, CTAButton, FeatureCard
- TrustBadge, FAQ (accordion)
- TestimonialCard, ContactForm
- WhatsAppFloatingButton
- SEOHead, SchemaOrg
- Gallery (grid + lightbox)

**Acceptance Criteria:**
- Todos os 14 componentes renderizam corretamente
- Responsivos em 320px, 768px, 1024px+
- Sem erros de console
- Acessibilidade básica (alt text, keyboard nav)

---

## Phase 3: Home Page — Landing Page Premium

**Owner:** GEMINI-UX | **Support:** OPUS-ARCH | **Review:** CODEX-OPS

**Goal:** Página Home completa, premium, com todas as seções e conversão.

**Requirements:** PAGE-01

**Deliverables:**
- Hero com imagem/vídeo + CTA matrícula
- Seção "Sobre a Escola"
- Pilares Pedagógicos (grid 2x2)
- Nossos Ambientes (cards)
- Galeria de Fotos
- Depoimentos (carousel)
- FAQ preview
- CTA final + contato rápido

**Acceptance Criteria:**
- Página carrega em < 3s
- CTA WhatsApp funciona
- Todas as seções visíveis e responsivas
- Visual premium (não genérico)

---

## Phase 4: Internal Pages — Institucional

**Owner:** OPUS-ARCH | **Support:** GEMINI-UX | **Review:** CODEX-OPS

**Goal:** 5 páginas institucionais completas com conteúdo.

**Requirements:** PAGE-02, PAGE-03, PAGE-04, PAGE-05, PAGE-06

**Deliverables:**
- Proposta Pedagógica
- Turmas (Berçário, Maternal, Infantil)
- Estrutura Física
- Tecnologia
- Segurança

**Acceptance Criteria:**
- Cada página tem conteúdo relevante
- Navegação entre páginas funcional
- SEO meta tags em cada página
- Responsivo em todos os breakpoints

---

## Phase 5: Conversion Pages — Matrícula, Contato, LGPD

**Owner:** OPUS-ARCH | **Support:** GEMINI-UX | **Review:** CODEX-OPS

**Goal:** Páginas de conversão e compliance funcionais.

**Requirements:** PAGE-07, PAGE-08, PAGE-09

**Deliverables:**
- Matrículas (CTA forte, steps, WhatsApp)
- Contato (form, mapa, endereço, telefone)
- Política de Privacidade (LGPD)

**Acceptance Criteria:**
- Formulário de contato funciona (validação client-side)
- WhatsApp CTA abre corretamente
- Política de privacidade completa
- Formulário tem progressive enhancement

---

## Phase 6: Quality — Lighthouse, Acessibilidade, SEO

**Owner:** CODEX-OPS | **Support:** GEMINI-UX | **Review:** OPUS-ARCH

**Goal:** Todas as métricas de qualidade atingidas.

**Requirements:** QUAL-01..10

**Deliverables:**
- Otimização de performance (imagens, CSS, JS)
- Audit de acessibilidade
- SEO audit completo
- Testes de responsividade
- Lazy-loading verificado
- Contraste WCAG verificado

**Acceptance Criteria:**
- Lighthouse Performance ≥ 90
- Lighthouse Accessibility ≥ 95
- Lighthouse Best Practices ≥ 95
- Lighthouse SEO ≥ 95
- Zero violações críticas de acessibilidade

---

## Phase 7: DevOps — Deploy Pipeline para HostGator

**Owner:** CODEX-OPS | **Support:** OPUS-ARCH | **Review:** GEMINI-UX

**Goal:** Pipeline completo de deploy com backup, rollback e validação.

**Requirements:** DEVOPS-01..08

**Deliverables:**
- hostgator-preflight.ps1 / .sh
- hostgator-backup.ps1 / .sh
- hostgator-deploy.ps1 / .sh
- hostgator-rollback.ps1 / .sh
- hostgator-validate.ps1 / .sh
- .env.deploy.example
- .cpanel.yml.example
- Relatórios automatizados

**Acceptance Criteria:**
- Preflight roda sem erro (com SSH configurado)
- Deploy dry-run funciona
- Backup cria tar.gz no servidor
- Rollback restaura backup corretamente
- Nenhuma credencial no repositório

---

## Phase 8: Documentation — Documentação Completa

**Owner:** OPUS-ARCH | **Support:** CODEX-OPS | **Review:** GEMINI-UX

**Goal:** Toda a documentação técnica e operacional entregue.

**Requirements:** DOCS-01..13

**Deliverables:**
- 11 documentos no `/docs`
- 3+ ADRs
- 5 diagramas Mermaid
- README.md atualizado

**Acceptance Criteria:**
- Todos os 13 entregáveis de documentação criados
- Diagramas Mermaid renderizam corretamente
- README com instruções de install/dev/build/deploy
- Nenhuma credencial na documentação

---

*Roadmap created: 2026-05-17*
*Last updated: 2026-05-17 — Added multi-agent ownership matrix*
