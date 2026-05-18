# FASE 5 — Prompts (Conversion Pages)

---

## Task 5.1-5.3 — GEMINI-UX: Páginas de conversão

```
Você é GEMINI-UX. Leia .planning/ARCHITECTURE-BLUEPRINT.md.

CONTEXTO: Projeto PREMIUM Fortune 500. Páginas internas prontas. Agora as páginas de CONVERSÃO — as mais importantes comercialmente.

PÁGINAS:

1. site/src/pages/matriculas.astro — PÁGINA MAIS IMPORTANTE
   - Hero: "Matrículas Abertas 2026" com urgency badge
   - Seção: Processo de Matrícula (steps 1-2-3 visual)
   - Seção: Diferenciais resumidos (4 TrustBadges)
   - Seção: Depoimentos (social proof)
   - Seção: FAQ sobre matrículas (3-4 perguntas)
   - CTA PRINCIPAL: WhatsApp grande + formulário de interesse
   - Design deve CONVERTER: cores quentes, urgência visual, social proof

2. site/src/pages/contato.astro
   - Hero: "Fale Conosco"
   - Layout 2 colunas: ContactForm (esquerda) + Info contato (direita)
   - Info: endereço, telefone, email, horário, mapa Google (iframe ou imagem)
   - Redes sociais com ícones
   - CTA: WhatsApp como alternativa rápida

3. site/src/pages/politica-de-privacidade.astro
   - Hero: "Política de Privacidade"
   - Texto LGPD completo: coleta de dados, uso, compartilhamento, direitos do titular, contato DPO
   - Layout clean, texto longo com tipografia legível
   - Última atualização: data dinâmica

QUALIDADE: Matrículas deve ser a página mais impactante visualmente. Contato deve ser funcional. Privacidade deve ser legível.
Registre check-in em .planning/CHECKIN-LOG.md.
```

---

## Task 5.4 — CODEX-OPS: Validar formulários

```
Você é CODEX-OPS. Use 4 sub-agentes em paralelo.

SUB-AGENTE 1: Testar ContactForm — validação client-side (campos obrigatórios, email regex, telefone)
SUB-AGENTE 2: Testar honeypot field — campo hidden não deve ser visível, se preenchido bloqueia submit
SUB-AGENTE 3: Testar UX do formulário — tab order, labels, focus states, erro states
SUB-AGENTE 4: Build completo — todas as 9 páginas devem gerar sem erro

Registre check-in em .planning/CHECKIN-LOG.md.
```
