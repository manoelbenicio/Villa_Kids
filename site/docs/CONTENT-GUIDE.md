<!--
  @file CONTENT-GUIDE.md
  @description Guide for editing structured content and static images.
  @author CODEX-OPS
  @phase 8
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
-->

# Content Guide

O conteúdo estruturado fica em `site/src/data`. Edite os dados mantendo os tipos TypeScript existentes e rode `npm run build` antes de publicar.

## Arquivos de Dados

| Arquivo | Uso | Como editar |
|---|---|---|
| `faq.ts` | Perguntas frequentes e Schema.org FAQPage | Adicione objetos `{ question, answer }` em `faqItems`. Use respostas claras e sem HTML. |
| `features.ts` | Pilares pedagógicos | Edite `title`, `description`, `icon` e `link`. Ícones são SVG inline com `currentColor`. |
| `navigation.ts` | Menu principal e footer | Edite `mainNav`, `footerQuickLinks` e `footerLegalLinks`. Use URLs com barra final. |
| `school-info.ts` | Fonte única de contato, endereço, redes e WhatsApp | Atualize telefone, WhatsApp, endereço real, coordenadas, redes e `ogImage`. |
| `testimonials.ts` | Depoimentos | Substitua placeholders por depoimentos autorizados. Use avatar em `/images/team/`. |

## Formatos Esperados

Exemplo de FAQ:

```ts
export interface FAQItem {
  readonly question: string;
  readonly answer: string;
}
```

Exemplo de link:

```ts
export interface NavLink {
  readonly label: string;
  readonly href: string;
  readonly highlight?: boolean;
  readonly external?: boolean;
}
```

Exemplo de depoimento:

```ts
export interface Testimonial {
  readonly quote: string;
  readonly name: string;
  readonly role: string;
  readonly avatar?: string;
  readonly rating?: 1 | 2 | 3 | 4 | 5;
}
```

## Imagens

Diretórios:

- `site/public/images/hero/`
- `site/public/images/gallery/`
- `site/public/images/icons/`
- `site/public/images/team/`

Regras:

- Use nomes em lowercase com hífen: `sala-bercario.webp`.
- Prefira `.webp` para fotos e `.svg` para ícones simples.
- Mantenha `og-image.jpg` em `site/public/` com 1200x630.
- Referencie imagens públicas a partir da raiz: `/images/gallery/sala-bercario.webp`.

## Adicionar Nova Página

1. Criar arquivo em `site/src/pages/nova-pagina.astro`.
2. Importar e usar `BaseLayout.astro`.
3. Definir title, description e canonical via layout/SEO.
4. Adicionar rota em `src/data/navigation.ts`, se a página entrar no menu.
5. Rodar:

```powershell
npm run build
```

## Cuidados Editoriais

- Conteúdo público deve ficar em PT-BR.
- Não publicar telefone, endereço ou redes placeholders em produção.
- Depoimentos exigem autorização da família.
- Alterações em dados compartilhados afetam componentes, Schema.org e SEO.
