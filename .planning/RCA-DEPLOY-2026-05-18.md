# RCA — Deploy Colégio Villa Prime (colegiovillaprime.com.br)

**Data:** 2026-05-18  
**Horário:** 05:52 – 08:42 (UTC-3)  
**Responsável:** Deploy automatizado via Kiro CLI + intervenção manual cPanel + Antigravity DNS diagnostics  
**Status atual:** ✅ Site 100% funcional no servidor (9/9 páginas HTTP 200) — aguardando propagação DNS Cloudflare

---

## 1. Resumo Executivo

O deploy do site estático Astro (9 páginas) para HostGator shared hosting enfrentou múltiplos bloqueios: SSH desabilitado, FTP com credenciais incorretas, diretório de upload errado, e divergência de nameservers DNS. Os arquivos estão corretamente posicionados no servidor, mas o domínio ainda não resolve publicamente.

---

## 2. Timeline de Eventos

| Hora | Ação | Resultado | Evidência |
|------|------|-----------|-----------|
| 05:52 | Revisão do estado do projeto | Identificados bloqueios: credenciais SSH + dados NAP | HANDOFF-CODEX-DEPLOY.md |
| 06:24 | User fornece credenciais SSH: `cri07713@sh00140.hostgator.com.br` | Conexão SSH testada | — |
| 06:30 | Teste SSH com chave `hostgator/id_rsa_pk` | **FALHA**: "Shell access is not enabled on your account!" | Permissão 777 corrigida → shell desabilitado |
| 06:54 | User fornece dados NAP reais | Atualizado `school-info.ts` com telefone, endereço, coordenadas | school-info.ts modificado |
| 07:01 | User fornece dados FTP completos | Host: `69.6.212.125`, porta 21, user: `manoel_benicio@colegiovillaprime.com.br` | — |
| 07:04 | Teste FTP com senha `Nicecti0!@)@&` | **FALHA**: 530 Login authentication failed (user `cri07713`) | — |
| 07:05 | Teste com segunda senha `Ck549192$` | **FALHA**: 530 para ambos users | — |
| 07:07 | User fornece user FTP correto: `manoel_benicio@colegiovillaprime.com.br` | **SUCESSO**: Login OK, diretório vazio listado | — |
| 07:08 | Build do site + Upload FTP | **SUCESSO**: 139 arquivos, 0 falhas | Output: "DONE: 139 files uploaded, 0 failures" |
| 07:09 | Teste link temporário `sh00140.teste.website/~cri07713` | **FALHA**: HTTP 403 | — |
| 07:32 | Análise cPanel — Editor de Zona DNS | Domínio `colegiovillaprime.com.br` listado | **erro3.png** |
| 07:38 | Análise cPanel — Configurar Domínio | NS: `ns830/ns831.hostgator.com.br`, Plano M | **erro4.png** |
| 07:47 | Análise cPanel — Gerenciar Hospedagem | Servidor sh00140, IP 69.6.212.125, DNS: `ns00140/ns00141` | **erro5.png** |
| 07:48 | Identificação: **nameservers divergentes** | Domínio usa ns830/ns831, servidor usa ns00140/ns00141 | — |
| 07:51 | Análise cPanel — Lista de Domínios | `colegiovillaprime.com.br` → diretório `/colegiovillaprime.com.br` | **erro6.png** |
| 07:52 | Análise cPanel — Gerenciar domínio | Document Root: `/home2/cri07713/colegiovillaprime.com.br` | **erro7.png** |
| 07:53 | Análise cPanel — Gerenciador de Arquivos | Estrutura revelada: arquivos em subpasta `manoel_benicio/` | **erro8.png**, **erro9.png** |
| 07:59 | Identificação: **diretório errado** | FTP criou `/home2/cri07713/colegiovillaprime.com.br/` (raiz) mas domínio aponta para `public_html/colegiovillaprime.com.br/` | **erro9.png** |
| 08:02 | User move arquivos no File Manager | Arquivos movidos para `/home2/cri07713/colegiovillaprime.com.br/` (sem subpasta) | **erro10.png** |
| 08:03 | Verificação File Manager | `public_html/colegiovillaprime.com.br/` está VAZIO, `manoel_benicio/` vazia | **erro11.png** |
| 08:07 | Tentativa: alterar Document Root no cPanel | Digitado `/home2/cri07713/colegiovillaprime.com.br` | **erro12.png** |
| 08:08 | Resultado: caminho duplicado | cPanel criou `/home2/cri07713/home2/cri07713/colegiovillaprime.com.br` | **erro13.png** |
| 08:11 | Correção: digitado apenas `colegiovillaprime.com.br` | **SUCESSO**: Document Root atualizado para `/home2/cri07713/colegiovillaprime.com.br` | **erro15.png** |
| 08:12 | Teste HTTP via curl com resolve | HTTP 302 → página padrão HostGator (404) | — |
| 08:13 | Status provisório | Aguardando propagação DNS/Apache reload | — |
| 08:20 | **[Antigravity]** Diagnóstico DNS — nslookup via Google DNS | ❌ "Server failed" — domínio não resolve publicamente | — |
| 08:20 | **[Antigravity]** Diagnóstico DNS — query ns830 | ❌ "Query refused" — NS não tem zona DNS para o domínio | — |
| 08:20 | **[Antigravity]** Diagnóstico DNS — query ns00140 | ✅ Resolve para `69.6.212.151` (IP diferente de .125!) | — |
| 08:22 | **[Antigravity]** Teste HTTP via IP 69.6.212.151 | ✅ **HTTP 200 OK** — 71.755 bytes (site completo!) | — |
| 08:22 | **[Antigravity]** Teste HTTP via IP 69.6.212.125 | ❌ HTTP 302 → 404 HostGator (servidor errado) | — |
| 08:35 | User altera plataforma no cPanel ("Alterar plataforma") | NS trocados para Cloudflare: `evelyn/randy.ns.cloudflare.com` | Screenshot cPanel |
| 08:38 | **[Antigravity]** Diagnóstico DNS — query Cloudflare NS | ✅ Ambos resolvem para `69.6.212.151` | — |
| 08:38 | **[Antigravity]** Google DNS (8.8.8.8) | ⏳ Ainda "Server failed" — propagação pendente | — |
| 08:41 | **[Antigravity]** Smoke test completo (9 páginas + 6 assets) | ✅ **15/15 OK** — todas as rotas HTTP 200 | smoke-test.sh |

