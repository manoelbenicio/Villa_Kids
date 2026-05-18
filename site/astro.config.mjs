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