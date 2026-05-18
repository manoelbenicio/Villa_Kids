# Guia de Deploy — Colégio Villa Prime

**Projeto:** Website Colégio Villa Prime  
**URL de Produção:** https://www.colegiovillaprime.com.br  
**Hospedagem:** HostGator (Shared Hosting)  
**Protocolo de Deploy:** FTPS (FTP sobre TLS/SSL)  
**Última atualização:** 18 de maio de 2026

---

## Índice

1. [Visão Geral da Arquitetura](#1-visão-geral-da-arquitetura)
2. [Pré-Requisitos do Ambiente](#2-pré-requisitos-do-ambiente)
3. [Estrutura do Projeto](#3-estrutura-do-projeto)
4. [Onde Fazer Alterações](#4-onde-fazer-alterações)
5. [Fluxo de Deploy — Passo a Passo](#5-fluxo-de-deploy--passo-a-passo)
6. [Como o Script de Deploy Funciona](#6-como-o-script-de-deploy-funciona)
7. [Opções e Parâmetros do Script](#7-opções-e-parâmetros-do-script)
8. [Servidor de Desenvolvimento Local](#8-servidor-de-desenvolvimento-local)
9. [Troubleshooting (Resolução de Problemas)](#9-troubleshooting-resolução-de-problemas)
10. [Segurança e Credenciais](#10-segurança-e-credenciais)
11. [Decisões Técnicas e Justificativas](#11-decisões-técnicas-e-justificativas)

---

## 1. Visão Geral da Arquitetura

O website é construído com **Astro** (framework de geração de sites estáticos) e **Tailwind CSS v4**. Isso significa que o site **não roda código no servidor** — todo o HTML, CSS e JS são pré-gerados localmente e enviados como arquivos prontos para a hospedagem.

```
┌──────────────────────────────────────────────────────────────────┐
│                    FLUXO DE DEPLOY                               │
│                                                                  │
│   ┌──────────┐     ┌──────────┐     ┌───────────┐     ┌──────┐ │
│   │ Editar   │ ──▶ │ Build    │ ──▶ │ Upload    │ ──▶ │ Site │ │
│   │ código   │     │ Astro    │     │ via FTPS  │     │ LIVE │ │
│   │ em src/  │     │ → dist/  │     │ (lftp)    │     │      │ │
│   └──────────┘     └──────────┘     └───────────┘     └──────┘ │
│                                                                  │
│   Máquina Local                  Internet          HostGator     │
└──────────────────────────────────────────────────────────────────┘
```

### Resumo em uma frase

> **Você edita os arquivos em `src/`, roda o script de deploy, e ele compila tudo para HTML estático (`dist/`) e envia automaticamente para o servidor via FTP seguro.**

---

## 2. Pré-Requisitos do Ambiente

Antes de executar o deploy, a máquina do desenvolvedor precisa ter:

| Ferramenta       | Versão Mínima | Verificação                | Notas                                  |
|------------------|---------------|----------------------------|----------------------------------------|
| **Node.js**      | ≥ 22.12.0     | `node --version`           | Runtime JavaScript                     |
| **npm**          | ≥ 10.x        | `npm --version`            | Gerenciador de pacotes (vem com Node)  |
| **WSL**          | WSL 2          | `wsl --version`            | Subsistema Linux no Windows            |
| **lftp**         | ≥ 4.x         | `wsl lftp --version`       | Cliente FTP avançado (roda dentro do WSL) |
| **PowerShell**   | ≥ 5.1         | `$PSVersionTable`          | Shell de execução do script            |

### Instalação do lftp (caso não tenha)

Abra o terminal WSL e execute:

```bash
sudo apt update && sudo apt install -y lftp
```

---

## 3. Estrutura do Projeto

```
Web_Devlop_EscolaVillaKids/
└── site/                          ← RAIZ DO PROJETO WEB
    ├── src/                       ← 🔵 CÓDIGO-FONTE (onde você edita)
    │   ├── components/            ←   Componentes reutilizáveis
    │   │   ├── Header.astro
    │   │   ├── Footer.astro
    │   │   ├── Hero.astro
    │   │   ├── ContactForm.astro
    │   │   ├── Gallery.astro
    │   │   ├── FAQ.astro
    │   │   ├── WhatsAppButton.astro
    │   │   └── ... (16 componentes)
    │   ├── layouts/               ←   Layout base (wrapper de todas as páginas)
    │   │   └── BaseLayout.astro
    │   ├── pages/                 ←   Cada arquivo = uma página do site
    │   │   ├── index.astro                    → /
    │   │   ├── contato.astro                  → /contato/
    │   │   ├── matriculas.astro               → /matriculas/
    │   │   ├── turmas.astro                   → /turmas/
    │   │   ├── estrutura.astro                → /estrutura/
    │   │   ├── proposta-pedagogica.astro       → /proposta-pedagogica/
    │   │   ├── seguranca.astro                → /seguranca/
    │   │   ├── tecnologia.astro               → /tecnologia/
    │   │   └── politica-de-privacidade.astro   → /politica-de-privacidade/
    │   ├── styles/                ←   Estilos globais (Tailwind CSS)
    │   │   └── global.css
    │   ├── scripts/               ←   JavaScript client-side
    │   └── data/                  ←   Dados estáticos (textos, configs)
    │
    ├── public/                    ← Arquivos estáticos (copiados direto)
    │   ├── favicon.ico
    │   ├── favicon.svg
    │   ├── og-image.jpg
    │   ├── robots.txt
    │   ├── .htaccess
    │   └── images/                ←   Imagens do site
    │
    ├── dist/                      ← 🔴 SAÍDA DO BUILD (gerado automaticamente)
    │                                 NÃO EDITE esta pasta manualmente!
    │
    ├── scripts/                   ← Scripts de automação
    │   ├── hostgator-deploy-lftp.ps1  ← 🟢 SCRIPT DE DEPLOY
    │   └── optimize-dist.mjs          ← Otimizador pós-build
    │
    ├── package.json               ← Dependências e scripts npm
    ├── astro.config.mjs           ← Configuração do Astro
    └── tsconfig.json              ← Configuração TypeScript
```

---

## 4. Onde Fazer Alterações

### ✅ Regra de ouro: **Todas as edições são feitas na pasta `src/`**

| O que você quer alterar                     | Onde editar                                      |
|---------------------------------------------|--------------------------------------------------|
| Conteúdo de uma página (texto, seções)      | `src/pages/<nome-da-pagina>.astro`               |
| Cabeçalho ou menu de navegação              | `src/components/Header.astro`                    |
| Rodapé                                      | `src/components/Footer.astro`                    |
| Formulário de contato                       | `src/components/ContactForm.astro`               |
| Seção Hero (banner principal)               | `src/components/Hero.astro`                      |
| Galeria de fotos                            | `src/components/Gallery.astro`                   |
| Estilos globais / cores / fontes            | `src/styles/global.css`                          |
| Layout base (meta tags, estrutura HTML)     | `src/layouts/BaseLayout.astro`                   |
| Imagens, ícones, arquivos estáticos         | `public/images/`                                 |
| Favicon                                     | `public/favicon.ico` e `public/favicon.svg`      |
| Regras de redirecionamento / cache HTTP     | `public/.htaccess`                               |
| SEO (robots.txt)                            | `public/robots.txt`                              |

### ⛔ O que NÃO editar manualmente

| Pasta/Arquivo   | Motivo                                                     |
|-----------------|------------------------------------------------------------|
| `dist/`         | Gerada automaticamente pelo build. Será sobrescrita.       |
| `node_modules/` | Gerenciada pelo npm. Nunca edite.                          |
| `.astro/`       | Cache interno do Astro. Gerado automaticamente.            |

---

## 5. Fluxo de Deploy — Passo a Passo

### Passo 1 — Abra o terminal no diretório do projeto

```powershell
cd d:\VMs\Projetos\Web_Devlop_EscolaVillaKids\site
```

### Passo 2 — (Opcional) Teste localmente antes do deploy

```powershell
npm run dev
```

Isso inicia um servidor local em `http://localhost:4321`. Navegue pelo site e verifique suas alterações. Pressione `Ctrl+C` para encerrar.

### Passo 3 — Execute o deploy

```powershell
.\scripts\hostgator-deploy-lftp.ps1
```

**O que acontece ao rodar esse comando:**

1. O script executa `npm run build` (compila o Astro + Tailwind CSS)
2. O Astro gera os arquivos HTML/CSS/JS otimizados na pasta `dist/`
3. O script pós-build (`optimize-dist.mjs`) comprime os arquivos gerando versões `.br` e `.gz`
4. O `lftp` é invocado via WSL para sincronizar a pasta `dist/` com o servidor HostGator
5. Apenas arquivos modificados são transferidos (sincronização inteligente)

### Passo 4 — Verifique o resultado

Acesse https://www.colegiovillaprime.com.br e confirme que as alterações estão visíveis. Limpe o cache do navegador com `Ctrl+Shift+R` se necessário.

---

## 6. Como o Script de Deploy Funciona

O arquivo `scripts/hostgator-deploy-lftp.ps1` automatiza todo o processo. Aqui está a explicação detalhada de cada etapa interna:

### Etapa 1 — Build do Projeto

```
npm run build
  └── astro build              → Compila .astro → HTML estático
  └── node optimize-dist.mjs   → Comprime com Brotli (.br) e Gzip (.gz)
```

O Astro processa cada arquivo `.astro` em `src/pages/`, resolve os componentes importados, aplica o Tailwind CSS, e gera arquivos HTML puros na pasta `dist/`.

### Etapa 2 — Conexão FTPS

O script se conecta ao servidor HostGator usando **FTPS (FTP sobre SSL/TLS)**:

```
Protocolo:     FTPS (FTP + TLS/SSL)
Host:          69.6.212.125
Usuário:       manoel_benicio@colegiovillaprime.com.br
Diretório:     public_html/
```

> **Por que FTPS e não SSH/rsync?** A hospedagem compartilhada da HostGator desabilita acesso SSH por padrão. O FTPS é o método seguro disponível.

### Etapa 3 — Sincronização com `lftp mirror`

O `lftp` é um cliente FTP avançado que roda no WSL (Linux). Ele executa um comando `mirror` que funciona de forma similar ao `rsync`:

```
mirror -R -v --parallel=10 --delete --only-newer "dist/" "public_html/"
```

| Flag            | Significado                                                   |
|-----------------|---------------------------------------------------------------|
| `-R`            | Reverse mirror — envia do local para o remoto                 |
| `-v`            | Verbose — exibe o progresso de cada arquivo                   |
| `--parallel=10` | Transfere até 10 arquivos simultaneamente (alta velocidade)   |
| `--delete`      | Remove do servidor arquivos que não existem mais localmente   |
| `--only-newer`  | Só transfere arquivos que foram modificados                   |

### Etapa 4 — Limpeza

O script remove o arquivo temporário de configuração do lftp e exibe o tempo total de execução.

---

## 7. Opções e Parâmetros do Script

O script aceita dois parâmetros opcionais:

### Deploy completo (padrão)

```powershell
.\scripts\hostgator-deploy-lftp.ps1
```

Executa build + upload.

### Pular o build (se já fez build antes)

```powershell
.\scripts\hostgator-deploy-lftp.ps1 -SkipBuild
```

Útil quando você já executou `npm run build` manualmente e quer apenas fazer upload.

### Simulação (dry-run)

```powershell
.\scripts\hostgator-deploy-lftp.ps1 -DryRun
```

Simula o deploy **sem transferir nenhum arquivo**. Mostra quais arquivos seriam enviados. Ideal para verificar antes de publicar.

### Combinando parâmetros

```powershell
.\scripts\hostgator-deploy-lftp.ps1 -SkipBuild -DryRun
```

---

## 8. Servidor de Desenvolvimento Local

Para desenvolver e testar alterações antes de publicar:

```powershell
cd d:\VMs\Projetos\Web_Devlop_EscolaVillaKids\site
npm run dev
```

| Comando           | Descrição                                        |
|-------------------|--------------------------------------------------|
| `npm run dev`     | Inicia servidor local com hot-reload em `localhost:4321` |
| `npm run build`   | Gera a versão de produção em `dist/`             |
| `npm run preview` | Serve localmente a versão de produção (pasta `dist/`) |

### Fluxo recomendado de desenvolvimento

```
1. Editar arquivos em src/
2. Testar com `npm run dev` (visualização instantânea)
3. Quando satisfeito, rodar o deploy: .\scripts\hostgator-deploy-lftp.ps1
```

---

## 9. Troubleshooting (Resolução de Problemas)

### Erro: `Cannot find module` ou build falha

```powershell
# Limpar dependências e reinstalar
cd d:\VMs\Projetos\Web_Devlop_EscolaVillaKids\site
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
npm install
```

### Erro: `lftp: command not found`

O `lftp` precisa estar instalado dentro do WSL:

```bash
wsl sudo apt update
wsl sudo apt install -y lftp
```

### Erro de certificado SSL no lftp

O script já inclui `set ssl:verify-certificate no` para contornar certificados auto-assinados do HostGator. Se mesmo assim ocorrer erro, verifique se o IP do servidor (`69.6.212.125`) está acessível.

### Deploy está lento

- Verifique sua conexão de internet
- O `--parallel=10` já otimiza a velocidade
- Na primeira execução, **todos** os arquivos são enviados; nas seguintes, apenas os modificados (`--only-newer`)

### Alterações não aparecem no site

1. Limpe o cache do navegador: `Ctrl+Shift+R`
2. Verifique se o build foi bem-sucedido (sem erros no terminal)
3. Confirme que o script finalizou com `[OK] Sync completed successfully`

### Erro: `Missing field tsconfigPaths` ou similar do Vite

Esse erro ocorre por incompatibilidade de versão do Vite. O `package.json` já possui a correção:

```json
"overrides": {
  "vite": "^7"
}
```

Se o erro reaparecer após atualizar dependências, execute a limpeza completa descrita acima.

---

## 10. Segurança e Credenciais

### Credenciais de acesso FTP

As credenciais estão hardcoded no script de deploy por questões de praticidade em ambiente de time reduzido. Para ambientes com mais desenvolvedores, recomenda-se migrar para variáveis de ambiente.

> **⚠️ IMPORTANTE:** O arquivo `hostgator-deploy-lftp.ps1` contém a senha do FTP. Ele **não deve ser commitado** em repositórios públicos. Certifique-se de que o `.gitignore` inclui proteção adequada, ou migre as credenciais para o arquivo `.env.deploy.local`.

### Arquivo de configuração de referência

O arquivo `.env.deploy.local` contém as variáveis de ambiente de referência:

```env
DEPLOY_HOST=sh00140.hostgator.com.br
DEPLOY_USER=cri07713
DEPLOY_PATH=/home2/cri07713/public_html
DEPLOY_PORT=2222
DEPLOY_DOMAIN=https://www.colegiovillaprime.com.br
```

---

## 11. Decisões Técnicas e Justificativas

### Por que Astro?

- Gera HTML estático puro, ideal para hospedagem compartilhada (sem Node.js no servidor)
- Performance superior (zero JavaScript por padrão no client)
- Suporte nativo a componentes, layouts e roteamento baseado em arquivos

### Por que FTPS e não SSH/rsync?

- A HostGator (hospedagem compartilhada) **desabilita o acesso SSH** por padrão
- O FTPS é o único protocolo seguro disponível nesse plano de hospedagem
- O `lftp` com `mirror --parallel` oferece performance comparável ao rsync

### Por que lftp e não um cliente FTP comum?

- Suporta `mirror` (sincronização bidirecional inteligente)
- Transferência paralela (até 10 arquivos simultâneos)
- Detecção automática de arquivos modificados
- Scripting nativo (pode ser 100% automatizado)
- Suporte a FTPS/SFTP nativamente

### Por que WSL?

- O `lftp` é uma ferramenta Linux e não possui versão nativa para Windows
- O WSL permite executar o `lftp` diretamente do PowerShell com `wsl bash -c "..."`
- Zero overhead — integração transparente com o sistema de arquivos Windows

---

## Referência Rápida (Cola)

```
┌───────────────────────────────────────────────────────────┐
│                    COMANDOS ESSENCIAIS                     │
├───────────────────────────────────────────────────────────┤
│                                                           │
│  Desenvolvimento local:                                   │
│  $ cd site && npm run dev                                 │
│                                                           │
│  Deploy para produção:                                    │
│  $ cd site && .\scripts\hostgator-deploy-lftp.ps1         │
│                                                           │
│  Deploy sem rebuild:                                      │
│  $ .\scripts\hostgator-deploy-lftp.ps1 -SkipBuild        │
│                                                           │
│  Simular deploy (sem enviar):                             │
│  $ .\scripts\hostgator-deploy-lftp.ps1 -DryRun           │
│                                                           │
│  Reinstalar dependências:                                 │
│  $ rm -r -fo node_modules; rm package-lock.json           │
│  $ npm install                                            │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

---

*Documento gerado em 18/05/2026 — Equipe de Desenvolvimento Colégio Villa Prime*
