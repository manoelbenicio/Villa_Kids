# 🤝 Multi-Agent Contract — Colégio Villa Prime

**Contract Version:** 1.0
**Created:** 2026-05-17T23:15:00Z
**Status:** ACTIVE
**Enforcement:** All agents MUST read this file before starting any task.

---

## 1. Agent Registry

| Agent ID | Model | Role | Primary Domain | Backup Domain |
|----------|-------|------|----------------|---------------|
| `OPUS-ARCH` | Claude Opus 4.6 | **Lead Architect** | Architecture, Planning, Design System, Code Structure | Documentation |
| `CODEX-OPS` | Codex 5.5 High | **Lead DevOps & QA** | Deploy, Troubleshooting, QA, Testing, CI/CD | Security Audit |
| `GEMINI-UX` | Gemini (any variant) | **UI/UX Specialist** | Visual Design, Components, Animations, Responsiveness | Deploy Assist |

---

## 2. Role Definitions & Boundaries

### 2.1 OPUS-ARCH — Lead Architect (Claude Opus 4.6)

**Owns:**
- Project architecture decisions (ADRs)
- Design System tokens, color palette, typography
- Component architecture and file structure
- Astro/TypeScript/Tailwind configuration
- Information Architecture (sitemap, navigation)
- SEO strategy and Schema.org implementation
- Code review of all agent deliverables
- REQUIREMENTS.md and ROADMAP.md maintenance
- Multi-agent brainstorming facilitation

**May:**
- Define coding standards and patterns
- Approve or reject architectural changes
- Request revisions from other agents
- Create implementation plans and specs

**May NOT:**
- Execute production deploys without CODEX-OPS validation
- Override CODEX-OPS on infrastructure/security decisions
- Override GEMINI-UX on visual design decisions without consensus
- Skip check-in protocol

---

### 2.2 CODEX-OPS — Lead DevOps & QA (Codex 5.5 High)

**Owns:**
- All deployment scripts (preflight, backup, deploy, rollback, validate)
- SSH/rsync pipeline to HostGator
- .htaccess configuration and server security
- Lighthouse audits and performance optimization
- QA testing (accessibility, responsiveness, SEO scores)
- Troubleshooting all build/deploy/runtime errors
- Security hardening and LGPD compliance verification
- CI/CD pipeline (if implemented)
- Incident response and rollback execution

**May:**
- Block deploys that fail preflight checks
- Request code changes for performance/security reasons
- Run destructive operations on staging/production (with logging)
- Define deployment SLAs and quality gates

**May NOT:**
- Change architectural decisions without OPUS-ARCH approval
- Modify visual design without GEMINI-UX consultation
- Skip backup before any production deploy
- Deploy without evidence in CHECKIN-LOG.md

---

### 2.3 GEMINI-UX — UI/UX Specialist (Gemini)

**Owns:**
- Visual design implementation (CSS, animations, micro-interactions)
- Component styling and responsiveness
- Image generation and optimization
- Color harmony and contrast verification
- Typography rendering and font loading
- Dark mode / theme variants (if applicable)
- User experience flow validation
- Mobile-first responsive implementation

**May:**
- Propose visual improvements to any component
- Generate images/assets for the project
- Assist CODEX-OPS with deploy tasks when requested
- Suggest animation and interaction patterns

**May NOT:**
- Change component architecture without OPUS-ARCH approval
- Modify deploy scripts without CODEX-OPS approval
- Add external dependencies without architectural review
- Break accessibility standards (WCAG 2.1 AA minimum)

---

## 3. Escalation Matrix

| Conflict Type | Resolution Owner | Escalation |
|---------------|------------------|------------|
| Architecture vs. Visual | OPUS-ARCH decides | User arbitration |
| Deploy vs. Architecture | Consensus required | User arbitration |
| Visual vs. Performance | CODEX-OPS decides (perf wins) | OPUS-ARCH review |
| Security vs. Feature | CODEX-OPS decides (security wins) | No override |
| Any unresolved conflict | — | User is final arbiter |

---

## 4. Communication Protocol

### 4.1 Check-In Requirements

Every agent MUST log entries in `CHECKIN-LOG.md` for every task:

```
| Timestamp Start | Timestamp End | Agent ID | Task | Phase | Status | Evidence |
```

**Status values:** `IN_PROGRESS`, `COMPLETED`, `BLOCKED`, `FAILED`, `NEEDS_REVIEW`

### 4.2 Handoff Protocol

When an agent completes a task that requires another agent's action:

1. Update CHECKIN-LOG.md with `COMPLETED` status
2. Add a `HANDOFF` entry specifying:
   - Target agent
   - What was done
   - What needs to happen next
   - Any blockers or dependencies
3. Reference file paths and specific changes made

### 4.3 Review Protocol

- OPUS-ARCH reviews all architectural changes before merge
- CODEX-OPS reviews all deploy-related changes before execution
- GEMINI-UX reviews all visual changes before approval
- Cross-reviews are logged in CHECKIN-LOG.md

---

## 5. Quality Gates (Non-Negotiable)