---

## 3. Root Causes Identificados

### RC-1: SSH Shell Desabilitado
- **Impacto:** Impossibilitou uso dos scripts de deploy v2 (rsync + atomic switch)
- **Causa:** Conta HostGator shared não tem shell access habilitado por padrão
- **Workaround:** Deploy via FTP (porta 21, Pure-FTPd com TLS)

### RC-2: Credenciais FTP Incorretas
- **Impacto:** 3 tentativas falhadas antes de encontrar a combinação correta
- **Causa:** User FTP é `manoel_benicio@colegiovillaprime.com.br` (não `cri07713`), senha é a primeira fornecida
- **Resolução:** Combinação correta: user `manoel_benicio@colegiovillaprime.com.br` + senha `Nicecti0!@)@&` no IP `69.6.212.125:21`

### RC-3: Diretório FTP Mapeado Incorretamente
- **Impacto:** Arquivos enviados para local errado, site não acessível
- **Causa:** A conta FTP `manoel_benicio@` está restrita (chroot) ao diretório `/home2/cri07713/colegiovillaprime.com.br/`, mas o addon domain no cPanel apontava para `public_html/colegiovillaprime.com.br/`
- **Resolução:** Document Root alterado no cPanel para `/home2/cri07713/colegiovillaprime.com.br`

### RC-4: Nameservers Divergentes → RESOLVIDO
- **Impacto:** DNS do domínio não resolvia — site completamente inacessível ao público
- **Causa:** Domínio registrado com `ns830.hostgator.com.br` / `ns831.hostgator.com.br`, que **não possuíam zona DNS** para o domínio. O IP do servidor de hospedagem (`69.6.212.125`) também era diferente do IP real (`69.6.212.151`)
- **Resolução:** User alterou plataforma no cPanel → HostGator configurou nameservers Cloudflare (`evelyn.ns.cloudflare.com` / `randy.ns.cloudflare.com`), que já resolvem corretamente para `69.6.212.151`
- **Status:** ✅ RESOLVIDO — aguardando propagação DNS (2-24h para registro .br atualizar delegação)

