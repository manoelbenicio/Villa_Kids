# Análise do Site Referência — Escola Petit Enfant

**Data da análise:** 2026-05-17
**Fonte:** Firecrawl API v2 (scrape + map) + Browser Visual Capture
**URL:** https://www.escolapetitenfant.com.br/

---

## 1. Resumo Executivo

O site da Escola Petit Enfant é um website institucional single-page (com 1 página interna para Berçário) construído em **WordPress 6.9.4 + Elementor 3.30.3**. É um site simples, focado em conversão via WhatsApp, com design emocional voltado para mães de crianças de 0 a 6 anos na região do Tatuapé, São Paulo.

## 2. Estrutura do Site (Firecrawl Map)

### URLs Descobertas (5 total)
| URL | Tipo | Relevância |
|-----|------|------------|
| `/` (homepage) | Página principal single-page | ⭐ Core |
| `/bercario/` | Página interna dedicada | ⭐ Importante |
| `/tampao` | Página auxiliar/teste | ❌ Ignorar |
| `/category/uncategorized` | WordPress default | ❌ Ignorar |
| `/2025/02/15/hello-world` | WordPress default post | ❌ Ignorar |

### Navegação Principal
- Home (`#home`)
- A Petit (`#apetit`)
- Berçário (`/bercario/` — única página separada)
- Nossos Pilares (`#pilares`)
- Nossos Ambientes (`#ambientes`)
- Galeria (`#galeria`)
- Depoimentos (`#depoimentos`)
- Contato (`#contato`)

## 3. Arquitetura de Conteúdo (Homepage)

### Seção 1 — Hero
- **Título:** "Escola de Educação Infantil"
- **Subtítulo:** "Uma das decisões mais importante que você tomará como mãe"
- **CTA:** "Matrículas abertas" → WhatsApp link
- **Vídeo:** Embed Vimeo/YouTube no lado direito
- **Propósito:** Conversão imediata + conexão emocional

### Seção 2 — A Petit Enfant
- Texto institucional sobre missão e valores
- Foco: acolhimento, família, cuidado, amor
- 2 imagens arredondadas
- CTA: "Venha conhecer" → WhatsApp

### Seção 3 — Nossos Pilares (2x2 grid)
| Pilar | Descrição |
|-------|-----------|
| **Amor** | Base para educação intelectual e social, autoestima e autoconfiança |
| **Pedagogia** | Aprender a aprender, proatividade, criatividade, independência |
| **Lazer** | Ferramenta de desenvolvimento intelectual, psicomotor e social |
| **Cuidar** | Ambientes seguros, higiene rigorosa, alimentação de qualidade |

### Seção 4 — Nossos Ambientes (grid de cards)
| Ambiente | Destaque |
|----------|----------|
| **Espaço Amplo e Seguro** | Prédio térreo, 400m² parque externo |
| **Berçário** | Turmas reduzidas, atenção individualizada, adaptação respeitosa |
| **Parque ao Ar-Livre** | Casa na árvore, roda de histórias, campos de jogos, piscina |
| **Educação Infantil** | Preparação na primeira infância, acolhimento |

### Seção 5 — Galeria de Fotos
- 9 imagens em grid
- Crianças em atividades reais

### Seção 6 — Depoimentos (Carousel)
- 3 depoimentos de mães (Natália P., Renata B., Amanda A.)
- Carousel horizontal com repetição

### Seção 7 — Formulário de Contato
- Campos: Nome, Telefone, Email, Mensagem
- Botão "Enviar"

### Seção 8 — Matrículas Abertas / Rodapé
- Contato direto: WhatsApp, telefone fixo
- Redes sociais: Instagram, Facebook
- Endereço: Rua Freire de Andrade, 44 — Tatuapé, São Paulo
- Google Maps embed
- Copyright + créditos de agências

## 4. Stack Técnica Detectada

| Componente | Tecnologia |
|------------|------------|
| CMS | WordPress 6.9.4 |
| Page Builder | Elementor 3.30.3 |
| Analytics | Site Kit by Google 1.152.1 |
| Font Loading | Google Fonts (swap display) |
| SEO | Yoast/RankMath (inferido pelo meta robots) |
| Idioma | pt_PT (configuração) |

## 5. SEO & Metadata (Firecrawl)

| Meta | Valor |
|------|-------|
| Title | "Home - Escola Petit Enfant" |
| OG Title | "Home - Escola Petit Enfant" |
| OG Type | website |
| OG Locale | pt_PT |
| Twitter Card | summary |
| Google Verification | 59MeSKCB9pCEm9KHBiCgIOHDr5vxhkft-BDz0zqKiTw |
| Description | ⚠️ Mal configurada (mostra números de telefone) |

**Deficiências SEO identificadas:**
- Meta description não otimizada
- Sem Schema.org structured data
- Sem sitemap.xml verificado
- Sem breadcrumbs
- Sem alt text padronizado nas imagens

## 6. Design System Observado

### Cores
| Elemento | Cor Aproximada |
|----------|----------------|
| Barra superior | Magenta/Fuchsia (#D81B60) |
| CTAs principais | Amarelo/Laranja vibrante |
| Backgrounds | Branco (#FFFFFF) |
| Seção Ambientes | Azul claro/Cyan com textura |
| Texto principal | Navy/Dark Slate escuro |
| WhatsApp float | Verde padrão |

### Tipografia
- Headings: Sans-serif arredondada (estilo Quicksand)
- Body: Sans-serif legível (Montserrat/Poppins/Roboto)

### Layout
- Header sticky com transparência/frost
- Single-page com scroll suave entre âncoras
- Cards com bordas arredondadas
- Imagens com moldura rounded

## 7. Elementos Interativos
- ✅ Header sticky/fixo
- ✅ Vídeo embed no hero
- ✅ Carousel de depoimentos
- ✅ Galeria de fotos (grid expandível)
- ✅ Formulário de contato
- ✅ WhatsApp floating badge (canto inferior direito)
- ✅ Links para redes sociais

## 8. Informações de Contato Extraídas
- **WhatsApp:** 11 9.1577-8669
- **Telefone fixo:** 11 2671-0767
- **Instagram:** @petit_enfant_escola
- **Facebook:** /escolapetitenfant
- **Endereço:** Rua Freire de Andrade, 44 — Tatuapé, São Paulo

## 9. Padrões a Replicar no Novo Site

### ✅ Manter
- Estrutura single-page com navegação por âncoras
- Hero com CTA forte para conversão
- Pilares pedagógicos como diferenciação
- Depoimentos de pais como prova social
- WhatsApp como canal primário de conversão
- Galeria de fotos reais
- Formulário de contato simples

### ⬆️ Melhorar
- SEO: meta descriptions otimizadas, schema.org, sitemap
- Performance: eliminar WordPress/Elementor overhead
- Design System: paleta mais sofisticada (Deep Teal conforme Master Prompt)
- Páginas internas: expandir além de berçário (turmas, estrutura, tecnologia, segurança, matrículas)
- Acessibilidade: WCAG 2.1 AA compliance
- LGPD: política de privacidade, cookie consent
- Mobile-first: garantir responsividade premium

### ❌ Não Replicar
- WordPress/Elementor (usar Astro + TypeScript + Tailwind)
- Meta descriptions com números de telefone
- Página "Hello World" e categorias default
- Dependência excessiva de plugins
- Design sem dark mode/tema alternativo

---
*Análise gerada via Firecrawl API v2 + Browser DevTools — 2026-05-17*
