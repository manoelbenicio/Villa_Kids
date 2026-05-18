/**
 * @file faq.ts
 * @description Frequently asked questions. The FAQ component automatically
 *              generates Schema.org FAQPage JSON-LD from this data.
 * @author GEMINI-UX
 * @phase 2
 * @created 2026-05-17T20:49:00Z
 */

export interface FAQItem {
  readonly question: string;
  readonly answer: string;
}

export const faqItems: readonly FAQItem[] = [
  {
    question: 'A partir de qual idade posso matricular meu filho no Colégio Villa Prime?',
    answer:
      'Atendemos crianças de 0 a 6 anos, do berçário (a partir de 4 meses) ao Infantil II. As turmas são organizadas por faixa etária para respeitar o ritmo de desenvolvimento de cada fase.',
  },
  {
    question: 'Qual é o horário de funcionamento da escola?',
    answer:
      'Funcionamos de segunda a sexta-feira, das 7h às 19h. Oferecemos opções de meio período (manhã ou tarde) e período integral, para acompanhar a rotina das famílias.',
  },
  {
    question: 'Como posso agendar uma visita para conhecer a escola?',
    answer:
      'Você pode agendar uma visita guiada pelo nosso WhatsApp ou pelo formulário de contato. Recebemos as famílias em horários reservados, para que você conheça o ambiente, a equipe e tire todas as suas dúvidas com calma.',
  },
  {
    question: 'Como funciona a comunicação com os pais durante o dia?',
    answer:
      'Disponibilizamos um app exclusivo onde os pais acompanham a rotina, alimentação, soneca, atividades e fotos do dia da criança. Além disso, mantemos reuniões periódicas individuais e canais diretos com a coordenação pedagógica.',
  },
  {
    question: 'Quais protocolos de segurança e saúde a escola adota?',
    answer:
      'Contamos com acesso controlado por biometria e câmeras, equipe treinada em primeiros socorros, ambientes higienizados diariamente e protocolos de saúde alinhados às orientações sanitárias vigentes. A integridade das crianças é nossa prioridade.',
  },
  {
    question: 'A escola oferece alimentação? Como funciona o cardápio?',
    answer:
      'Sim. Oferecemos um cardápio elaborado por nutricionista, com refeições preparadas em nossa cozinha própria, respeitando restrições alimentares e necessidades específicas de cada faixa etária. As famílias recebem o cardápio mensal antecipadamente.',
  },
] as const;
