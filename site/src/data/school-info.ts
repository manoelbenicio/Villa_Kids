/**
 * @file school-info.ts
 * @description Single source of truth for school contact info, address, social links.
 *              Consumed by Footer, ContactForm, SchemaOrg, WhatsAppButton, etc.
 * @author GEMINI-UX
 * @phase 2
 * @created 2026-05-17T20:49:00Z
 */

export const schoolInfo = {
  name: 'Colégio Villa Prime',
  legalName: 'Colégio Villa Prime — Educação Infantil',
  tagline: 'Educação que transforma os primeiros anos',
  shortDescription:
    'Escola de educação infantil premium para crianças de 0 a 6 anos. Acolhimento, desenvolvimento integral e segurança em São Paulo.',
  longDescription:
    'O Colégio Villa Prime oferece educação infantil de excelência para crianças de 0 a 6 anos, combinando uma proposta pedagógica sólida, ambientes seguros e uma comunicação transparente com as famílias. Nossa missão é desenvolver cada criança em sua plenitude — cognitiva, emocional e social — em um ambiente acolhedor que respeita o ritmo único da infância.',

  // --- Contact ---
  phone: '(11) 2781-6984',
  phoneRaw: '+551127816984',
  whatsapp: '5511932343947',
  whatsappDisplay: '(11) 93234-3947',
  email: 'contato@colegiovillaprime.com.br',

  // --- Address ---
  address: {
    street: 'Av. Dedo de Deus',
    number: '239',
    neighborhood: 'Vila Formosa',
    city: 'São Paulo',
    state: 'SP',
    stateCode: 'SP',
    zip: '03363-100',
    country: 'Brasil',
    countryCode: 'BR',
    fullStreet: 'Av. Dedo de Deus, 239 — Vila Formosa, São Paulo/SP',
  },

  // --- Geolocation ---
  geo: {
    latitude: -23.5640050,
    longitude: -46.5384566,
  },

  // --- Social Networks ---
  social: {
    instagram: 'https://www.instagram.com/colegiovillaprime',
    instagramHandle: '@colegiovillaprime',
    facebook: 'https://www.facebook.com/colegiovillaprime',
    youtube: '',
    linkedin: '',
  },

  // --- Operating Hours ---
  hours: 'Segunda a Sexta, das 7h às 19h',
  hoursMachine: 'Mo-Fr 07:00-19:00',

  // --- Identity ---
  ageRange: '0 a 6 anos',
  founded: 2026,
  priceRange: '$$',

  // --- URLs ---
  url: 'https://www.colegiovillaprime.com.br',
  ogImage: '/og-image.jpg',

  // --- Default WhatsApp message ---
  whatsappMessage:
    'Olá! Tenho interesse em conhecer o Colégio Villa Prime e gostaria de agendar uma visita.',
} as const;

/**
 * Helper to build a wa.me link with a pre-filled message.
 */
export function whatsappLink(message: string = schoolInfo.whatsappMessage): string {
  return `https://wa.me/${schoolInfo.whatsapp}?text=${encodeURIComponent(message)}`;
}

export type SchoolInfo = typeof schoolInfo;