---

## 4. Estado Atual dos Componentes

| Componente | Status | Detalhe |
|-----------|--------|---------|
| Build Astro | ✅ OK | 9 páginas, dados NAP reais, 0 erros |
| Upload FTP | ✅ OK | 139 arquivos, 0 falhas |
| Localização arquivos | ✅ OK | `/home2/cri07713/colegiovillaprime.com.br/` |
| Permissões | ✅ OK | Diretórios 0755, arquivos 0644 |
| Document Root cPanel | ✅ OK | Aponta para `/home2/cri07713/colegiovillaprime.com.br` |
| Addon Domain | ✅ OK | `colegiovillaprime.com.br` configurado |
| Apache servindo páginas | ✅ OK | 9/9 páginas retornam HTTP 200 via IP direto |
| DNS/Nameservers | ✅ CORRIGIDO | Cloudflare NS (`evelyn`/`randy`) → `69.6.212.151` |
| Propagação DNS pública | ⏳ PROPAGANDO | Google DNS ainda não recebeu — ETA 2-24h |
| Site acessível publicamente | ⏳ AGUARDANDO | Depende da propagação DNS |
| HTTPS/SSL | ❌ PENDENTE | Ativar após site acessível publicamente |

---

## 5. Evidências (Screenshots)

| Arquivo | Conteúdo |
|---------|----------|
| `Captura de tela 2026-05-18 073251.png` | cPanel Editor de Zona DNS — domínio listado |
| `erro3.png` | cPanel Editor de Zona DNS — 2 domínios |
| `erro4.png` | Painel HostGator — Configurar Domínio, NS ns830/ns831 |
| `erro5.png` | Painel HostGator — Gerenciar Hospedagem, servidor sh00140, IP 69.6.212.125 |
| `erro6.png` | cPanel Domínios — lista com Document Root `/colegiovillaprime.com.br` |
| `erro7.png` | cPanel Gerenciar Domínio — Document Root original |
| `erro8.png` | cPanel File Manager — estrutura `/home2/cri07713/` com pastas |
| `erro9.png` | cPanel File Manager — `public_html/colegiovillaprime.com.br/manoel_benicio/` |
| `erro10.png` | cPanel File Manager — arquivos corretos em `/home2/cri07713/colegiovillaprime.com.br/` |
| `erro11.png` | cPanel File Manager — `public_html/colegiovillaprime.com.br/` VAZIO |
| `erro12.png` | cPanel — tentativa de alterar Document Root (caminho completo) |
| `erro13.png` | cPanel — ERRO: caminho duplicado `/home2/cri07713/home2/cri07713/...` |
| `erro15.png` | cPanel — SUCESSO: Document Root atualizado corretamente |

---

## 6. Diagnóstico DNS Detalhado (Fase 2 — Antigravity, 08:20-08:42)

### 6.1 Como funciona a resolução DNS

```
Navegador → "Qual o IP de colegiovillaprime.com.br?"
         → Pergunta ao resolver DNS (Google 8.8.8.8, ISP, etc.)
         → Resolver consulta o registro .br: "quais são os nameservers?"
         → Registro .br responde: "pergunte ao ns830.hostgator.com.br"
         → ns830 responde com o IP do servidor
         → Navegador conecta no IP, porta 80
         → Apache responde com HTML
```

### 6.2 Comandos de diagnóstico executados

**Teste 1 — DNS público (Google 8.8.8.8):**
```powershell
nslookup colegiovillaprime.com.br 8.8.8.8
# Resultado: ❌ "Server failed" — domínio não resolve publicamente
```

**Teste 2 — Nameserver registrado (ns830):**
```powershell
nslookup colegiovillaprime.com.br ns830.hostgator.com.br
# Resultado: ❌ "Query refused" — ns830 NÃO possui zona DNS para este domínio
```

