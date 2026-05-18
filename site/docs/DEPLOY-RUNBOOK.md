<!--
  @file DEPLOY-RUNBOOK.md
  @description Deploy-day runbook for the HostGator atomic staged pipeline.
  @author CODEX-OPS
  @phase 7
  @created 2026-05-18T03:45:48Z
  @modified 2026-05-18T03:45:48Z
-->

# Deploy Runbook

Target pipeline: `site/scripts/hostgator-deploy-v2.ps1`.

Target domain: `https://www.colegiovillaprime.com.br`.

Remote path must be confirmed from `site/.env.deploy.local` before deploy. Do not commit or print credentials.

## 1. Pre-flight Checklist

| Check | Gate |
|---|---:|
| Phase 6.B QA summary is `PASSED` for Lighthouse, accessibility, SEO, E2E, and security. | GO/NO-GO |
| `site/docs/SEO-REPORT.md` has no blocking SEO/schema/NAP failures. | GO/NO-GO |
| `site/.env.deploy.local` exists, is gitignored, and contains `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_PATH`, `DEPLOY_PORT`, optional `DEPLOY_DOMAIN`. | GO/NO-GO |
| SSH key is configured and `ssh user@host echo OK` works without an interactive password prompt. | GO/NO-GO |
| Remote deploy path has at least 500 MB free. | GO/NO-GO |
| `ssh`, `rsync`, `npm`, and `curl.exe` are available on PATH. | GO/NO-GO |
| Clean build succeeds and produces 9 routes plus sitemap and robots. | GO/NO-GO |
| Backup script has completed and produced a non-empty tarball. | GO/NO-GO |
| Rollback script has been parser-checked and previous `public_html_OLD_*` retention is understood. | GO/NO-GO |

## 2. Ideal Deploy Window

Use a low-traffic weekday window after school inquiry traffic drops, ideally 20:00-22:00 America/Sao_Paulo.

Reserve 30 minutes even though the expected deploy takes under 5 minutes. The extra time is for preflight, stakeholder confirmation, smoke checks, and rollback if needed.

Do not deploy during active enrollment campaign pushes, paid media launches, DNS changes, or while credentials are being rotated.

## 3. Step-by-step Commands

Run commands from a local terminal in the workspace.

```powershell
cd d:\VMs\Projetos\Web_Devlop_EscolaVillaKids\site
npm run build
```

Confirm generated routes:

```powershell
Get-ChildItem .\dist -Recurse -Filter index.html
Test-Path .\dist\sitemap-index.xml
Test-Path .\dist\robots.txt
```

Parser check:

```powershell
Get-ChildItem .\scripts\hostgator-*.ps1 | ForEach-Object {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
  [pscustomobject]@{ Script = $_.Name; ParseErrors = $errors.Count }
}
```

Dry-run without touching production:

```powershell
cd .\scripts
.\hostgator-deploy-v2.ps1 -DryRun -SkipPreflight -SkipBackup
```

Important: plain `.\hostgator-deploy-v2.ps1 -DryRun` still starts the real preflight job, which attempts SSH. Use `-SkipPreflight -SkipBackup` when the intent is a local-only dry run.

Deploy day production sequence:

```powershell
cd d:\VMs\Projetos\Web_Devlop_EscolaVillaKids\site\scripts
.\hostgator-preflight.ps1
.\hostgator-backup.ps1
.\hostgator-deploy-v2.ps1
```

Post-switch smoke:

```powershell
.\hostgator-smoke-parallel.ps1
```

Emergency rollback:

```powershell
.\hostgator-rollback-fast.ps1
```

Tarball rollback only if fast rollback fails:

```powershell
.\hostgator-rollback-tar.ps1
```

## 4. Go/No-go Gates

| Gate | GO | NO-GO |
|---|---|---|
| QA | All blocking gates pass. | Any blocking QA, SEO, accessibility, or E2E gate fails. |
| Build | `npm run build` exits 0 and emits 9 pages. | Build errors, missing route, missing sitemap, or missing robots. |
| Preflight | SSH, env, commands, dist, and remote disk pass. | Missing command, failed SSH, invalid env, or low disk. |
| Backup | Remote tarball exists, size > 0, rotation applied. | Backup fails or cannot be verified. |
| Rsync staged | 4 jobs exit 0 and staged `index.html` is verified. | Any rsync job fails or staged verification fails. |
| Atomic switch | Switch returns success and production is reachable. | Switch partially fails or result cannot be verified. |
| Smoke | 9 production routes return 200 and include `<title>`. | Any critical route returns non-200 or blank/incorrect HTML. |
| Rollback readiness | Previous version remains available for `rollback-fast`. | No known rollback target exists. |

Current status from this dry-run audit: NO-GO until SEO/schema/NAP blockers in `SEO-REPORT.md` are resolved.

## 5. Communication Plan

Before deploy:

- Confirm deploy window, domain, and remote path with the project owner.
- Announce expected start time, expected end time, and rollback threshold.
- Confirm no one else is deploying or editing HostGator files manually.

During deploy:

- Announce preflight start.
- Announce backup completion.
- Announce atomic switch start and completion.
- Announce smoke result.

After deploy:

- Send final status with production URL, smoke result, rollback status, and known follow-up items.
- If rollback occurs, state the failed gate, rollback command used, and whether the previous version is confirmed live.

## 6. NEVER DO

- Never deploy without a verified backup.
- Never rsync directly into `public_html`; use the staged directory and atomic switch.
- Never run production deploy with placeholder NAP/contact data.
- Never paste `.env.deploy.local`, SSH keys, host credentials, or full sensitive remote paths into public docs or chat.
- Never ignore a failed smoke test.
- Never continue after a partial atomic switch without either fixing the switch state or rolling back.
- Never use tarball rollback first when fast rollback is available.
- Never declare deploy complete before 9-route smoke passes.

## 7. Post-deploy

Validate:

```powershell
.\hostgator-smoke-parallel.ps1
```

Manual checks:

- Open `/`, `/matriculas/`, and `/contato/` on production HTTPS.
- Confirm header navigation, footer links, WhatsApp CTA, `tel:` link, forms, sitemap, and robots.
- Confirm no browser console errors on critical routes.
- Confirm HTTPS certificate is valid and HTTP redirects to HTTPS.

Evidence to save:

- Preflight log.
- Backup log.
- Deploy command output.
- Smoke output.
- Lighthouse production spot checks for `/`, `/matriculas/`, `/contato/` if time allows.

Closeout:

- Keep rollback target until production is verified stable.
- Record final deploy status, timestamp, and evidence paths in the project check-in log only when the deployment actually happens.
