# 📐 Phase Specifications — Multi-Agent Execution Plan

**Purpose:** Detailed specs per phase with agent ownership, acceptance criteria, and handoff points.
**Contract:** All agents must follow `AGENT-CONTRACT.md`.
**Logging:** All work must be logged in `CHECKIN-LOG.md`.

---

## Phase 1: Foundation — Scaffolding & Design System

### Owner: OPUS-ARCH | Support: GEMINI-UX | Review: CODEX-OPS

**Objective:** Astro project scaffolded, building locally, with design system and base layout.

### Tasks by Agent

#### OPUS-ARCH Tasks:
1. `npx create-astro` with TypeScript strict
2. Install and configure Tailwind CSS
3. Configure `astro.config.mjs` (static output, sitemap, prefetch)
4. Create `tailwind.config.mjs` with design tokens
5. Create base layout (`src/layouts/BaseLayout.astro`)
6. Create Header component skeleton (`src/components/Header.astro`)
7. Create Footer component skeleton (`src/components/Footer.astro`)
8. Configure SEO base (robots.txt, sitemap integration)
9. Create Schema.org base component
10. Setup `.htaccess` template for Apache
11. Create page shells: `index.astro`, `proposta-pedagogica.astro`, etc.

#### GEMINI-UX Tasks:
1. Define final color palette with all shades (Tailwind format)
2. Select and configure Google Fonts (Inter + accent font)
3. Create `src/styles/global.css` with CSS custom properties
4. Design token documentation (spacing, shadows, borders)
5. Create responsive breakpoint strategy document

#### CODEX-OPS Tasks (Review):
1. Verify `npm run build` produces clean static output
2. Verify `.htaccess` security headers
3. Review `package.json` for unnecessary dependencies
4. Confirm no server-side runtime required

### Acceptance Criteria:
- [ ] `npm run dev` starts without errors
- [ ] `npm run build` generates `/dist` with static HTML
- [ ] Header renders on desktop and mobile
- [ ] Footer renders with correct content
- [ ] Navigation links work between pages
- [ ] Tailwind classes resolve correctly
- [ ] Google Fonts load
- [ ] No console errors

### Handoff: OPUS-ARCH → GEMINI-UX for Phase 2 component styling

---

## Phase 2: Components — UI Component Library

### Owner: GEMINI-UX | Support: OPUS-ARCH | Review: CODEX-OPS

**Objective:** All 14 UI components built, styled, responsive, accessible.

### Tasks by Agent

#### GEMINI-UX Tasks (Primary):
1. Style Header with sticky behavior, transparency on scroll, hamburger menu
2. Style Footer with multi-column layout, social icons, newsletter
3. Build Hero component with parallax/gradient background, animated CTA
4. Create SectionTitle with decorative elements and animation
5. Build CTAButton variants (primary, secondary, WhatsApp green)
6. Create FeatureCard with hover effects and icon slots
7. Build TrustBadge component
8. Create FAQ accordion with smooth animations
9. Build TestimonialCard with avatar and quote styling
10. Create Gallery with grid layout and lightbox modal
11. Style WhatsAppFloatingButton with pulse animation
12. Implement micro-interactions and transitions

#### OPUS-ARCH Tasks (Structure):
1. Define component props/interfaces (TypeScript)
2. Create SEOHead component (meta, OG, Twitter)
3. Create SchemaOrg JSON-LD component
4. Create ContactForm with client-side validation logic
5. Review component composition patterns
6. Ensure semantic HTML in all components

#### CODEX-OPS Tasks (Review):
1. Test responsiveness at 320px, 768px, 1024px, 1440px
2. Keyboard navigation test on all interactive components
3. Screen reader compatibility check
4. Performance impact assessment (bundle size)

### Acceptance Criteria:
- [ ] All 14 components render without errors
- [ ] Responsive at all breakpoints
- [ ] Keyboard navigable
- [ ] WCAG 2.1 AA contrast ratios
- [ ] No unused CSS/JS
- [ ] Smooth animations (60fps)

### Handoff: GEMINI-UX → OPUS-ARCH for Phase 3 page assembly

---