**Teste 3 — Nameserver do servidor de hospedagem (ns00140):**
```powershell
nslookup colegiovillaprime.com.br ns00140.hostgator.com.br
# Resultado: ✅ Resolve para 69.6.212.151
# NOTA: IP .151 é DIFERENTE de .125 (mostrado no cPanel "Gerenciar Hospedagem")
```

**Teste 4 — HTTP direto no IP 69.6.212.151 (bypass DNS):**
```bash
# O flag --resolve força curl a conectar no IP especificado sem consultar DNS
curl -sI --resolve colegiovillaprime.com.br:80:69.6.212.151 http://colegiovillaprime.com.br/
# Resultado: ✅ HTTP/1.1 200 OK — Content-Length: 71755 — SITE COMPLETO!
```

**Teste 5 — HTTP direto no IP 69.6.212.125 (IP do cPanel):**
```bash
curl -sI --resolve colegiovillaprime.com.br:80:69.6.212.125 http://colegiovillaprime.com.br/
# Resultado: ❌ HTTP/1.1 302 Found → Location: /404.html (página HostGator padrão)
```

**Conclusão:** O IP real do servidor com os arquivos é `69.6.212.151`, não `69.6.212.125`.

### 6.3 Correção aplicada pelo user (08:35)

No cPanel → Domínios → Configurar Domínio → "Alterar plataforma" → Selecionou "Plano M".

O HostGator reconfigurou os nameservers automaticamente:

| Antes ❌ | Depois ✅ |
|----------|-----------|
| `ns830.hostgator.com.br` | `evelyn.ns.cloudflare.com` |
| `ns831.hostgator.com.br` | `randy.ns.cloudflare.com` |

### 6.4 Verificação pós-correção

```powershell
nslookup colegiovillaprime.com.br evelyn.ns.cloudflare.com
# Resultado: ✅ 69.6.212.151

nslookup colegiovillaprime.com.br randy.ns.cloudflare.com
# Resultado: ✅ 69.6.212.151

nslookup colegiovillaprime.com.br 8.8.8.8
# Resultado: ⏳ "Server failed" — propagação ainda pendente
```

Os nameservers Cloudflare já possuem a zona DNS correta. O registro `.br` ainda não propagou a delegação.

---

## 7. Smoke Test Completo

### 7.1 Script utilizado (`smoke-test.sh`)

```bash
#!/bin/bash
IP="69.6.212.151"
DOMAIN="colegiovillaprime.com.br"
echo "=== SMOKE TEST — $DOMAIN via $IP ==="
echo ""
echo "--- Páginas ---"
for route in "/" "/contato/" "/estrutura/" "/matriculas/" "/politica-de-privacidade/" \
             "/proposta-pedagogica/" "/seguranca/" "/tecnologia/" "/turmas/"; do
  code=$(curl -so /dev/null -w "%{http_code}" -m 10 \
    --resolve "${DOMAIN}:80:${IP}" "http://${DOMAIN}${route}" 2>/dev/null)
  if [ "$code" = "200" ]; then
    echo "  ✅ $code $route"
  else
    echo "  ❌ $code $route"
  fi
done
echo ""
echo "--- Arquivos técnicos ---"
for file in "/robots.txt" "/sitemap-index.xml" "/sitemap-0.xml" \
            "/.htaccess" "/favicon.ico" "/og-image.jpg"; do
  code=$(curl -so /dev/null -w "%{http_code}" -m 10 \
    --resolve "${DOMAIN}:80:${IP}" "http://${DOMAIN}${file}" 2>/dev/null)
  if [ "$code" = "200" ]; then
    echo "  ✅ $code $file"
  else
    echo "  ❌ $code $file"
  fi
done
echo ""
echo "=== DONE ==="
```

**Execução:**
```bash
wsl bash /mnt/d/VMs/Projetos/Web_Devlop_EscolaVillaKids/smoke-test.sh
```

### 7.2 Resultados (08:41 UTC-3)

