# Requirements: Colégio Villa Prime — Website Institucional

**Defined:** 2026-05-17
**Core Value:** Converter visitantes em matrículas através de experiência digital premium que transmita segurança, acolhimento e excelência pedagógica

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Infraestrutura & Projeto (INFRA)

- [ ] **INFRA-01**: Projeto Astro + TypeScript + Tailwind scaffolded e buildando localmente
- [ ] **INFRA-02**: Design System com tokens de cor, tipografia, espaçamento e componentes
- [ ] **INFRA-03**: Layout base responsivo mobile-first com Header, Footer, navegação
- [ ] **INFRA-04**: Configuração de SEO base (sitemap, robots.txt, meta tags, Open Graph)
- [ ] **INFRA-05**: Schema.org structured data (LocalBusiness, EducationalOrganization)
- [ ] **INFRA-06**: .htaccess com segurança, cache e compressão para Apache/HostGator
- [ ] **INFRA-07**: Git repository inicializado com .gitignore adequado

### Páginas — Conteúdo Institucional (PAGE)

- [ ] **PAGE-01**: Home — Hero premium com vídeo/imagem, CTA matrícula, pilares, ambientes, galeria, depoimentos, FAQ, contato
- [ ] **PAGE-02**: Proposta Pedagógica — Educação infantil 0-6, desenvolvimento integral, rotina, acolhimento, socioemocional
- [ ] **PAGE-03**: Turmas — Berçário, maternal, infantil com faixas etárias, rotina, expectativas dos pais
- [ ] **PAGE-04**: Estrutura — Segurança, salas, playground, higiene, acessibilidade, imagens
- [ ] **PAGE-05**: Tecnologia — App para pais, comunicação digital, segurança e transparência
- [ ] **PAGE-06**: Segurança — Acesso controlado, comunicação, saúde, emergência, LGPD
- [ ] **PAGE-07**: Matrículas — Página de conversão, agendamento de visita, documentos, WhatsApp CTA
- [ ] **PAGE-08**: Contato — Endereço, telefone, WhatsApp, email, mapa, formulário
- [ ] **PAGE-09**: Política de Privacidade — Estrutura LGPD, sem overclaiming jurídico

### Componentes UI (COMP)

- [ ] **COMP-01**: Header responsivo com navegação, logo, CTA e menu mobile (hamburger)
- [ ] **COMP-02**: Footer com contato, redes sociais, links rápidos, copyright
- [ ] **COMP-03**: Hero section com background image/video, título, subtítulo, CTA
- [ ] **COMP-04**: SectionTitle — Títulos de seção padronizados com subtítulo e decoração
- [ ] **COMP-05**: CTAButton — Botão de call-to-action com variantes (primary, secondary, WhatsApp)
- [ ] **COMP-06**: FeatureCard — Card para pilares, diferenciais, ambientes
- [ ] **COMP-07**: TrustBadge — Indicadores de confiança (certificações, anos de experiência)
- [ ] **COMP-08**: FAQ — Accordion com perguntas frequentes
- [ ] **COMP-09**: TestimonialCard — Card de depoimento com foto, nome, texto
- [ ] **COMP-10**: ContactForm — Formulário de contato com validação client-side
- [ ] **COMP-11**: WhatsAppFloatingButton — Botão flutuante WhatsApp (canto inferior direito)
- [ ] **COMP-12**: SEOHead — Componente de meta tags, Open Graph, Twitter Card
- [ ] **COMP-13**: SchemaOrg — JSON-LD structured data component
- [ ] **COMP-14**: Gallery — Grid de imagens com lightbox/modal

### Qualidade & Acessibilidade (QUAL)

- [ ] **QUAL-01**: Lighthouse Performance ≥ 90
- [ ] **QUAL-02**: Lighthouse Accessibility ≥ 95
- [ ] **QUAL-03**: Lighthouse Best Practices ≥ 95
- [ ] **QUAL-04**: Lighthouse SEO ≥ 95
- [ ] **QUAL-05**: HTML semântico em todas as páginas (h1 único, landmarks, alt texts)
- [ ] **QUAL-06**: Responsivo em mobile (320px), tablet (768px), desktop (1024px+)
- [ ] **QUAL-07**: Navegação por teclado funcional
- [ ] **QUAL-08**: Contraste WCAG 2.1 AA em todos os textos
- [ ] **QUAL-09**: Lazy-loading de imagens
- [ ] **QUAL-10**: Sem dependências pesadas desnecessárias