## Phase 3: Home Page — Landing Page Premium

### Owner: GEMINI-UX | Support: OPUS-ARCH | Review: CODEX-OPS

**Objective:** Home page complete, premium visual quality, conversion-optimized.

### Tasks by Agent

#### GEMINI-UX Tasks (Primary):
1. Assemble Hero section with high-impact visual
2. Generate hero image(s) using AI image generation
3. Style "Sobre a Escola" section with split layout
4. Create pillar cards grid (2×2 or 3-column)
5. Design ambient showcase section
6. Build photo gallery section
7. Create testimonial carousel/grid
8. Style FAQ preview section
9. Design final CTA section with gradient background
10. Add scroll-triggered animations (IntersectionObserver)

#### OPUS-ARCH Tasks (Content & Structure):
1. Write/organize content for each section (PT-BR)
2. Implement section layout and order
3. Configure SEO meta for home page
4. Add Schema.org LocalBusiness + EducationalOrganization
5. Optimize heading hierarchy (single H1)

#### CODEX-OPS Tasks (QA):
1. Lighthouse audit of home page
2. Mobile usability test
3. Image optimization check (WebP, sizing)
4. Load time measurement

### Acceptance Criteria:
- [ ] Page loads < 3s on 4G
- [ ] Lighthouse Performance ≥ 85 (home is heaviest page)
- [ ] All CTAs functional (WhatsApp, navigation)
- [ ] Visual quality is "premium" — not generic
- [ ] All images have alt text
- [ ] No layout shift (CLS < 0.1)

### Handoff: OPUS-ARCH → OPUS-ARCH (continues) for Phase 4

---

## Phase 4: Internal Pages — Institutional Content

### Owner: OPUS-ARCH | Support: GEMINI-UX | Review: CODEX-OPS

**Objective:** 5 institutional pages with content, SEO, and consistent design.

### Tasks by Agent

#### OPUS-ARCH Tasks (Primary):
1. Create Proposta Pedagógica page content and structure
2. Create Turmas page with age group sections
3. Create Estrutura page with facility descriptions
4. Create Tecnologia page with app/digital features
5. Create Segurança page with safety protocols
6. SEO optimization for each page
7. Internal linking between pages
8. Breadcrumb navigation

#### GEMINI-UX Tasks:
1. Generate section images for each page
2. Style page-specific sections
3. Ensure visual consistency with home page
4. Add page-specific micro-interactions

#### CODEX-OPS Tasks (QA):
1. SEO audit per page (meta, headings, alt text)
2. Responsive check per page
3. Cross-page navigation test
4. Content rendering verification

### Acceptance Criteria:
- [ ] All 5 pages render correctly
- [ ] Each page has unique meta description
- [ ] Internal links work
- [ ] Consistent design across pages
- [ ] Lighthouse SEO ≥ 95 per page

### Handoff: OPUS-ARCH → OPUS-ARCH for Phase 5

---

## Phase 5: Conversion Pages — Matrícula, Contato, LGPD

### Owner: OPUS-ARCH | Support: GEMINI-UX | Review: CODEX-OPS

**Objective:** Conversion-focused pages with functional forms and compliance.

### Tasks by Agent

#### OPUS-ARCH Tasks:
1. Build Matrículas page (CTA, steps, requirements)
2. Build Contato page (form, map embed, contact info)
3. Build Política de Privacidade (LGPD content)
4. ContactForm validation logic
5. Progressive enhancement for form

#### GEMINI-UX Tasks:
1. Style conversion CTAs for maximum impact
2. Design form UI with clear visual hierarchy
3. Map embed styling
4. Success/error state styling

#### CODEX-OPS Tasks:
1. Form submission testing (validation)
2. Privacy page content review (LGPD compliance)
3. WhatsApp link testing across devices
4. Accessibility audit of form

### Acceptance Criteria:
- [ ] Contact form validates correctly
- [ ] WhatsApp CTA opens on mobile and desktop
- [ ] Map renders correctly
- [ ] Privacy page covers LGPD basics
- [ ] Form is keyboard navigable

### Handoff: All agents → CODEX-OPS for Phase 6

---

