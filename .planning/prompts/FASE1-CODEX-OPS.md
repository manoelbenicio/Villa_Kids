# FASE 1 — Prompts para CODEX-OPS

> Cole cada prompt na IDE do CODEX-OPS. Ele deve usar até 4 sub-agentes em paralelo.

---

## Task 1.1 — Validar scaffold + criar estrutura

```
Você é CODEX-OPS, o agente DevOps/QA do projeto Colégio Villa Prime.

PRIMEIRO: Leia os arquivos `.planning/AGENT-ONBOARDING.md` e `.planning/AGENT-CONTRACT.md` para entender seu papel e regras.

CONTEXTO: Este é um projeto PREMIUM nível Fortune 500. O OPUS-ARCH (arquiteto) já entregou:
- `site/astro.config.mjs` — config Astro com static output
- `site/src/styles/global.css` — Design System completo
- `.planning/ARCHITECTURE-BLUEPRINT.md` — estrutura definitiva

SUA MISSÃO (use 4 sub-agentes em paralelo para máxima velocidade):

SUB-AGENTE 1: Validar build
- cd site/ && npm install && npm run build
- Confirmar que /dist é gerado sem erros
- Verificar que astro.config.mjs está correto

SUB-AGENTE 2: Criar estrutura de diretórios
Conforme ARCHITECTURE-BLUEPRINT.md Section 1, criar:
- site/src/layouts/
- site/src/components/
- site/src/scripts/
- site/src/data/
- site/public/images/{hero,gallery,icons,team}
- site/scripts/ (deploy scripts)
- site/docs/

SUB-AGENTE 3: Criar page shells (9 arquivos .astro vazios)
Em site/src/pages/:
- index.astro
- proposta-pedagogica.astro
- turmas.astro
- estrutura.astro
- tecnologia.astro
- seguranca.astro
- matriculas.astro
- contato.astro
- politica-de-privacidade.astro
Cada um com frontmatter básico: ---\nlayout: '../layouts/BaseLayout.astro'\ntitle: 'Nome da Página'\n---

SUB-AGENTE 4: Configurações
- tsconfig.json com strict: true, paths aliases
- .env.deploy.example com: DEPLOY_HOST, DEPLOY_USER, DEPLOY_PATH, DEPLOY_PORT
- Verificar .gitignore inclui: node_modules, dist, .env*, .DS_Store

AO TERMINAR: Registre check-in em `.planning/CHECKIN-LOG.md` com timestamp, status e evidência do build.
```

---

## Task 1.5 — Criar .htaccess

```
Você é CODEX-OPS. LEIA `.planning/AGENT-CONTRACT.md` antes de agir.

Crie o arquivo `site/public/.htaccess` conforme `.planning/ARCHITECTURE-BLUEPRINT.md` Section 5.

O arquivo DEVE conter:
1. Security headers (X-Content-Type-Options, X-Frame-Options, X-XSS-Protection, Referrer-Policy, Permissions-Policy)
2. Cache control (mod_expires: HTML=1h, CSS/JS/imagens/fonts=1 ano)
3. Compression (mod_deflate: HTML, CSS, JS, JSON, SVG)
4. Force HTTPS (RewriteEngine)
5. Redirect non-www → www (ou vice-versa — usar www)
6. Custom 404 page (ErrorDocument 404 /404.html)

IMPORTANTE: Copie EXATAMENTE o template do ARCHITECTURE-BLUEPRINT.md Section 5.
Registre check-in em `.planning/CHECKIN-LOG.md`.
```

---

## Task 1.6 — Criar robots.txt

```
Você é CODEX-OPS. Crie `site/public/robots.txt` conforme ARCHITECTURE-BLUEPRINT.md Section 4.3:

User-agent: *
Allow: /
Disallow: /404
Sitemap: https://www.colegiovillaprime.com.br/sitemap-index.xml

Verifique que o sitemap integration no astro.config.mjs está ativo.
Registre check-in em `.planning/CHECKIN-LOG.md`.
```