### Deploy & DevOps (DEVOPS)

- [ ] **DEVOPS-01**: Script preflight (SSH connectivity, remote path validation, env check)
- [ ] **DEVOPS-02**: Script backup (tar do webroot remoto antes de cada deploy)
- [ ] **DEVOPS-03**: Script deploy (build local → rsync SSH → staged release → sync to webroot)
- [ ] **DEVOPS-04**: Script rollback (restaurar backup tar.gz no webroot)
- [ ] **DEVOPS-05**: Script validate (curl health check, file verification pós-deploy)
- [ ] **DEVOPS-06**: .env.deploy.example com variáveis documentadas
- [ ] **DEVOPS-07**: .cpanel.yml.example para deploy alternativo via cPanel Git
- [ ] **DEVOPS-08**: Relatórios automatizados (preflight, QA, deploy, rollback)

### Documentação (DOCS)

- [ ] **DOCS-01**: 00_GSD_EXECUTION_PLAN.md — Plano de execução
- [ ] **DOCS-02**: 01_PRD_PRODUCT_REQUIREMENTS.md — Requisitos de produto
- [ ] **DOCS-03**: 02_UX_UI_DESIGN_SYSTEM.md — Design system completo
- [ ] **DOCS-04**: 03_INFORMATION_ARCHITECTURE.md — Arquitetura de informação
- [ ] **DOCS-05**: 04_TECHNICAL_ARCHITECTURE.md — Arquitetura técnica
- [ ] **DOCS-06**: 05_DEPLOYMENT_ARCHITECTURE_HOSTGATOR_CPANEL.md — Deploy
- [ ] **DOCS-07**: 06_SECURITY_LGPD_ACCESSIBILITY.md — Segurança
- [ ] **DOCS-08**: 07_SEO_PERFORMANCE_STRATEGY.md — SEO e performance
- [ ] **DOCS-09**: 08_QA_TEST_PLAN.md — Plano de testes
- [ ] **DOCS-10**: 09_OPERATIONS_RUNBOOK.md — Runbook operacional
- [ ] **DOCS-11**: 10_ROLLBACK_AND_INCIDENT_RUNBOOK.md — Rollback e incidentes
- [ ] **DOCS-12**: ADRs (Architecture Decision Records) — 3 mínimos
- [ ] **DOCS-13**: Diagramas Mermaid (context, container, deployment, content, release)

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Blog & Conteúdo Dinâmico

- **BLOG-01**: Sistema de blog integrado ao site
- **BLOG-02**: Categorias de conteúdo (dicas para pais, eventos, notícias)
- **BLOG-03**: RSS feed para conteúdo

### Área do Aluno/Pais

- **AREA-01**: Login para pais com acesso a informações do filho
- **AREA-02**: Agenda digital com rotina diária
- **AREA-03**: Galeria de fotos privada por turma
- **AREA-04**: Comunicados e avisos personalizados

### Integrações

- **INTG-01**: Google Analytics 4 completo
- **INTG-02**: Google Tag Manager
- **INTG-03**: Facebook Pixel
- **INTG-04**: Chatbot/atendimento automatizado
- **INTG-05**: Integração com sistema escolar/ERP

### Multilingual

- **I18N-01**: Versão em inglês do site
- **I18N-02**: Versão em espanhol do site

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| CMS/Admin panel | Static-first; conteúdo via código para v1 |
| Matrícula online com pagamento | Conversão via WhatsApp/telefone por enquanto |
| Chat ao vivo/chatbot | WhatsApp é suficiente para v1 |
| App mobile nativo | Website responsivo atende |
| E-commerce/loja | Não aplicável para escola |
| Backend/API complexo | Static site não requer |
| Database/MySQL | Desnecessário para v1 estático |
| Email marketing automation | Fora do escopo do website |
| Vídeo streaming próprio | Usar embeds de YouTube/Vimeo |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| INFRA-01..07 | Phase 1 | Pending |
| COMP-01..14 | Phase 2 | Pending |
| PAGE-01 | Phase 3 | Pending |
| PAGE-02..06 | Phase 4 | Pending |
| PAGE-07..09 | Phase 5 | Pending |
| QUAL-01..10 | Phase 6 | Pending |
| DEVOPS-01..08 | Phase 7 | Pending |
| DOCS-01..13 | Phase 8 | Pending |

**Coverage:**
- v1 requirements: 54 total
- Mapped to phases: 54
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-17*
*Last updated: 2026-05-17 after initial definition*
