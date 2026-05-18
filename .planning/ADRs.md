# ADR-001: Stack Selection — Astro + TypeScript + Tailwind CSS v4

**Status:** Accepted
**Date:** 2026-05-17
**Decision Maker:** OPUS-ARCH
**Approved By:** User

## Context

O Colégio Villa Prime precisa de um site institucional premium para converter visitantes em matrículas. O hosting é HostGator compartilhado (cPanel, Apache, sem Node.js runtime). O site precisa de Lighthouse ≥ 90, SEO excelente e zero dependência de servidor para runtime.

## Decision

Usar **Astro 6.x + TypeScript (strict) + Tailwind CSS v4** com output estático.

## Rationale

| Critério | Astro | Next.js | WordPress | HTML Puro |
|----------|-------|---------|-----------|-----------|
| Static output | ✅ Nativo | ⚠️ Requer config | ❌ PHP | ✅ |
| TypeScript | ✅ | ✅ | ❌ | ❌ |
| Component model | ✅ .astro | ✅ React | ❌ | ❌ |
| Build performance | ✅ Rápido | ⚠️ | N/A | N/A |
| Hosting compatível | ✅ Static files | ⚠️ Node required | ✅ | ✅ |
| SEO | ✅ Zero JS default | ⚠️ Hydration | ⚠️ Plugins | ✅ |
| Manutenibilidade | ✅ Components | ✅ | ⚠️ | ❌ |

**Astro** vence porque:
1. Output 100% estático — sem Node.js no servidor
2. Zero JavaScript no cliente por padrão — melhor performance
3. Component model para reusabilidade sem overhead
4. Tailwind v4 integra nativamente via Vite plugin
5. Sitemap, prefetch e SEO como integrações oficiais

## Consequences

- **Positivo:** Máxima performance, SEO, segurança, compatibilidade HostGator
- **Negativo:** Sem CMS admin (conteúdo via código), sem SSR/API routes
- **Mitigação:** v2 pode adicionar CMS headless se necessário

## Alternatives Rejected

- **Next.js:** Requer Node.js runtime ou adaptador — incompatível com hosting
- **WordPress:** Superfície de ataque enorme, performance inferior, overengineering
- **HTML puro:** Sem componentização, manutenção impossível em 9+ páginas

---

# ADR-002: Design System — Deep Teal Institutional

**Status:** Accepted
**Date:** 2026-05-17
**Decision Maker:** OPUS-ARCH
**Approved By:** User

## Context

Escolas infantis tipicamente usam paletas infantis (amarelo, verde, rosa pastel) que não transmitem autoridade. O Villa Prime quer se posicionar como premium e institucional, não como "escolinha colorida".

## Decision

Paleta primária **Deep Teal (#004254)** com accent **Warm Gold (#d4a910)**.

## Rationale

- Teal transmite confiança, segurança e sofisticação
- Diferencia do mercado (99% das escolas usam paleta infantil)
- Gold adiciona calor sem infantilizar
- Contraste WCAG 2.1 AA garantido em todas as combinações texto/fundo
- Compatível com glassmorphism e design premium moderno

## Color Palette

```
Primary:  #004254 (Deep Teal 800 — cor principal)
          #006d84 (Teal 500 — interações/hover)
          #e6f2f5 (Teal 50 — backgrounds suaves)

Accent:   #d4a910 (Warm Gold — CTAs, destaques)
          #f6c91f (Gold Light — hover states)

Neutral:  #171717 → #fafafa (escala de 50 a 950)
```

## Typography

- **Body:** Inter (Google Fonts) — legibilidade, modernidade
- **Display/Headings:** Playfair Display — elegância, autoridade
- Scale: 0.75rem → 4.5rem (12px → 72px)

## Consequences

- **Positivo:** Identidade única, premium, confiança dos pais
- **Negativo:** Requer atenção em seções fotográficas (fotos infantis vs paleta sóbria)
- **Mitigação:** Usar fotos com overlay sutil de teal para manter coerência visual

---

# ADR-003: Deploy Strategy — SSH/rsync para HostGator

**Status:** Accepted
**Date:** 2026-05-17
**Decision Maker:** OPUS-ARCH
**Approved By:** User

## Context

O deploy precisa ser automatizado, seguro e reversível. O servidor é HostGator compartilhado com SSH disponível mas sem CI/CD nativo.

## Decision

Pipeline de deploy via **SSH/rsync** com scripts PowerShell (.ps1) para Windows e Bash (.sh) para CI.

## Pipeline

```
Build Local → Preflight Check → Remote Backup → rsync Upload → Validate → Done
                                                                   ↓ (falha)
                                                              Rollback ← Restore Backup
```

## Scripts (owned by CODEX-OPS)

1. `hostgator-preflight.ps1` — Testa SSH, valida paths, verifica env
2. `hostgator-backup.ps1` — `tar -czf` do webroot remoto antes de deploy
3. `hostgator-deploy.ps1` — `rsync -avz --delete` com exclusões
4. `hostgator-rollback.ps1` — Restaura último backup
5. `hostgator-validate.ps1` — `curl` health check pós-deploy

## Security Constraints

- Credenciais em `.env.deploy.local` (gitignored)
- Chave SSH sem passphrase para automação (ou ssh-agent)
- Nunca chmod 777
- Não interagir com arquivos desconhecidos no servidor (malware.txt alert)
- .htaccess com security headers

## Consequences

- **Positivo:** Deploy em < 30s, reversível, automatizado
- **Negativo:** Requer SSH key configurado manualmente pelo user
- **Mitigação:** Documentação step-by-step no onboarding

---