## Phase 6: Quality — Lighthouse, Accessibility, SEO

### Owner: CODEX-OPS | Support: GEMINI-UX | Review: OPUS-ARCH

**Objective:** All quality metrics achieved across all pages.

### Tasks by Agent

#### CODEX-OPS Tasks (Primary):
1. Full Lighthouse audit (all pages)
2. Accessibility audit (axe-core or similar)
3. SEO audit (meta, schema, sitemap)
4. Performance optimization (images, CSS, JS)
5. WCAG 2.1 AA compliance check
6. Keyboard navigation audit
7. Screen reader testing
8. Cross-browser verification
9. Mobile usability verification

#### GEMINI-UX Tasks:
1. Fix visual issues found in audits
2. Optimize images (WebP conversion, lazy loading)
3. Fix contrast issues
4. Reduce CSS bundle size

#### OPUS-ARCH Tasks (Review):
1. Review all fixes for architectural consistency
2. Verify SEO implementation
3. Final content review

### Acceptance Criteria:
- [ ] Lighthouse Performance ≥ 90 (all pages)
- [ ] Lighthouse Accessibility ≥ 95 (all pages)
- [ ] Lighthouse Best Practices ≥ 95 (all pages)
- [ ] Lighthouse SEO ≥ 95 (all pages)
- [ ] Zero critical accessibility violations
- [ ] All images lazy-loaded
- [ ] WCAG 2.1 AA compliant

### Handoff: CODEX-OPS continues into Phase 7

---

## Phase 7: DevOps — Deploy Pipeline

### Owner: CODEX-OPS | Support: OPUS-ARCH | Review: GEMINI-UX

**Objective:** Complete deploy pipeline with backup, rollback, and validation.

### Tasks by Agent

#### CODEX-OPS Tasks (Primary):
1. Create hostgator-preflight.ps1 (SSH test, env check)
2. Create hostgator-backup.ps1 (remote tar.gz)
3. Create hostgator-deploy.ps1 (build → rsync → sync)
4. Create hostgator-rollback.ps1 (restore backup)
5. Create hostgator-validate.ps1 (curl health check)
6. Create .env.deploy.example
7. Create .cpanel.yml.example
8. Test full deploy cycle (dry-run)
9. Document deploy procedures

#### OPUS-ARCH Tasks:
1. Review .htaccess final configuration
2. Verify build output is clean static
3. Create deploy documentation structure

#### GEMINI-UX Tasks (Review):
1. Verify deployed site matches dev preview
2. Visual regression check

### Acceptance Criteria:
- [ ] Preflight passes with valid SSH key
- [ ] Backup creates tar.gz on remote
- [ ] Deploy transfers files correctly (dry-run)
- [ ] Rollback restores previous version
- [ ] Validate confirms site is live
- [ ] No credentials in repository
- [ ] All scripts documented

### Handoff: All agents → OPUS-ARCH for Phase 8

---

## Phase 8: Documentation — Complete Documentation

### Owner: OPUS-ARCH | Support: CODEX-OPS | Review: GEMINI-UX

**Objective:** All documentation complete and accurate.

### Tasks by Agent

#### OPUS-ARCH Tasks (Primary):
1. Create/update all 11 doc files in `/docs`
2. Create 3+ ADRs
3. Create 5 Mermaid diagrams
4. Update README.md
5. Create CONTRIBUTING.md (for future agents/developers)
6. Final review of all .planning files

#### CODEX-OPS Tasks:
1. Write deploy documentation (05, 10, 11)
2. Write QA test plan (08)
3. Write operations runbook (09)
4. Verify all scripts have inline documentation

#### GEMINI-UX Tasks (Review):
1. Review visual documentation
2. Verify screenshots are current
3. Design system documentation review

### Acceptance Criteria:
- [ ] All 13 documentation deliverables created
- [ ] Mermaid diagrams render correctly
- [ ] README has install/dev/build/deploy instructions
- [ ] No credentials in documentation
- [ ] CHECKIN-LOG.md is complete with all entries

---

*Phase specs created: 2026-05-17T23:20:00Z by OPUS-ARCH*
*Updated when phase plans are refined during execution.*
