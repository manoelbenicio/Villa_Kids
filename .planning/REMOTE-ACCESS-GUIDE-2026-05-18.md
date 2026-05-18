# Guia de Acesso Remoto - Tailscale, SSH e Remote Desktop

**Projeto:** Web_Devlop_EscolaVillaKids  
**Equipamento principal:** `msi-laptop`  
**Data da validação:** 2026-05-18  
**Fuso horário local:** America/Sao_Paulo  
**Objetivo:** orientar usuários autorizados a acessar remotamente o ambiente por Remote Desktop ou SSH, usando Tailscale como rede privada segura.

---

## 1. Resumo Executivo

Este ambiente possui dois acessos remotos funcionais:

| Finalidade | Sistema acessado | Protocolo | Endereço | Porta | Status validado |
|---|---|---:|---:|---:|---|
| Área de trabalho remota | Windows do notebook `msi-laptop` | RDP | `100.87.232.86` | `3389` | OK |
| Terminal Linux | Ubuntu/WSL no notebook `msi-laptop` | SSH | `100.122.21.119` | `22` | OK |

Ponto crítico: o Windows e o WSL aparecem como nós Tailscale separados. Eles também foram observados em contas/tailnets diferentes. Portanto, um usuário pode conseguir acessar o RDP do Windows e, ao mesmo tempo, não conseguir acessar o SSH do WSL se não estiver autorizado na tailnet correta.

---

## 2. Quem é Quem no Ambiente

### 2.1. Máquina Windows

| Item | Valor |
|---|---|
| Nome do host | `msi-laptop` |
| Sistema | Windows |
| Função | Ambiente gráfico principal, acesso por Remote Desktop |
| IP Tailscale | `100.87.232.86` |
| Porta de acesso | `3389/TCP` |
| Serviço Windows | `TermService` |
| Conta local validada | `msi-laptop\dataops-lab` |
| Grupo com permissão administrativa | `Administrators` |

Use este destino quando precisar abrir a tela do Windows por Remote Desktop.

### 2.2. Ambiente Ubuntu/WSL

| Item | Valor |
|---|---|
| Distribuição WSL | `Ubuntu` |
| Nome do host Linux | `msi-laptop` |
| Usuário padrão | `dataops-lab` |
| Função | Terminal Linux, automações, deploys e comandos de desenvolvimento |
| IP Tailscale | `100.122.21.119` |
| Porta de acesso | `22/TCP` |
| Serviço SSH | `ssh.service` |
| Serviço Tailscale | `tailscaled.service` |

Use este destino quando precisar abrir terminal Linux por SSH.

### 2.3. Outro nó observado na tailnet do WSL

| Item | Valor |
|---|---|
| Nome | `wsl-dataops-labs` |
| IP Tailscale | `100.117.245.16` |
| Status no teste | Respondendo via Tailscale/DERP São Paulo |

Esse nó apareceu no status do Tailscale do WSL e respondeu a `tailscale ping`.

---

## 3. Pré-requisitos para os Usuários

Antes de tentar conectar, o usuário precisa:

1. Ter o Tailscale instalado no computador de origem.
2. Estar logado na tailnet correta.
3. Ter permissão para acessar o nó de destino.
4. Estar conectado à internet.
5. Saber qual acesso deseja usar:
   - RDP para controlar o Windows.
   - SSH para acessar o terminal Ubuntu/WSL.

Não é necessário abrir portas no roteador para o uso normal via Tailscale. O acesso externo deve ocorrer pela rede privada Tailscale.

---

## 4. Como Conectar por Remote Desktop

### 4.1. Quando usar

Use Remote Desktop quando precisar acessar a interface gráfica do Windows, abrir programas, navegar por arquivos, usar IDEs ou operar o computador como se estivesse presencialmente nele.

### 4.2. Endereço

| Campo | Valor |
|---|---|
| Host | `100.87.232.86` |
| Porta | `3389` |
| Protocolo | RDP |
| Usuário Windows | `dataops-lab` ou outro usuário autorizado |

