/**
 * @file testimonials.ts
 * @description Placeholder testimonials. Replace with real, signed quotes
 *              before launch. Avatar paths point to /public/images/team/.
 * @author GEMINI-UX
 * @phase 2
 * @created 2026-05-17T20:49:00Z
 */

export interface Testimonial {
  readonly quote: string;
  readonly name: string;
  readonly role: string;
  readonly avatar?: string;
  readonly rating?: 1 | 2 | 3 | 4 | 5;
}

export const testimonials: readonly Testimonial[] = [
  {
    quote:
      'A adaptação da nossa filha foi muito mais leve do que imaginávamos. A equipe acolhe cada criança de um jeito único e mantém a gente realmente perto da rotina dela.',
    name: 'Mariana Alves',
    role: 'Mãe da Helena · Berçário',
    avatar: '/images/team/avatar-placeholder-1.svg',
    rating: 5,
  },
  {
    quote:
      'A estrutura é impecável e o cuidado com a segurança transmite tranquilidade no dia a dia. O Villa Prime entrega aquilo que promete — e mais.',
    name: 'Rafael Monteiro',
    role: 'Pai do Theo · Maternal II',
    avatar: '/images/team/avatar-placeholder-2.svg',
    rating: 5,
  },
  {
    quote:
      'Vimos nosso filho desabrochar nesse último ano. As atividades, os professores e o app de comunicação fazem toda a diferença. Recomendamos sem hesitar.',
    name: 'Camila e Diego Souza',
    role: 'Pais do Bento · Infantil I',
    avatar: '/images/team/avatar-placeholder-3.svg',
    rating: 5,
  },
] as const;
