<!--
  @file TROUBLESHOOTING.md
  @description Operational troubleshooting guide for build and deploy failures.
  @author CODEX-OPS
  @phase 8
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
-->

# Troubleshooting

## Build Falha

Comando:

```powershell
cd site
npm run build
```

Verifique:

- Dependências instaladas com `npm install`.
- Erros de TypeScript/Astro apontados no terminal.
- Imports quebrados em `src/components`, `src/data` ou `src/pages`.
- Layouts usando props obrigatórias sem valor.

## SSH Timeout ou Connection Refused

Verifique:

- `DEPLOY_HOST` e `DEPLOY_PORT` em `site/.env.deploy.local`.
- SSH habilitado no cPanel/HostGator.
- Chave pública cadastrada para o usuário `DEPLOY_USER`.
- Primeiro acesso manual: `ssh -p 22 cri07713@host`.

## rsync Permission Denied

Verifique:

- `DEPLOY_PATH=/home2/cri07713/public_html`.
- Permissão de escrita do usuário SSH no webroot.
- Se `rsync` está disponível localmente.
- Se o servidor rejeita criação/remoção de arquivos por quota cheia.

## 404 Após Deploy

Verifique:

- Se `dist/index.html` existe.
- Se `astro.config.mjs` usa `output: 'static'` e `build.format = 'directory'`.
- Se o `rsync` enviou `dist/` para o conteúdo de `public_html`, e não para `public_html/dist`.
- Se `.htaccess` foi publicado corretamente.

## Cache Stale

Verifique:

- Faça hard refresh no navegador.
- Teste com aba anônima.
- Limpe cache de CDN/proxy se existir.
- Arquivos CSS/JS e imagens têm cache de 1 ano via `.htaccess`; novos builds devem gerar nomes versionados no `_astro`.

## .htaccess Syntax Error

Sintomas comuns: erro 500 logo após deploy.

Verifique:

- Diretivas `Header` exigem `mod_headers`.
- Diretivas `ExpiresByType` exigem `mod_expires`.
- Diretivas `Rewrite*` exigem `mod_rewrite`.
- Remova temporariamente blocos recentes e valide novamente.

## Fallback: cPanel File Manager

Use apenas se SSH/rsync estiver indisponível:

1. Rode `npm run build`.
2. Compacte o conteúdo de `site/dist`, não a pasta `dist`.
3. Faça upload pelo File Manager para `public_html`.
4. Extraia no webroot.
5. Confirme `index.html`, `robots.txt`, `sitemap-index.xml` e `.htaccess`.
6. Rode `hostgator-validate.ps1` localmente.
