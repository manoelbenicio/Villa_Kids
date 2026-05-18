# Accessibility Report — WCAG 2.1 AA

Generated: 2026-05-18T04:03:01.450Z
Target: localhost preview at http://localhost:4321.

## Verdict

PASSED. axe critical=0 and serious=0 on all 9 routes after remediation. Lighthouse accessibility minimum is 95.

## Automated Results

| Route | Violations | Critical | Serious | Incomplete |
|---|---:|---:|---:|---:|
| / | 0 | 0 | 0 | 1 |
| /proposta-pedagogica/ | 0 | 0 | 0 | 1 |
| /turmas/ | 0 | 0 | 0 | 1 |
| /estrutura/ | 0 | 0 | 0 | 1 |
| /tecnologia/ | 0 | 0 | 0 | 1 |
| /seguranca/ | 0 | 0 | 0 | 2 |
| /contato/ | 0 | 0 | 0 | 1 |
| /matriculas/ | 0 | 0 | 0 | 2 |
| /politica-de-privacidade/ | 0 | 0 | 0 | 1 |

## Manual/Structural Checks

- One h1 per page: PASS.
- Landmarks main/header/nav/footer: PASS.
- Image alt text: PASS by axe and DOM checks.
- Form labels and aria: PASS by axe.
- Focus-visible styling and skip link: PASS by CSS/static inspection.
- Route status: PASS, all 9 routes returned HTTP 200 in Playwright smoke.

## Fixes Applied

- Added valid role to testimonial rating groups using aria-label.
- Increased contrast for gold pills, purple eyebrows, stat values, and dark-section card text.