### 4.3. Conexão a partir do Windows

No computador remoto:

1. Abra o Tailscale e confirme que está conectado.
2. Abra o aplicativo "Conexão de Área de Trabalho Remota" ou execute:

```powershell
mstsc /v:100.87.232.86
```

3. Informe o usuário e senha do Windows.
4. Se aparecer alerta de certificado, confirme apenas se o endereço for `100.87.232.86` e o destino esperado for `msi-laptop`.

### 4.4. Conexão a partir de macOS

1. Instale o aplicativo "Windows App" ou "Microsoft Remote Desktop".
2. Adicione um novo PC.
3. Em "PC name", use:

```text
100.87.232.86
```

4. Salve e conecte.
5. Informe as credenciais do Windows.

### 4.5. Conexão a partir de Linux

Exemplo com `xfreerdp`:

```bash
xfreerdp /v:100.87.232.86 /u:dataops-lab
```

Se o usuário tiver domínio local, pode ser necessário usar:

```bash
xfreerdp /v:100.87.232.86 /u:msi-laptop\\dataops-lab
```

---

## 5. Como Conectar por SSH ao Ubuntu/WSL

### 5.1. Quando usar

Use SSH quando precisar acessar o terminal Linux, executar scripts, trabalhar com Git, rodar deploys, diagnosticar serviços ou automatizar tarefas.

### 5.2. Endereço

| Campo | Valor |
|---|---|
| Host | `100.122.21.119` |
| Porta | `22` |
| Protocolo | SSH |
| Usuário Linux | `dataops-lab` |

### 5.3. Comando de conexão

Em qualquer terminal com SSH instalado:

```bash
ssh dataops-lab@100.122.21.119
```

Se for necessário informar a porta explicitamente:

```bash
ssh -p 22 dataops-lab@100.122.21.119
```

### 5.4. Primeiro acesso

No primeiro acesso, o SSH pode perguntar se você confia na chave do host:

```text
Are you sure you want to continue connecting?
```

Confirme apenas se o IP for `100.122.21.119` e você estiver acessando o ambiente `msi-laptop`/Ubuntu.

---

## 6. Estado Validado em 2026-05-18

### 6.1. Windows

Resultado validado:

| Item | Estado |
|---|---|
| Serviço Tailscale Windows | `Running` |
| Serviço Remote Desktop (`TermService`) | `Running` |
| Remote Desktop habilitado | Sim |
| Firewall para RDP | Habilitado |
| Porta `3389/TCP` | Escutando |
| Teste TCP em `100.87.232.86:3389` | Sucesso |
| NLA | Habilitado |

### 6.2. Ubuntu/WSL

Resultado validado:

| Item | Estado |
|---|---|
| WSL Ubuntu | `Running` |
| `tailscaled.service` | `active` e `enabled` |
| `ssh.service` | `active` e `enabled` |
| Porta `22/TCP` | Escutando em `0.0.0.0` e `::` |
| Teste TCP em `100.122.21.119:22` dentro do WSL | Sucesso |
| IP Tailscale WSL | `100.122.21.119` |

### 6.3. Correção aplicada

Foi removido de `/etc/wsl.conf` um `boot.command` antigo que iniciava `sshd` e `tailscaled` manualmente. Esse comando causava conflito com o `ssh.service`, porque a porta `22` já ficava ocupada antes do systemd iniciar o serviço oficial.

Arquivo atual esperado:

```ini
[boot]
systemd=true

[user]
default=dataops-lab
```

Backup criado:

```text
/etc/wsl.conf.bak-2026-05-18
```

---

## 7. Checklist Rápido para Diagnóstico

### 7.1. Se o Remote Desktop não conectar

No Windows de destino, verificar:

```powershell
Get-Service -Name Tailscale,TermService
```

Esperado:

```text
Tailscale   Running
TermService Running
```

Verificar se a porta RDP está escutando:

```powershell
Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq 3389 }
```

Testar conexão local:

