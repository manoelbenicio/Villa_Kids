# FASE 2 — Prompts para GEMINI-UX (Components)

---

## Task 2.1-2.15 — Build de todos os 15 componentes

```
Você é GEMINI-UX, agente UI/UX do Colégio Villa Prime.
Leia: .planning/AGENT-ONBOARDING.md → AGENT-CONTRACT.md → ARCHITECTURE-BLUEPRINT.md (Section 2)

CONTEXTO: Projeto PREMIUM Fortune 500. Tecnologia disruptiva. Efeitos visuais que impressionam à primeira vista. Glassmorphism, parallax, micro-animações, gradients sofisticados, scroll-triggered effects.

MISSÃO: Criar TODOS os 15 componentes em site/src/components/ e site/src/layouts/.
Use o Design System de site/src/styles/global.css e as interfaces TypeScript do ARCHITECTURE-BLUEPRINT.md Section 2.2.

COMPONENTES (crie TODOS):

1. BaseLayout.astro — Layout master. Inclui SEOHead, SchemaOrg, Google Fonts (Inter+Playfair), global.css, skip-to-content link, Header, slot, Footer, WhatsAppButton, scroll-reveal script.

2. Header.astro — Sticky header glass effect. Transparente no topo, sólido ao scrollar. Logo à esquerda, nav ao centro, CTA "Matrículas" à direita. Hamburger menu mobile com animação suave. Transition 300ms.

3. Footer.astro — 4 colunas: Logo+Sobre | Links Rápidos | Contato | Redes Sociais. Gradient de fundo primary-900→primary-950. Copyright dinâmico (new Date().getFullYear()). Links com hover gold.

4. Hero.astro — IMPACTO VISUAL MÁXIMO. Background image com gradient overlay (primary-950 70% → transparent). Parallax scroll effect. H1 com font-display, text-7xl desktop / text-4xl mobile. Subtitle. 2 CTAs side-by-side: "Agende uma Visita" (whatsapp) + "Conheça a Escola" (outline). Animated entrance fadeInUp com stagger.

5. SectionTitle.astro — Tag decorativo (pill com texto small caps accent), título h2, subtítulo opcional. Linha decorativa animada gold abaixo. Props: tag, title, subtitle, alignment (left|center|right).

6. CTAButton.astro — 4 variantes: primary (gradient teal, hover glow), secondary (outline teal), whatsapp (verde #25D366, ícone WhatsApp SVG), outline (borda teal, hover fill). Sizes: sm/md/lg. Hover scale 1.02 + shadow. Transition 200ms.

7. FeatureCard.astro — Card com ícone SVG no topo (64px, cor accent), título h3, descrição p. Hover: translateY(-4px) + shadow-xl + borda accent sutil. Border-radius xl. Background surface com borda subtle.

8. TrustBadge.astro — Número grande (text-5xl, font-bold, accent-500) com animação de contagem (countUp via IntersectionObserver). Label abaixo (text-sm). Usado para "15+ Anos", "500+ Alunos", etc.

9. FAQ.astro — Accordion acessível. Cada item: button com aria-expanded, conteúdo com aria-hidden. Animação max-height transition. Ícone chevron rotaciona 180deg ao abrir. Schema.org FAQPage JSON-LD automático.

10. TestimonialCard.astro — Card com aspas decorativas (SVG grande, accent-200 opacity), quote em itálico, avatar circular (48px), nome bold, turma/role em text-sm neutral-500. Shadow-md, hover shadow-lg.

11. ContactForm.astro — Form premium: inputs com label floating, border-bottom style, focus glow accent. Campos: nome, email, telefone, mensagem, turma (select). Honeypot field hidden. Validação client-side JS. Botão submit com loading state.

12. WhatsAppButton.astro — Floating button fixed bottom-right. Ícone WhatsApp SVG branco sobre fundo #25D366. Border-radius full. Shadow-xl. Pulse animation infinita sutil. Hover scale 1.1. Z-index tooltip. Link para wa.me/{número}.

13. Gallery.astro — Grid responsivo (1 col mobile, 2 tablet, 3 desktop). Imagens com aspect-ratio, object-cover, border-radius-lg. Hover: scale 1.03 + overlay com ícone de zoom. Lightbox nativo com dialog element.

14. SEOHead.astro — Todas as meta tags: charset, viewport, title, description, canonical, robots. Open Graph: og:title, og:description, og:image, og:url, og:type, og:locale. Twitter Card: summary_large_image.

15. SchemaOrg.astro — JSON-LD: @type [LocalBusiness, EducationalOrganization]. Dados de site/src/data/school-info.ts. Props para type override por página.

TAMBÉM CRIAR os arquivos de dados em site/src/data/:
- navigation.ts (copiar do ARCHITECTURE-BLUEPRINT.md Section 6.2)
- school-info.ts (copiar do Section 6.1)
- features.ts (4 pilares: Acolhimento, Desenvolvimento, Segurança, Família)
- testimonials.ts (3 depoimentos placeholder)
- faq.ts (6 perguntas comuns sobre escola infantil)

QUALIDADE: Cada componente deve ser responsivo, acessível (WCAG 2.1 AA), animado, e visualmente PREMIUM.

Registre check-in em .planning/CHECKIN-LOG.md ao iniciar e ao terminar.
```
