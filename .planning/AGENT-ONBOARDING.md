# 🚀 Agent Onboarding — Colégio Villa Prime

**READ THIS FIRST** — Before doing ANY work on this project.

---

## Quick Start for New Agents

### Step 1: Read the Contract
```
.planning/AGENT-CONTRACT.md
```
Identify your Agent ID and understand your role boundaries.

### Step 2: Check-In
Add your first entry to `.planning/CHECKIN-LOG.md`:
```
| # | Start (UTC) | End (UTC) | Agent ID | Phase | Task | Status | Evidence |
```

### Step 3: Sign the Contract
Update the Signatures table in `AGENT-CONTRACT.md`:
```
| YOUR-AGENT-ID | ✅ Contract acknowledged | TIMESTAMP |
```

### Step 4: Check Phase Ownership
```
.planning/PHASE-SPECS.md
```
Find your assigned tasks for the current active phase.

### Step 5: Check for Handoffs
Look at the **Handoff Queue** in `CHECKIN-LOG.md` for any tasks waiting for you.

---

## Project Context (TL;DR)

| Item | Value |
|------|-------|
| **Project** | Colégio Villa Prime — Site institucional escola infantil (0-6 anos) |
| **Stack** | Astro + TypeScript + Tailwind CSS (static output) |
| **Deploy Target** | HostGator shared hosting via SSH/rsync |
| **Server** | `sh00140.hostgator.com.br` → `/home2/cri07713/public_html` |
| **Design** | Premium institutional, Deep Teal #004254, NÃO infantil genérico |
| **Language** | PT-BR (conteúdo), EN (código, commits, docs técnicos) |
| **Quality Gates** | Lighthouse ≥ 90 all categories, WCAG 2.1 AA |

---

## File Structure

```
Web_Devlop_EscolaVillaKids/
├── .planning/                    # 🔒 OPUS-ARCH owns (read-only for others except CHECKIN-LOG)
│   ├── PROJECT.md                # Project scope and context
│   ├── REQUIREMENTS.md           # 54 v1 requirements
│   ├── ROADMAP.md                # 8-phase roadmap
│   ├── AGENT-CONTRACT.md         # ⚠️ READ FIRST — Multi-agent rules
│   ├── CHECKIN-LOG.md            # ✍️ ALL agents write here
│   ├── PHASE-SPECS.md            # Detailed per-phase agent tasks
│   ├── AGENT-ONBOARDING.md       # This file
│   ├── config.json               # GSD configuration
│   └── research/                 # Reference site analysis
│       └── REFERENCE-SITE-ANALYSIS.md
├── src/                          # Source code (to be created in Phase 1)
│   ├── layouts/                  # OPUS-ARCH owns
│   ├── components/               # GEMINI-UX (style) + OPUS-ARCH (structure)
│   ├── pages/                    # OPUS-ARCH (structure) + GEMINI-UX (content)
│   └── styles/                   # GEMINI-UX owns
├── public/                       # Static assets
│   └── .htaccess                 # CODEX-OPS owns
├── scripts/                      # Deploy scripts — CODEX-OPS owns
├── docs/                         # Documentation — OPUS-ARCH owns
└── dist/                         # Build output (gitignored)
```

---

## Agent-Specific Quick Guides

### For CODEX-OPS (Codex 5.5 High)

Your primary responsibilities:
1. **Deploy pipeline** — All scripts in `/scripts`
2. **QA & Testing** — Lighthouse, accessibility, responsiveness
3. **Troubleshooting** — Build errors, deploy failures, runtime issues
4. **Security** — .htaccess, no exposed secrets, LGPD compliance

Key files you own:
- `scripts/hostgator-preflight.ps1`
- `scripts/hostgator-backup.ps1`
- `scripts/hostgator-deploy.ps1`
- `scripts/hostgator-rollback.ps1`
- `scripts/hostgator-validate.ps1`
- `public/.htaccess`
- `.env.deploy.example`

**⚠️ NEVER deploy without:**
1. Logging in CHECKIN-LOG.md
2. Running preflight check
3. Creating remote backup
4. Verifying build output is static

### For GEMINI-UX (Gemini variants)

Your primary responsibilities:
1. **Visual design** — CSS, animations, micro-interactions
2. **Component styling** — All Astro components look premium
3. **Image generation** — Hero images, section backgrounds, icons
4. **Responsiveness** — Mobile-first, all breakpoints
5. **Deploy assist** — Help CODEX-OPS when requested

Key files you own:
- `src/styles/global.css`
- `src/styles/components.css`
- `tailwind.config.mjs` (shared with OPUS-ARCH)

**⚠️ Design constraints:**
- Primary: Deep Teal `#004254`
- Font: Inter (body) + accent serif/display
- Style: Premium institutional, NOT childish/cartoon
- MUST pass WCAG 2.1 AA contrast
- MUST work on 320px mobile

---

## Commit Convention

```
[AGENT-ID] phase-N: short description

[OPUS-ARCH] phase-1: scaffold Astro project with TypeScript
[CODEX-OPS] phase-7: implement SSH preflight validation
[GEMINI-UX] phase-2: style Hero with parallax gradient
```

---

## When You're Stuck

1. Log `BLOCKED` in CHECKIN-LOG.md with the reason
2. Check if another agent's handoff is needed
3. Check AGENT-CONTRACT.md escalation matrix
4. Ask the user for clarification

---

## Current Project Status

| Phase | Status | Owner |
|-------|--------|-------|
| Pre-0: Discovery & Setup | ✅ COMPLETED | OPUS-ARCH |
| Phase 1: Foundation | ⏳ NEXT | OPUS-ARCH |
| Phase 2-8 | 📋 PLANNED | See PHASE-SPECS.md |

**Next action:** OPUS-ARCH begins Phase 1 (Astro scaffold + Design System).

---

*Onboarding guide created: 2026-05-17T23:20:00Z by OPUS-ARCH*
*Update this file when project structure changes.*
