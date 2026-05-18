/**
 * @file features.ts
 * @description Four pedagogical pillars displayed on the home page in a 2x2 grid.
 *              Icons are inline SVG strings (24x24 viewBox, currentColor) — the
 *              FeatureCard component sizes them to 64px.
 * @author GEMINI-UX
 * @phase 2
 * @created 2026-05-17T20:49:00Z
 */

export interface Feature {
  readonly title: string;
  readonly description: string;
  /** Inline SVG markup. Must use viewBox="0 0 24 24" and currentColor. */
  readonly icon: string;
  readonly link?: string;
}

export const features: readonly Feature[] = [
  {
    title: 'Acolhimento',
    description:
      'Recebemos cada criança e cada família com escuta, afeto e respeito ao ritmo individual de adaptação. Um ambiente onde todos se sentem em casa desde o primeiro dia.',
    icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s-7-4.5-9.5-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 9.5 6c-2.5 4.5-9.5 9-9.5 9Z"/></svg>`,
    link: '/proposta-pedagogica/',
  },
  {
    title: 'Desenvolvimento Integral',
    description:
      'Currículo que estimula as dimensões cognitiva, motora, emocional e social. Aprendizagem significativa por meio do brincar, da exploração e da construção de vínculos.',
    icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2 4 6v6c0 5 3.5 8.5 8 10 4.5-1.5 8-5 8-10V6l-8-4Z"/><path d="m9 12 2 2 4-4"/></svg>`,
    link: '/proposta-pedagogica/',
  },
  {
    title: 'Segurança',
    description:
      'Infraestrutura projetada para a primeira infância: acesso controlado, monitoramento, equipe treinada e protocolos de saúde. Tranquilidade em cada detalhe.',
    icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/></svg>`,
    link: '/seguranca/',
  },
  {
    title: 'Família Presente',
    description:
      'Comunicação transparente e canais digitais que aproximam pais e escola. Reuniões periódicas, app dedicado e portas abertas para uma parceria verdadeira.',
    icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
    link: '/tecnologia/',
  },
] as const;