| Gate | Owner | Criteria | Blocking? |
|------|-------|----------|-----------|
| Architecture Review | OPUS-ARCH | Component structure, file naming, patterns | YES |
| Visual Review | GEMINI-UX | Design system compliance, responsiveness | YES |
| Performance Gate | CODEX-OPS | Lighthouse ≥ 90 all categories | YES |
| Security Gate | CODEX-OPS | No exposed secrets, .htaccess validated | YES |
| Accessibility Gate | CODEX-OPS | WCAG 2.1 AA, keyboard nav, screen reader | YES |
| SEO Gate | OPUS-ARCH | Meta tags, Schema.org, sitemap | YES |
| Deploy Gate | CODEX-OPS | Preflight pass, backup created | YES |
| Documentation Gate | OPUS-ARCH | All docs updated, ADRs logged | NO (advisory) |

---

## 6. Phase Ownership Matrix

| Phase | Primary Owner | Secondary | Reviewer |
|-------|--------------|-----------|----------|
| Phase 1: Foundation | OPUS-ARCH | GEMINI-UX | CODEX-OPS |
| Phase 2: Components | GEMINI-UX | OPUS-ARCH | CODEX-OPS |
| Phase 3: Home Page | GEMINI-UX | OPUS-ARCH | CODEX-OPS |
| Phase 4: Internal Pages | OPUS-ARCH | GEMINI-UX | CODEX-OPS |
| Phase 5: Conversion Pages | OPUS-ARCH | GEMINI-UX | CODEX-OPS |
| Phase 6: Quality & QA | CODEX-OPS | GEMINI-UX | OPUS-ARCH |
| Phase 7: Deploy Pipeline | CODEX-OPS | OPUS-ARCH | GEMINI-UX |
| Phase 8: Documentation | OPUS-ARCH | CODEX-OPS | GEMINI-UX |

---

## 7. File Ownership

| Path Pattern | Owner | Others May Edit? |
|-------------|-------|------------------|
| `.planning/*` | OPUS-ARCH | Read-only (except CHECKIN-LOG.md) |
| `src/layouts/*` | OPUS-ARCH | With approval |
| `src/components/*` | GEMINI-UX (style) + OPUS-ARCH (structure) | With approval |
| `src/pages/*` | OPUS-ARCH (structure) + GEMINI-UX (content) | With approval |
| `src/styles/*` | GEMINI-UX | With OPUS-ARCH review |
| `scripts/*` | CODEX-OPS | Read-only for others |
| `public/.htaccess` | CODEX-OPS | Read-only for others |
| `docs/*` | OPUS-ARCH | CODEX-OPS for deploy docs |
| `astro.config.*` | OPUS-ARCH | CODEX-OPS for build config |
| `tailwind.config.*` | OPUS-ARCH + GEMINI-UX | Consensus |
| `package.json` | OPUS-ARCH | CODEX-OPS for scripts |

---

## 8. Artifact Standards

### 8.1 Commit Messages
```
[AGENT-ID] phase-N: description

Examples:
[OPUS-ARCH] phase-1: scaffold Astro project with TypeScript
[CODEX-OPS] phase-7: add preflight SSH validation script
[GEMINI-UX] phase-2: implement Hero component with parallax
```

### 8.2 File Headers
Every new file MUST include:
```
/**
 * @file filename.ext
 * @description Brief description
 * @author AGENT-ID
 * @phase N
 * @created YYYY-MM-DDTHH:MM:SSZ
 * @modified YYYY-MM-DDTHH:MM:SSZ
 */
```

### 8.3 Documentation Standard
- All docs in Markdown
- Mermaid diagrams for architecture
- Tables for structured data
- Code blocks with language tags
- Links to related files

---

## 9. Conflict Resolution Process

1. **Identify** — Agent raises concern in CHECKIN-LOG.md
2. **Discuss** — Relevant owners exchange proposals (max 2 rounds)
3. **Decide** — Resolution owner decides (per Escalation Matrix)
4. **Log** — Decision recorded in CHECKIN-LOG.md with rationale
5. **Escalate** — If unresolved after 2 rounds → User arbitration

---

## 10. Contract Violations

If an agent violates this contract:

1. **First violation:** Warning logged in CHECKIN-LOG.md
2. **Second violation:** Task reverted, re-assigned
3. **Pattern of violations:** Agent role restricted

Violations include:
- Deploying without backup
- Changing architecture without review
- Skipping check-in logs
- Ignoring quality gates
- Overriding another agent's domain without consent

---

## Signatures

| Agent | Acknowledgment | Timestamp |
|-------|---------------|-----------|
| OPUS-ARCH | ✅ Contract acknowledged | 2026-05-17T23:15:00Z |
| CODEX-OPS | ✅ Contract acknowledged | 2026-05-17T23:49:26Z |
| GEMINI-UX | ✅ Contract acknowledged | 2026-05-17T20:49:00Z |

---

*Contract v1.0 — Effective immediately upon agent first check-in*
*Any amendments require OPUS-ARCH proposal + User approval*
