<!--
  @file BACKUP-STRATEGY.md
  @description Backup and rollback strategy for HostGator deploys.
  @author CODEX-OPS
  @phase 8
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
-->

# Backup Strategy

ADR-003 define que nenhum deploy de produção deve acontecer sem backup remoto prévio. O script `hostgator-deploy.ps1` chama `hostgator-backup.ps1` antes do upload por `rsync`.

## Escopo

- Origem do backup: `DEPLOY_PATH`, normalmente `/home2/cri07713/public_html`.
- Formato: `backup_YYYYMMDD_HHMMSS.tar.gz`.
- Local: o arquivo é criado dentro do webroot remoto.
- Exclusão: arquivos `backup_*.tar.gz` não entram em novos backups.

## Backup Manual

```powershell
cd site
.\scripts\hostgator-backup.ps1
```

O script executa remotamente:

```bash
tar --exclude='backup_*.tar.gz' -czf backup_<timestamp>.tar.gz .
```

Depois confirma com `ls -la` e aplica rotação.

## Rotação

A política mantém os 3 backups mais recentes:

```bash
ls -1t backup_*.tar.gz | tail -n +4 | xargs -r rm -f
```

Isso evita crescimento indefinido no HostGator compartilhado.

## Rollback

Restaurar o backup mais recente:

```powershell
.\scripts\hostgator-rollback.ps1
```

Restaurar um backup específico:

```powershell
.\scripts\hostgator-rollback.ps1 -BackupFile backup_20260518_002630.tar.gz
```

O rollback lista backups disponíveis, remove o conteúdo atual exceto arquivos `backup_*.tar.gz`, extrai o `.tar.gz` escolhido e valida `https://www.colegiovillaprime.com.br` com HTTP 200.

## Cuidados

- Não apague backups manualmente antes de confirmar que o deploy atual está estável.
- Nunca rode deploy direto por `rsync` sem backup.
- Não use `chmod 777` para corrigir permissões; ajuste dono/permissão via cPanel ou suporte HostGator.