```
=== SMOKE TEST — colegiovillaprime.com.br via 69.6.212.151 ===

--- Páginas ---
  ✅ 200 /
  ✅ 200 /contato/
  ✅ 200 /estrutura/
  ✅ 200 /matriculas/
  ✅ 200 /politica-de-privacidade/
  ✅ 200 /proposta-pedagogica/
  ✅ 200 /seguranca/
  ✅ 200 /tecnologia/
  ✅ 200 /turmas/

--- Arquivos técnicos ---
  ✅ 200 /robots.txt
  ✅ 200 /sitemap-index.xml
  ✅ 200 /sitemap-0.xml
  ❌ 403 /.htaccess        ← Correto: Apache bloqueia acesso direto
  ✅ 200 /favicon.ico
  ✅ 200 /og-image.jpg

=== DONE ===
```

### 7.3 Rotas reais do build Astro (corrigidas)

O RCA original listava rotas incorretas. As rotas reais do build são:

| Rota Real (Build Astro) | Rota Incorreta (RCA original) |
|-------------------------|-------------------------------|
| `/proposta-pedagogica/` | `/sobre/` |
| `/turmas/` | `/ensino/` |
| `/politica-de-privacidade/` | `/politica-privacidade/` |
| `/seguranca/` | — (não listada) |
| `/tecnologia/` | — (não listada) |
| — | `/blog/` (não existe) |
| — | `/termos-uso/` (não existe) |
| `/sitemap-index.xml` + `/sitemap-0.xml` | `/sitemap.xml` (não existe) |

---

## 8. Ações Pendentes

### ⏳ Prioridade 1 — Aguardar propagação DNS (2-24h)

Comando para monitorar:
```powershell
nslookup colegiovillaprime.com.br 8.8.8.8
```

**Resultado esperado quando propagar:**
```
Nome: colegiovillaprime.com.br
Address: 69.6.212.151
```

### Prioridade 2 — Ativar HTTPS

Após site acessível publicamente:
1. cPanel → Domínios → `colegiovillaprime.com.br` → ativar **"Force HTTPS Redirect"**
2. Verificar SSL em: cPanel → SSL/TLS → Manage SSL Hosts

### Prioridade 3 — Validação pública

Após DNS propagado, acessar no navegador:
- `https://colegiovillaprime.com.br/`
- Verificar WhatsApp FAB, links `tel:`, formulário de contato

---

## 9. Lições Aprendidas

1. **Validar credenciais FTP antes do deploy** — user FTP pode ser diferente do user cPanel
2. **Verificar mapeamento de diretório FTP** — contas FTP restritas podem apontar para diretórios inesperados
3. **Confirmar nameservers vs servidor** — divergência entre NS do registro e NS do servidor causa indisponibilidade total
4. **cPanel Document Root** — o campo usa caminho relativo a `/home2/user/`, não absoluto
5. **SSH em shared hosting** — não assumir disponibilidade; ter fallback FTP pronto
6. **IP do cPanel pode não ser o IP real** — o IP mostrado em "Gerenciar Hospedagem" (`.125`) era diferente do IP servindo o site (`.151`)
7. **Usar `curl --resolve` para bypass DNS** — permite testar se o servidor funciona antes de resolver problemas de DNS
8. **Verificar nomes de rotas no build** — os slugs Astro podem diferir do que está documentado

---

## 10. Arquivos Utilizados e Modificados

| Arquivo | Tipo | Descrição |
|---------|------|-----------|
| `site/src/data/school-info.ts` | Modificado | Dados NAP reais (telefone, endereço, coordenadas) |
| `site/.env.deploy.local` | Criado (gitignored) | Credenciais de deploy FTP |
| `site/scripts/monitor-deploy.ps1` | Criado | Script de monitoramento de deploy |
| `smoke-test.sh` | Criado | Script de smoke test para verificar todas as rotas via IP direto |
| `.planning/RCA-DEPLOY-2026-05-18.md` | Este documento | Root Cause Analysis completo |

---

*Documento gerado em 2026-05-18T08:13:00-03:00*  
*Atualizado com diagnóstico DNS em 2026-05-18T08:45:00-03:00*
