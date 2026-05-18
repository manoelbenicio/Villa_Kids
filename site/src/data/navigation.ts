/**
 * @file navigation.ts
 * @description Main navigation links and footer link groups.
 * @author GEMINI-UX
 * @phase 2
 * @created 2026-05-17T20:49:00Z
 */

export interface NavLink {
  readonly label: string;
  readonly href: string;
  readonly highlight?: boolean;
  readonly external?: boolean;
}

export const mainNav: readonly NavLink[] = [
  { label: 'Início', href: '/' },
  { label: 'Proposta Pedagógica', href: '/proposta-pedagogica/' },
  { label: 'Turmas', href: '/turmas/' },
  { label: 'Estrutura', href: '/estrutura/' },
  { label: 'Tecnologia', href: '/tecnologia/' },
  { label: 'Segurança', href: '/seguranca/' },
  { label: 'Matrículas', href: '/matriculas/', highlight: true },
  { label: 'Contato', href: '/contato/' },
] as const;

export const footerQuickLinks: readonly NavLink[] = [
  { label: 'Início', href: '/' },
  { label: 'Proposta Pedagógica', href: '/proposta-pedagogica/' },
  { label: 'Turmas', href: '/turmas/' },
  { label: 'Estrutura', href: '/estrutura/' },
  { label: 'Matrículas', href: '/matriculas/' },
  { label: 'Contato', href: '/contato/' },
] as const;

export const footerLegalLinks: readonly NavLink[] = [
  { label: 'Política de Privacidade', href: '/politica-de-privacidade/' },
] as const;
