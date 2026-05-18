<!--
  @file BACKUP-STRATEGY.md
  @description Backup and rollback strategy for HostGator deploys — v2 dual-layer.
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:16:32Z
-->

# Backup Strategy — v2 Dual-Layer

ADR-003 define que nenhum deploy deve acontecer sem backup prévio. O pipeline v2 usa **duas camadas** de proteção:

## Camada 1: Versões `*_OLD_*` (Rollback Instantâneo)

Cada atomic switch preserva a versão anterior como:
```
/home2/cri07713/public_html_OLD_<unix_timestamp>
```

**Política de rotação:** Últimas 3 versões mantidas. Versões mais antigas são removidas automaticamente pelo `hostgator-atomic-switch.ps1`.

**Rollback:** `hostgator-rollback-fast.ps1` — executa `mv` reverso em <2s.

### Estrutura no servidor

```
/home2/cri07713/
├── public_html/              ← versão LIVE atual
├── public_html_OLD_1716012345/  ← versão anterior (rollback-fast)
├── public_html_OLD_1716011000/  ← 2 deploys atrás
├── public_html_OLD_1716010000/  ← 3 deploys atrás (mais antiga mantida)
└── backups/
    ├── backup_20260518_120000.tar.gz  ← mais recente
    ├── backup_20260518_100000.tar.gz
    ├── backup_20260517_180000.tar.gz
    ├── backup_20260517_120000.tar.gz
    └── backup_20260516_180000.tar.gz  ← mais antigo (5º)
```

## Camada 2: Backups tar.gz (Rollback de Emergência)

Antes de cada deploy, `hostgator-backup.ps1` cria:
```
~/backups/backup_YYYYMMDD_HHMMSS.tar.gz
```

**Política de rotação:** Últimos 5 backups mantidos. Mais antigos são removidos automaticamente.

**Rollback:** `hostgator-rollback-tar.ps1` — extrai tar.gz (~30s, com downtime).

## Quando usar cada camada

| Cenário | Camada | Script | Tempo |
|---------|--------|--------|-------|
| Deploy recente com bug | 1 (OLD) | `hostgator-rollback-fast.ps1` | <2s |
| Rollback-fast falhou | 2 (tar.gz) | `hostgator-rollback-tar.ps1` | ~30s |
| Corrupção de filesystem | 2 (tar.gz) | `hostgator-rollback-tar.ps1` | ~30s |
| Versão OLD já foi rotacionada | 2 (tar.gz) | `hostgator-rollback-tar.ps1` | ~30s |

## Backup Manual

```powershell
cd site/scripts
.\hostgator-backup.ps1
```

## Verificar Backups Disponíveis

```bash
# Via SSH direto
ssh -p 22 cri07713@host "ls -lht ~/backups/backup_*.tar.gz"
ssh -p 22 cri07713@host "ls -1dt /home2/cri07713/public_html_OLD_*"
```

## Cuidados

- Não apague versões `*_OLD_*` manualmente antes de confirmar estabilidade do deploy
- Não apague backups tar.gz sem ter ao menos 1 versão OLD disponível
- Nunca rode deploy sem backup (o orquestrador v2 faz isso automaticamente)
- Não use `chmod 777` — ajuste permissões via cPanel
- Versões `*_FAILED_*` são criadas pelo rollback-fast e podem ser removidas após investigação
