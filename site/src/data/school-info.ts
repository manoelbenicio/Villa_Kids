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
  phone: '(11) 0000-0000',
  phoneRaw: '+551100000000',
  whatsapp: '5511000000000',
  whatsappDisplay: '(11) 00000-0000',
  email: 'contato@colegiovillaprime.com.br',

  // --- Address ---
  address: {
    street: 'Rua a Definir',
    number: 'S/N',
    neighborhood: 'Zona Leste',
    city: 'São Paulo',
    state: 'SP',
    stateCode: 'SP',
    zip: '00000-000',
    country: 'Brasil',
    countryCode: 'BR',
    fullStreet: 'Rua a Definir, S/N — Zona Leste, São Paulo/SP',
  },

  // --- Geolocation (placeholder — replace with real coordinates) ---
  geo: {
    latitude: -23.5505,
    longitude: -46.6333,
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
