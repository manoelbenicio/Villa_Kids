# FASE 3 — Prompts (Home Page)

---

## Task 3.1-3.8 — GEMINI-UX: Montar Home Page completa

```
Você é GEMINI-UX. Leia .planning/AGENT-CONTRACT.md e .planning/ARCHITECTURE-BLUEPRINT.md (Section 3.1).

CONTEXTO: Projeto PREMIUM Fortune 500. Os 15 componentes da Fase 2 estão prontos. Agora monte a Home Page usando-os.

MISSÃO: Montar site/src/pages/index.astro com 8 seções nesta ordem:

1. HERO — Componente Hero.astro. Imagem fullscreen com gradient overlay. H1: "Educação que transforma os primeiros anos". Subtitle inspiracional. 2 CTAs: "Agende uma Visita" (WhatsApp) + "Conheça a Escola" (scroll to about). Entrada animada fadeInUp com stagger de 200ms entre elementos.

2. SOBRE A ESCOLA — Layout split (texto 60% + imagem 40%). Texto: breve história, missão, diferenciais. CTA: "Conheça nossa proposta" → /proposta-pedagogica/. Imagem com border-radius-2xl + shadow-xl. Scroll-reveal animation.

3. PILARES PEDAGÓGICOS — SectionTitle + grid de 4 FeatureCards. Pilares: Acolhimento, Desenvolvimento Integral, Segurança, Parceria com Famílias. Dados de src/data/features.ts. Grid: 2x2 desktop, 1 col mobile. Cards com reveal stagger.

4. NOSSOS AMBIENTES — SectionTitle + grid horizontal de cards com foto do ambiente. 6 ambientes: Berçário, Sala de Atividades, Playground, Refeitório, Sala Multimídia, Área Verde. Cards com foto (aspect-ratio 4/3), nome overlay glass-dark na base. Hover zoom sutil.

5. GALERIA DE FOTOS — SectionTitle + Gallery.astro. 8-12 fotos placeholder (use imagens genéricas ou gradient placeholders). Grid responsivo com lightbox.

6. DEPOIMENTOS — SectionTitle + 3 TestimonialCards. Dados de src/data/testimonials.ts. Layout: 3 colunas desktop, carousel ou stack mobile.

7. FAQ PREVIEW — SectionTitle "Perguntas Frequentes" + FAQ.astro com 5 primeiras perguntas de src/data/faq.ts. CTA abaixo: "Tire todas suas dúvidas → Fale conosco".

8. CTA FINAL — Seção fullwidth com bg-gradient-warm. Texto: "Venha conhecer o Villa Prime". 2 CTAs grandes: WhatsApp + Telefone. Padding generoso (section-lg).

QUALIDADE: Cada seção deve ter scroll-reveal animation. Transições suaves entre seções. Mobile-first. Resultado deve ser IMPACTANTE visualmente.

Registre check-in em .planning/CHECKIN-LOG.md.
```

---

## Task 3.9 — CODEX-OPS: Testar responsividade

```
Você é CODEX-OPS. Use 4 sub-agentes em paralelo.

MISSÃO: Testar a Home Page (site/src/pages/index.astro) em 3 viewports:

SUB-AGENTE 1: npm run build — confirmar build limpo sem erros
SUB-AGENTE 2: npm run dev — abrir no browser, testar mobile (375px)
SUB-AGENTE 3: Testar tablet (768px) e desktop (1280px)
SUB-AGENTE 4: Lighthouse audit da home (Performance ≥ 90, Accessibility ≥ 90, SEO ≥ 95)

Reporte problemas encontrados para GEMINI-UX fixar.
Registre check-in em .planning/CHECKIN-LOG.md.
```
