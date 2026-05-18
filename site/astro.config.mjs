// @ts-check
/**
 * @file astro.config.mjs
 * @description Astro configuration — static output for HostGator shared hosting
 * @author OPUS-ARCH
 * @phase 1
 * @created 2026-05-17T23:20:00Z
 */
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://www.colegiovillaprime.com.br',
  output: 'static',
  
  integrations: [
    sitemap({
      changefreq: 'weekly',
      priority: 0.7,
      lastmod: new Date(),
      serialize(item) {
        // Custom priority per route
        if (item.url.endsWith('.com.br/')) {
          item.priority = 1.0;
          item.changefreq = 'weekly';
        } else if (item.url.includes('/matriculas/')) {
          item.priority = 0.9;
          item.changefreq = 'weekly';
        } else if (item.url.includes('/contato/') || item.url.includes('/turmas/')) {
          item.priority = 0.8;
          item.changefreq = 'weekly';
        } else if (item.url.includes('/politica-de-privacidade/')) {
          item.priority = 0.3;
          item.changefreq = 'yearly';
        } else {
          item.priority = 0.7;
        }
        return item;
      },
    }),
  ],

  vite: {
    plugins: [tailwindcss()],
  },

  prefetch: {
    defaultStrategy: 'hover',
    prefetchAll: false,
  },

  build: {
    format: 'directory',
    inlineStylesheets: 'auto',
  },
});