# Bundle Report — Phase 6.B

Generated: 2026-05-18T04:03:01.450Z

## Verdict

PASSED for deploy transfer budget: precompressed HTML+CSS+JS is 217.6 KB (target <= 500 KB). Raw HTML+CSS+JS is 594.6 KB and remains an optimization watch item because the site is fully static with 9 HTML documents.

## Size Breakdown

| Group | Size |
|---|---:|
| HTML raw | 474.8 KB |
| CSS raw | 111.6 KB |
| JS raw | 8.2 KB |
| HTML+CSS+JS raw | 594.6 KB |
| HTML+CSS+JS gzip+brotli artifacts | 217.6 KB |
| Images | 59.4 KB |
| Other | 3.4 KB |

## Large Assets >100 KB

- None

## Notes

- Added a reproducible post-build optimizer at scripts/optimize-dist.mjs.
- HTML is minified after Astro build.
- gzip and Brotli artifacts are generated for compressible static files.
- Runtime JS remains small (8.2 KB raw).
