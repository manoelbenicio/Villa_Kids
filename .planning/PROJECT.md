# Colégio Villa Prime — Website Institucional

## What This Is

Website institucional premium, moderno e responsivo para o Colégio Villa Prime, uma escola de educação infantil para crianças de 0 a 6 anos. O site é focado em transmitir confiança, segurança, tecnologia, pedagogia, comunicação com pais e conversão de matrículas, com forte SEO local para a região de São Paulo.

## Core Value

**Converter visitantes em matrículas** através de uma experiência digital que transmita a mesma segurança, acolhimento e excelência pedagógica que os pais encontrarão presencialmente na escola.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Website responsivo mobile-first com design premium
- [ ] Página Home com hero, pilares pedagógicos, ambientes, galeria, depoimentos, CTAs
- [ ] Página Proposta Pedagógica (educação infantil 0-6, desenvolvimento integral)
- [ ] Página Turmas (berçário, maternal, infantil com faixas etárias)
- [ ] Página Estrutura (segurança, salas, playground, higiene, acessibilidade)
- [ ] Página Tecnologia (app para pais, comunicação digital, transparência)
- [ ] Página Segurança (acesso controlado, saúde, emergência, LGPD)
- [ ] Página Matrículas (conversão, agendamento de visita, documentos, WhatsApp CTA)
- [ ] Página Contato (endereço, telefone, WhatsApp, email, mapa, formulário)
- [ ] Página Política de Privacidade (LGPD)
- [ ] SEO otimizado (local SEO, schema.org, sitemap, meta tags)
- [ ] Acessibilidade WCAG 2.1 AA
- [ ] Performance Lighthouse ≥ 90 em todas as categorias
- [ ] WhatsApp floating button em todas as páginas
- [ ] Formulário de contato funcional
- [ ] Deploy automatizado para HostGator via SSH/rsync
- [ ] Scripts de backup, rollback e validação
- [ ] Documentação completa (PRD, Design System, Arquitetura, Deploy, QA)

### Out of Scope

- Área administrativa/CMS — site estático, conteúdo via código
- Sistema de matrícula online com pagamento — conversão via WhatsApp/telefone
- Blog/notícias — pode ser adicionado em v2
- Chat ao vivo — WhatsApp é o canal primário
- Integração com ERP/sistema escolar — fora do escopo v1
- App mobile nativo — apenas website responsivo
- Multilingual — apenas Português BR
- E-commerce/loja virtual — não aplicável

## Context

### Referência de Mercado
- Site modelo analisado: [Escola Petit Enfant](https://www.escolapetitenfant.com.br/)
- WordPress + Elementor, single-page com 1 página interna (berçário)
- Localizado no Tatuapé, São Paulo
- Análise completa via Firecrawl em `.planning/research/REFERENCE-SITE-ANALYSIS.md`

### Ambiente Técnico
- **Hosting:** HostGator Brasil (cPanel)
- **Servidor:** sh00140.hostgator.com.br
- **Home path:** /home2/cri07713
- **Webroot candidato:** /home2/cri07713/public_html
- **Domínio configurado:** colegiovillaprime.com.br
- **Hospedagem:** Plano 3 anos pré-pago
- **Desenvolvimento:** Local via Antigravity IDE (VS Code)
- **Deploy:** SSH/rsync para HostGator

### Público-alvo
- Pais e mães de crianças de 0 a 6 anos
- Região: São Paulo / Zona Leste (ajustável)
- Perfil: classe média/média-alta buscando escola de qualidade
- Decisor primário: mães (baseado no padrão do mercado)

### Sinais de Segurança do Servidor
- Arquivo `malware.txt` detectado no cPanel — tratar como sinal de segurança
- Nunca usar chmod 777
- Deploy apenas para webroot confirmado

## Constraints

- **Stack:** Astro + TypeScript + Tailwind CSS (static-first) — HostGator shared não suporta Node.js em produção
- **Deploy:** SSH/rsync para cPanel — sem CI/CD nativo
- **Formulários:** PHP simples se disponível, ou serviço externo (Formspree/Netlify Forms)
- **Imagens:** Placeholders até assets reais serem fornecidos pelo cliente
- **Domínio:** colegiovillaprime.com.br (configuração DNS no cPanel)
- **SSL:** Verificar se Let's Encrypt está ativo no cPanel
- **Segurança:** Sem credenciais no repositório, usar .env.deploy.local

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Astro + TypeScript + Tailwind (static-first) | HostGator shared não suporta Node.js runtime; static = melhor performance, SEO, segurança | — Pending |
| Deploy via SSH/rsync (não cPanel Git) | Mais controle, backup automático, rollback script | — Pending |
| Design System Deep Teal (#004254) | Diferenciação do mercado (maioria usa cores infantis genéricas); transmite confiança e profissionalismo | — Pending |
| WhatsApp como canal primário de conversão | Padrão do mercado brasileiro para escolas infantis | — Pending |
| Single-page expandido (múltiplas páginas) | Melhor SEO, mais conteúdo indexável, melhor UX que o modelo referência | — Pending |
| Sem WordPress/CMS | Performance, segurança, controle total, sem dependência de plugins | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-05-17 after initialization*