```powershell
Test-NetConnection -ComputerName 127.0.0.1 -Port 3389
```

Testar pelo IP Tailscale do Windows:

```powershell
Test-NetConnection -ComputerName 100.87.232.86 -Port 3389
```

Se falhar:

1. Confirmar que o Tailscale está conectado no Windows.
2. Confirmar que o usuário remoto está na mesma tailnet do Windows.
3. Confirmar que o Remote Desktop está habilitado nas configurações do Windows.
4. Confirmar que o usuário usado para login tem permissão de RDP.
5. Reiniciar o serviço RDP, se necessário:

```powershell
Restart-Service TermService -Force
```

### 7.2. Se o SSH não conectar

No Ubuntu/WSL, verificar:

```bash
systemctl status ssh tailscaled --no-pager
```

Esperado:

```text
ssh.service        active (running)
tailscaled.service active (running)
```

Verificar se a porta 22 está escutando:

```bash
ss -ltnp | grep ':22'
```

Esperado:

```text
0.0.0.0:22
[::]:22
```

Verificar o IP Tailscale do WSL:

```bash
tailscale ip -4
```

Esperado:

```text
100.122.21.119
```

Testar a própria porta SSH dentro do WSL:

```bash
timeout 5 bash -lc '</dev/tcp/100.122.21.119/22' && echo OK || echo FAIL
```

Se falhar:

```bash
sudo systemctl restart ssh tailscaled
systemctl status ssh tailscaled --no-pager
```

### 7.3. Se o Tailscale estiver sem rota ou fora da tailnet

Verificar status:

```bash
tailscale status
```

Verificar conectividade:

```bash
tailscale netcheck
```

Se o nó aparecer offline ou sem autenticação:

```bash
sudo tailscale up
```

Esse comando pode abrir um link de autenticação. Use uma conta autorizada da tailnet correta.

---

## 8. Problemas Comuns e Soluções

### Problema 1: RDP funciona, mas SSH não funciona

Causa provável: o Windows e o WSL estão em tailnets diferentes. O usuário remoto pode estar autorizado apenas na tailnet do Windows.

Solução:

1. Confirmar se o usuário remoto vê o nó `msi-laptop` com IP `100.87.232.86`.
2. Confirmar se o usuário remoto também vê o nó WSL com IP `100.122.21.119`.
3. Se não vê o WSL, convidar o usuário para a tailnet correta ou mover o WSL para a mesma conta/tailnet do Windows.

### Problema 2: SSH responde localmente, mas não de outro computador

Causas prováveis:

- Computador remoto não está na mesma tailnet do WSL.
- ACL do Tailscale bloqueia acesso à porta `22`.
- O Tailscale do WSL está conectado em outra conta.

Solução:

```bash
tailscale status
tailscale ip -4
```

Depois confirmar no painel administrativo do Tailscale se o usuário e o nó estão autorizados.

### Problema 3: `ssh.service` falha com "Address already in use"

Causa provável: algum processo iniciou `/usr/sbin/sshd` manualmente antes do systemd.

Diagnóstico:

```bash
ps -ef | grep '[s]shd'
ss -ltnp | grep ':22'
systemctl status ssh --no-pager
```

Solução:

1. Remover comandos manuais de boot em `/etc/wsl.conf`.
2. Manter apenas:

```ini
[boot]
systemd=true
```

3. Reiniciar o WSL:

```powershell
wsl --shutdown
wsl -d Ubuntu
```

4. Subir serviços:

```bash
sudo systemctl restart ssh tailscaled
```

### Problema 4: Remote Desktop pede credenciais mas não entra

Causas prováveis:

- Usuário ou senha incorretos.
- Conta sem senha local.
- Usuário sem permissão para login remoto.
- NLA exigindo credenciais válidas antes de abrir sessão.

Solução:

1. Testar login local no Windows.
2. Usar o formato:

```text
msi-laptop\dataops-lab
```

