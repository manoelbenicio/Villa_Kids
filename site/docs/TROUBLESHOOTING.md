<!--
  @file TROUBLESHOOTING.md
  @description Operational troubleshooting guide for build, deploy, and v2 atomic pipeline.
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:16:32Z
-->

# Troubleshooting

## Build Falha

```powershell
cd site
npm run build
```

Verifique:
- Dependências instaladas com `npm install`
- Erros de TypeScript/Astro apontados no terminal
- Imports quebrados em `src/components`, `src/data` ou `src/pages`
- Layouts usando props obrigatórias sem valor

## SSH Timeout ou Connection Refused

Verifique:
- `DEPLOY_HOST` e `DEPLOY_PORT` em `site/.env.deploy.local`
- SSH habilitado no cPanel/HostGator
- Chave pública cadastrada para o usuário `DEPLOY_USER`
- Primeiro acesso manual: `ssh -p 22 cri07713@host`

## rsync Permission Denied

Verifique:
- `DEPLOY_PATH=/home2/cri07713/public_html`
- Permissão de escrita do usuário SSH no webroot
- `rsync` disponível localmente
- Quota de disco não excedida

## 404 Após Deploy

Verifique:
- `dist/index.html` existe
- `astro.config.mjs` usa `output: 'static'` e `build.format = 'directory'`
- rsync enviou para conteúdo de `public_html`, não `public_html/dist`
- `.htaccess` publicado corretamente

## Cache Stale

Verifique:
- Hard refresh no navegador (Ctrl+Shift+R)
- Teste com aba anônima
- Arquivos `_astro/` têm nomes versionados (cache-busting automático)

## .htaccess Syntax Error (HTTP 500)

Verifique:
- `Header` requer `mod_headers`
- `ExpiresByType` requer `mod_expires`
- `Rewrite*` requer `mod_rewrite`
- Remova blocos recentes e valide incrementalmente

---

## Cenários v2 — Atomic Staged Deploy

### Atomic Switch Falha (mv: cannot move)

**Sintoma:** `hostgator-atomic-switch.ps1` retorna erro no `mv`.

**Causas comuns:**
1. **Permissão insuficiente no parent dir** — o usuário SSH precisa de write no diretório pai (`/home2/cri07713/`)
2. **Staged dir não existe** — rsync-parallel não completou ou falhou silenciosamente
3. **public_html em uso por processo** — raro em shared hosting, mas possível

**Resolução:**
```bash
# Verificar permissões
ssh user@host "ls -la /home2/cri07713/ | grep public"

# Verificar staged dir existe
ssh user@host "ls -la /home2/cri07713/public_html_new/index.html"

# Se permissão negada no parent dir, contatar suporte HostGator
# O parent dir precisa de permissão 755 para o owner
```

### mv Permission Denied

**Sintoma:** `Permission denied` ao tentar `mv public_html`.

**Causa:** O diretório `public_html` pode ter owner diferente (ex: `nobody:nobody` após restore do cPanel).

**Resolução:**
1. Verificar owner: `ssh user@host "ls -la /home2/cri07713/ | grep public_html"`
2. Se owner incorreto, usar cPanel File Manager para corrigir
3. Ou contatar suporte HostGator para `chown cri07713:cri07713 public_html`

### Staged Dir Órfão (public_html_new existe após falha)

**Sintoma:** Deploy anterior falhou e `public_html_new` ficou no servidor.

**Resolução:**
```bash
# Verificar conteúdo
ssh user@host "ls /home2/cri07713/public_html_new/"

# Se for lixo de deploy anterior, remover
ssh user@host "rm -rf /home2/cri07713/public_html_new"

# Re-executar deploy
.\hostgator-deploy-v2.ps1
```

**Nota:** O `hostgator-rsync-parallel.ps1` usa `--delete` no rsync, então um staged dir existente será sobrescrito corretamente no próximo deploy.

### Rollback-Fast Falha (sem versão OLD)

**Sintoma:** `hostgator-rollback-fast.ps1` diz "No OLD version found".

**Causas:**
1. Primeiro deploy v2 (não há versão anterior)
2. Rotação removeu todas as versões OLD (>3 deploys sem rollback)

**Resolução:**
```powershell
# Usar rollback de emergência via tar.gz
.\hostgator-rollback-tar.ps1
```

### Smoke Test Falha Pós-Switch

**Sintoma:** Deploy completou o switch mas smoke retorna HTTP 5xx.

**O que acontece automaticamente:**
- O orquestrador (`hostgator-deploy-v2.ps1`) executa `hostgator-rollback-fast.ps1` automaticamente
- Site volta ao estado anterior em <2s

**Se o rollback automático também falhar:**
```powershell
# Tentar rollback manual
.\hostgator-rollback-fast.ps1

# Se falhar, usar emergência
.\hostgator-rollback-tar.ps1
```

### SSH Cai Durante Deploy

**Cenários:**
1. **Antes do atomic switch** — produção não foi afetada; staged dir pode estar incompleto; re-executar deploy
2. **Durante o atomic switch** — verificar estado:
   ```bash
   ssh user@host "ls -la /home2/cri07713/ | grep public"
   ```
   - Se `public_html` existe e tem `index.html` → switch completou
   - Se `public_html` não existe → `mv` parcial; renomear OLD de volta manualmente
3. **Após o switch** — produção já está com versão nova; executar smoke manualmente

## Fallback: cPanel File Manager

Usar apenas se SSH/rsync estiver completamente indisponível:

1. `npm run build`
2. Compactar conteúdo de `site/dist` (não a pasta `dist`)
3. Upload pelo File Manager para `public_html`
4. Extrair no webroot
5. Confirmar `index.html`, `robots.txt`, `sitemap-index.xml`, `.htaccess`
6. Executar `hostgator-smoke-parallel.ps1` localmente
