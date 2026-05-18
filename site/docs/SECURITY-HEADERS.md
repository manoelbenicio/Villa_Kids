<!--
  @file SECURITY-HEADERS.md
  @description Explanation and validation guide for Apache security headers.
  @author CODEX-OPS
  @phase 8
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
-->

# Security Headers

Fonte: `site/public/.htaccess`.

## Headers Ativos

| Header | Valor | Motivo |
|---|---|---|
| `X-Content-Type-Options` | `nosniff` | Impede que o navegador tente adivinhar MIME type e reduza risco de execução indevida. |
| `X-Frame-Options` | `SAMEORIGIN` | Reduz risco de clickjacking ao permitir iframe apenas na mesma origem. |
| `X-XSS-Protection` | `1; mode=block` | Header legado para navegadores antigos; navegadores modernos usam CSP. |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Envia referrer completo só na mesma origem e reduz vazamento de URL para terceiros. |
| `Permissions-Policy` | `camera=(), microphone=(), geolocation=()` | Bloqueia APIs sensíveis que o site institucional não usa. |

## CSP

Ainda não há `Content-Security-Policy` no `.htaccess`. Recomendação para fase de hardening final:

```apache
Header set Content-Security-Policy "default-src 'self'; img-src 'self' data: https:; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; script-src 'self'; connect-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self'"
```

Antes de ativar, testar fontes, scripts Astro e qualquer integração externa.

## HSTS

Ainda não há `Strict-Transport-Security`. Após confirmar HTTPS estável em produção:

```apache
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

Não ative `preload` sem validação de domínio e subdomínios.

## HTTPS e www

O `.htaccess` força HTTPS e adiciona `www`:

```apache
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
RewriteCond %{HTTP_HOST} !^www\. [NC]
RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]
```

## Como Testar

- `https://securityheaders.com`
- `curl -I https://www.colegiovillaprime.com.br`
- DevTools -> Network -> documento HTML -> Response Headers

Meta mínima antes de launch: headers atuais presentes, redirect HTTPS funcionando e ausência de erro 500 no Apache.
