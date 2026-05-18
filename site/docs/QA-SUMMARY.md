# QA Summary — Sprint Final Wave P3 + P3.5

Generated: 2026-05-18T04:03:01.450Z
Status: PASSED_WITH_CLIENT_DATA_NOTE

## Gate Summary

| Gate | Target | Result | Status |
|---|---:|---:|---|
| Lighthouse Performance | >= 90 all pages/devices | min 91 | PASS |
| Lighthouse Accessibility | >= 95 all pages/devices | min 95 | PASS |
| Lighthouse Best Practices | >= 95 all pages/devices | min 100 | PASS |
| Lighthouse SEO | >= 95 all pages/devices | min 100 | PASS |
| axe critical | 0 on 9/9 routes | 0 | PASS |
| axe serious | 0 on 9/9 routes | 0 | PASS |
| E2E route smoke | 9 routes HTTP 200, console clean | 9/9 passed | PASS |
| Schema JSON-LD parse | valid on all pages | valid | PASS |
| Bundle transfer budget | <= 500 KB compressed HTML+CSS+JS | 217.6 KB | PASS |
| Static build | 9 pages, no errors | PASS | PASS |

## Issues

- ALTO: Official local NAP data is still required before production SEO is final. The repo contains placeholder address/phone/ZIP/coordinates. No credentials or production calls were used.
- BAIXO: Raw aggregate HTML+CSS+JS is 594.6 KB; compressed transfer budget is 217.6 KB and passes.
- BAIXO: Lighthouse on Windows may emit Chrome temp cleanup EPERM after writing JSON. Evidence files are valid and parsed.

## Evidence

- docs/lighthouse-raw/: 18 Lighthouse JSON files.
- docs/a11y-raw/: axe JSON files for 9 routes.
- docs/E2E-EVIDENCE/: Playwright smoke specs, JSON, and screenshots.
- docs/LIGHTHOUSE-REPORT.md
- docs/BUNDLE-REPORT.md
- docs/ACCESSIBILITY-REPORT.md
- docs/SEO-REPORT.md
- docs/DEPLOY-RUNBOOK.md
- docs/PIPELINE-V2-DRY-RUN-REPORT.md
- docs/BUILD-OPT-REPORT.md

## P4 Handoff

Ready for deploy preparation after user provides SSH credentials and confirms official NAP data. Do not run P4 without explicit GO.
