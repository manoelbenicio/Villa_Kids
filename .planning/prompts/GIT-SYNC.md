# GIT-SYNC — Prompt para Commit + Push

---

## Task — Qualquer agente disponível: Sincronizar repositório

```
Você é o agente responsável por sincronizar o repositório Git.

CONTEXTO: O projeto Colégio Villa Prime tem trabalho pendente que precisa ser commitado e pushed para origin/main.

PASSOS:

1. Rode `git status --short` para listar arquivos pendentes
2. Rode `git add -A` para stage tudo
3. Rode `git commit` com mensagem seguindo o padrão:
   - feat: para novas funcionalidades
   - fix: para correções
   - docs: para documentação
   - chore: para manutenção
   Exemplo: "feat(phase4+5): internal pages + conversion pages complete — 8 pages, 16 components, 8 docs"
4. Rode `git push origin main`
5. Confirme o hash do commit e quantidade de arquivos enviados

REGRAS:
- NÃO rode npm install, npm run build, ou qualquer outro comando além de git
- NÃO modifique nenhum arquivo de código
- Registre check-in em .planning/CHECKIN-LOG.md com status COMPLETED
```