3. Confirmar se o usuário é administrador ou membro de "Remote Desktop Users".
4. Se necessário, adicionar usuário ao grupo:

```powershell
net localgroup "Remote Desktop Users" dataops-lab /add
```

### Problema 5: Tailscale mostra DNS warning no WSL

Foi observado alerta de DNS no Tailscale do WSL relacionado a `/etc/resolv.conf`. Esse alerta não impediu o SSH nem a conectividade Tailscale durante a validação.

Se houver falhas de DNS dentro do WSL, testar:

```bash
cat /etc/resolv.conf
tailscale netcheck
ping 1.1.1.1
ping google.com
```

Se IP funciona mas nome não resolve, o problema é DNS. Nesse caso, revisar a configuração de DNS do WSL e do Tailscale.

---

## 9. Comandos de Manutenção

### 9.1. Reiniciar serviços no WSL

```bash
sudo systemctl restart ssh tailscaled
```

### 9.2. Ver estado dos serviços no WSL

```bash
systemctl is-active ssh tailscaled
systemctl is-enabled ssh tailscaled
```

### 9.3. Ver IP Tailscale do WSL

```bash
tailscale ip -4
```

### 9.4. Ver status Tailscale do WSL

```bash
tailscale status
```

### 9.5. Reiniciar WSL pelo Windows

```powershell
wsl --shutdown
wsl -d Ubuntu
```

### 9.6. Ver serviços no Windows

```powershell
Get-Service -Name Tailscale,TermService
```

### 9.7. Ver portas abertas no Windows

```powershell
Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -in 22,3389 }
```

### 9.8. Testar RDP no Windows

```powershell
Test-NetConnection -ComputerName 100.87.232.86 -Port 3389
```

### 9.9. Abrir RDP pelo Windows

```powershell
mstsc /v:100.87.232.86
```

---

## 10. Procedimento Recomendado para Novos Usuários

1. Instalar o Tailscale no computador do usuário.
2. Solicitar convite para a tailnet correta.
3. Confirmar no Tailscale se o nó desejado aparece online:
   - Windows/RDP: `msi-laptop`, `100.87.232.86`.
   - WSL/SSH: `msi-laptop`, `100.122.21.119`.
4. Para acesso gráfico, conectar com:

```powershell
mstsc /v:100.87.232.86
```

5. Para acesso terminal, conectar com:

```bash
ssh dataops-lab@100.122.21.119
```

6. Em caso de erro, seguir a seção "Checklist Rápido para Diagnóstico".

---

## 11. Boas Práticas de Segurança

- Não expor as portas `22` ou `3389` diretamente na internet pública sem necessidade explícita.
- Preferir acesso via Tailscale.
- Convidar apenas usuários necessários para a tailnet.
- Remover usuários que não precisam mais de acesso.
- Não compartilhar senhas em mensagens abertas.
- Preferir contas individuais em vez de uma conta compartilhada.
- Revisar ACLs do Tailscale quando houver múltiplos usuários.
- Manter o Windows bloqueado quando não estiver em uso.
- Usar senha forte nas contas Windows e Linux.

---

## 12. Matriz de Decisão

| Preciso fazer... | Use | Endereço |
|---|---|---|
| Operar a interface gráfica do Windows | Remote Desktop | `100.87.232.86:3389` |
| Rodar comandos Linux | SSH no WSL | `100.122.21.119:22` |
| Diagnosticar RDP | PowerShell no Windows | `Get-Service`, `Test-NetConnection` |
| Diagnosticar SSH | Terminal Ubuntu/WSL | `systemctl`, `ss`, `tailscale status` |
| Reiniciar o ambiente Linux inteiro | PowerShell no Windows | `wsl --shutdown` |

---

## 13. Observação Final

O acesso remoto está funcional, mas a separação entre o Tailscale do Windows e o Tailscale do WSL deve ser tratada com atenção. Para reduzir confusão operacional, o ideal é padronizar os dois nós na mesma tailnet ou documentar claramente qual grupo de usuários tem acesso a cada nó.
