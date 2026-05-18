# FASE 4 — Prompts (Internal Pages)

---

## Task 4.1-4.5 — GEMINI-UX: 5 páginas internas

```
Você é GEMINI-UX. Leia .planning/ARCHITECTURE-BLUEPRINT.md (Section 3.2).

CONTEXTO: Projeto PREMIUM Fortune 500. Home Page está pronta. Agora crie as 5 páginas internas.

Cada página segue o padrão: Hero Banner curto (h1 + breadcrumb) → 2-4 seções de conteúdo → CTA relacionado → Mini-seção contato.

Use BaseLayout.astro, SectionTitle.astro, CTAButton.astro, e demais componentes da Fase 2.

PÁGINAS:

1. site/src/pages/proposta-pedagogica.astro
   - Hero: "Nossa Proposta Pedagógica"
   - Seção: Metodologia (texto + ícones)
   - Seção: Eixos de Desenvolvimento (grid cards)
   - Seção: Rotina Escolar (timeline visual)
   - CTA: "Agende uma visita para conhecer na prática"

2. site/src/pages/turmas.astro
   - Hero: "Nossas Turmas"
   - Cards por faixa etária: Berçário (0-1), Maternal I (1-2), Maternal II (2-3), Jardim I (3-4), Jardim II (4-5), Pré (5-6)
   - Cada card: idade, capacidade, destaques, foto
   - CTA: "Encontre a turma ideal → Matrículas"

3. site/src/pages/estrutura.astro
   - Hero: "Nossa Estrutura"
   - Grid de ambientes com foto + descrição
   - Galeria de fotos da escola
   - CTA: "Venha conhecer pessoalmente"

4. site/src/pages/tecnologia.astro
   - Hero: "Tecnologia e Inovação"
   - Recursos tecnológicos (agenda digital, câmeras, plataforma)
   - FeatureCards com ícones tech
   - CTA: "Saiba mais sobre nossos diferenciais"

5. site/src/pages/seguranca.astro
   - Hero: "Segurança e Bem-estar"
   - Protocolos de segurança (CCTV, controle acesso, bombeiros)
   - TrustBadges (números de segurança)
   - CTA: "A segurança do seu filho é prioridade"

QUALIDADE: Todas responsivas, animadas, acessíveis. Efeitos visuais premium em cada página.
Registre check-in em .planning/CHECKIN-LOG.md.
```

---

## Task 4.6 — CODEX-OPS: Testar navegação

```
Você é CODEX-OPS. Use 4 sub-agentes em paralelo.

SUB-AGENTE 1: npm run build — confirmar build com 6 páginas (home + 5 internas)
SUB-AGENTE 2: Testar todos os links de navegação (Header, Footer, CTAs entre páginas)
SUB-AGENTE 3: Verificar URLs no formato directory (/turmas/ não /turmas)
SUB-AGENTE 4: Lighthouse audit nas 5 páginas internas

Registre check-in em .planning/CHECKIN-LOG.md.
```
