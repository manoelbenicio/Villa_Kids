<!--
  @file PIPELINE-V2-DRY-RUN-REPORT.md
  @description Local dry-run and static validation report for deploy scripts v2.
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T03:45:48Z
  @modified 2026-05-18T03:45:48Z
-->

# Pipeline v2 Dry-run Report

Scope: local validation only. No production credentials were used, no SSH deploy was executed, and no remote production files were changed.

Scripts audited:

1. `hostgator-deploy-v2.ps1`
2. `hostgator-preflight.ps1`
3. `hostgator-backup.ps1`
4. `hostgator-rsync-parallel.ps1`
5. `hostgator-atomic-switch.ps1`
6. `hostgator-smoke-parallel.ps1`
7. `hostgator-rollback-fast.ps1`
8. `hostgator-rollback-tar.ps1`

## Summary

| Gate | Result | Notes |
|---|---:|---|
| PowerShell parser for all 8 scripts | PASS | 0 parse errors in all scripts. |
| PSScriptAnalyzer | NOT RUN | Module is not installed in this environment. |
| Local dry-run behavior | PASS_WITH_RISK | Orchestrator dry run passes with `-SkipPreflight -SkipBackup`. Plain `-DryRun` still starts real SSH preflight. |
| Build inside dry run | PASS | `npm run build` completed and generated 9 pages. |
| No production/credentials used | PASS | Dry-run command skipped preflight and backup; rsync dry-run was not executed because it still performs SSH setup. |

Overall pipeline dry-run gate: PASS_WITH_RISK. The parser and local orchestrator dry run pass, but the dry-run semantics should be tightened before relying on it as a fully safe operator command.

## Parser Results

Command used:

```powershell
Get-ChildItem site/scripts/hostgator-*.ps1 | ForEach-Object {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
  [pscustomobject]@{ Script = $_.Name; ParseErrors = $errors.Count }
}
```

| Script | Parse Errors |
|---|---:|
| `hostgator-atomic-switch.ps1` | 0 |
| `hostgator-backup.ps1` | 0 |
| `hostgator-deploy-v2.ps1` | 0 |
| `hostgator-preflight.ps1` | 0 |
| `hostgator-rollback-fast.ps1` | 0 |
| `hostgator-rollback-tar.ps1` | 0 |
| `hostgator-rsync-parallel.ps1` | 0 |
| `hostgator-smoke-parallel.ps1` | 0 |

## PSScriptAnalyzer

Result: NOT RUN.

`Get-Module -ListAvailable PSScriptAnalyzer` returned no installed module. No attempt was made to install modules during this audit.

Recommended command when available:

```powershell
Invoke-ScriptAnalyzer -Path .\site\scripts -Recurse -Severity Warning,Error
```

## Dry-run Capability Matrix

| Script | Supports `-DryRun` / safe simulation | Executed? | Result / Reason |
|---|---:|---:|---|
| `hostgator-deploy-v2.ps1` | YES | YES | Passed with `-DryRun -SkipPreflight -SkipBackup`. |
| `hostgator-rsync-parallel.ps1` | YES | NO | Not safe as local-only dry run: it loads `.env.deploy.local` and executes remote `ssh mkdir -p` before rsync dry-run. |
| `hostgator-preflight.ps1` | NO | NO | Real SSH and remote disk checks; requires credentials. |
| `hostgator-backup.ps1` | NO | NO | Creates remote backup; production mutation. |
| `hostgator-atomic-switch.ps1` | NO | NO | Mutates remote production symlike directory state via `mv`. |
| `hostgator-smoke-parallel.ps1` | NO | NO | Production HTTP validation; should run only against confirmed target. |
| `hostgator-rollback-fast.ps1` | NO | NO | Mutates remote production directories. |
| `hostgator-rollback-tar.ps1` | NO | NO | Restores remote backup; destructive if used incorrectly. |

## Orchestrator Dry-run Evidence

Command used:

```powershell
cd site/scripts
.\hostgator-deploy-v2.ps1 -DryRun -SkipPreflight -SkipBackup
```

Observed result:

| Stage | Result | Evidence |
|---|---:|---|
| Stage 1 build | PASS | Astro build completed and generated 9 pages. |
| Stage 2 rsync | PASS | Printed intended command only. |
| Stage 3 atomic switch | PASS | Printed intended command only. |
| Stage 4 smoke | PASS | Printed intended command only. |
| Exit code | PASS | Exit code 0. |

Key output:

```text
[DRY-RUN] No remote changes will be made.
[OK] Job 'Build' completed
[build] 9 page(s) built
[DRY-RUN] Would run: hostgator-rsync-parallel.ps1 -StagedDir public_html_new -DryRun
[DRY-RUN] Would run: hostgator-atomic-switch.ps1 -StagedDir public_html_new
[DRY-RUN] Would run: hostgator-smoke-parallel.ps1
Zero-downtime deploy complete.
```

## Findings

| ID | Severity | Finding | Impact | Recommendation |
|---|---|---|---|---|
| PIPE-V2-01 | HIGH | Plain `hostgator-deploy-v2.ps1 -DryRun` still starts `hostgator-preflight.ps1`, which performs real SSH checks. | Operators may assume dry run is credential-free and non-networked. | In `hostgator-deploy-v2.ps1`, skip preflight automatically when `-DryRun` is set or pass a real dry-run mode into preflight. |
| PIPE-V2-02 | HIGH | `hostgator-rsync-parallel.ps1 -DryRun` creates/verifies the remote staged directory before rsync dry-run. | The script can mutate remote state even in dry-run mode. | Move remote `mkdir -p` and final remote verification behind `if (-not $DryRun)`, and print intended actions in dry run. |
| PIPE-V2-03 | MEDIUM | Only 2 of 8 scripts expose dry-run semantics. | Backup, switch, smoke, and rollback cannot be safely simulated from the script interface. | Add `SupportsShouldProcess` or explicit `-DryRun` to mutating scripts. |
| PIPE-V2-04 | LOW | PSScriptAnalyzer is unavailable in the current environment. | Static style/rule checks were not performed. | Install `PSScriptAnalyzer` in the deploy workstation image or CI validation step. |

## Deployment Readiness

Pipeline mechanics are close, but deploy is currently NO-GO because the SEO report has blocking content/schema/NAP failures and the dry-run semantics have two high-risk operator-safety issues.

Minimum before deploy:

1. Resolve SEO/schema/NAP blockers.
2. Confirm Phase 6.B consolidated QA is fully passed.
3. Either patch dry-run semantics or document that local-only dry run must be `-DryRun -SkipPreflight -SkipBackup`.
4. Run `PSScriptAnalyzer` where the module is installed.
5. Execute real preflight and backup only after credentials and deploy window are confirmed.
