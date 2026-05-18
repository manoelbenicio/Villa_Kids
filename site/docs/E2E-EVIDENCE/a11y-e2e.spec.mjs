import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';
import fs from 'node:fs/promises';
import path from 'node:path';

const baseURL = 'http://localhost:4321';
const routes = [
  '/',
  '/proposta-pedagogica/',
  '/turmas/',
  '/estrutura/',
  '/tecnologia/',
  '/seguranca/',
  '/contato/',
  '/matriculas/',
  '/politica-de-privacidade/',
];

const evidenceDir = path.resolve('docs/E2E-EVIDENCE');
const rawDir = path.resolve('docs/a11y-raw');

const routeName = (route) => (route === '/' ? 'home' : route.replace(/^\/|\/$/g, '').replaceAll('/', '__'));

test.describe.configure({ mode: 'serial' });

test.beforeAll(async () => {
  await fs.mkdir(evidenceDir, { recursive: true });
  await fs.mkdir(rawDir, { recursive: true });
});

for (const route of routes) {
  test(`WCAG 2.1 AA accessibility and E2E smoke: ${route}`, async ({ page }, testInfo) => {
    const name = routeName(route);
    const consoleMessages = [];
    const failedRequests = [];

    page.on('console', (message) => {
      if (['error', 'warning'].includes(message.type())) {
        consoleMessages.push({
          type: message.type(),
          text: message.text(),
          location: message.location(),
        });
      }
    });

    page.on('requestfailed', (request) => {
      failedRequests.push({
        url: request.url(),
        method: request.method(),
        failure: request.failure()?.errorText ?? 'unknown',
      });
    });

    page.on('response', (response) => {
      if (response.status() === 404) {
        failedRequests.push({
          url: response.url(),
          method: response.request().method(),
          status: 404,
        });
      }
    });

    await page.goto(`${baseURL}${route}`, { waitUntil: 'networkidle' });

    const axe = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();

    const dom = await page.evaluate(() => {
      const visible = (element) => {
        const style = window.getComputedStyle(element);
        const rect = element.getBoundingClientRect();
        return style.visibility !== 'hidden' && style.display !== 'none' && rect.width > 0 && rect.height > 0;
      };

      const headings = [...document.querySelectorAll('h1,h2,h3,h4,h5,h6')].map((h) => ({
        level: Number(h.tagName.slice(1)),
        text: h.textContent?.trim().replace(/\s+/g, ' ') ?? '',
      }));

      const images = [...document.querySelectorAll('img')].map((img) => ({
        src: img.getAttribute('src'),
        alt: img.getAttribute('alt'),
        ariaHidden: img.closest('[aria-hidden="true"]') !== null || img.getAttribute('aria-hidden') === 'true',
        role: img.getAttribute('role'),
      }));

      const controls = [...document.querySelectorAll('input, select, textarea')].map((control) => {
        const id = control.id;
        const label = id ? document.querySelector(`label[for="${CSS.escape(id)}"]`) : null;
        const wrapped = control.closest('label');
        return {
          tag: control.tagName.toLowerCase(),
          type: control.getAttribute('type'),
          id,
          name: control.getAttribute('name'),
          hasLabel: Boolean(label || wrapped || control.getAttribute('aria-label') || control.getAttribute('aria-labelledby')),
          tabIndex: control.getAttribute('tabindex'),
          ariaHidden: control.closest('[aria-hidden="true"]') !== null,
        };
      });

      const interactive = [...document.querySelectorAll('a[href], button, input, select, textarea, summary, [tabindex]:not([tabindex="-1"])')]
        .filter(visible)
        .map((element) => ({
          tag: element.tagName.toLowerCase(),
          text: element.textContent?.trim().replace(/\s+/g, ' ').slice(0, 80) ?? '',
          href: element.getAttribute('href'),
          ariaLabel: element.getAttribute('aria-label'),
          role: element.getAttribute('role'),
        }));

      return {
        title: document.title,
        h1Count: document.querySelectorAll('h1').length,
        headings,
        landmarks: {
          header: document.querySelectorAll('header').length,
          nav: document.querySelectorAll('nav').length,
          main: document.querySelectorAll('main').length,
          footer: document.querySelectorAll('footer').length,
        },
        skipLink: {
          exists: Boolean(document.querySelector('a[href="#main-content"]')),
          targetExists: Boolean(document.querySelector('#main-content')),
        },
        images,
        controls,
        ariaExpanded: [...document.querySelectorAll('[aria-expanded]')].map((el) => ({
          tag: el.tagName.toLowerCase(),
          value: el.getAttribute('aria-expanded'),
          controls: el.getAttribute('aria-controls'),
        })),
        interactiveCount: interactive.length,
        firstTabStops: interactive.slice(0, 20),
      };
    });

    await page.keyboard.press('Tab');
    const firstFocus = await page.evaluate(() => ({
      tag: document.activeElement?.tagName.toLowerCase(),
      text: document.activeElement?.textContent?.trim().replace(/\s+/g, ' ').slice(0, 80),
      href: document.activeElement?.getAttribute('href'),
      outlineStyle: window.getComputedStyle(document.activeElement).outlineStyle,
      outlineWidth: window.getComputedStyle(document.activeElement).outlineWidth,
    }));

    const screenshot = path.join(evidenceDir, `${name}.png`);
    await page.screenshot({ path: screenshot, fullPage: true });
    await testInfo.attach(`${name}-screenshot`, { path: screenshot, contentType: 'image/png' });

    const output = {
      route,
      url: `${baseURL}${route}`,
      timestamp: new Date().toISOString(),
      axe,
      dom,
      firstFocus,
      consoleMessages,
      failedRequests,
    };

    await fs.writeFile(path.join(rawDir, `${name}.json`), JSON.stringify(output, null, 2));

    expect(axe.violations.filter((v) => v.impact === 'critical')).toHaveLength(0);
    expect(dom.h1Count).toBe(1);
    expect(dom.landmarks.header).toBeGreaterThan(0);
    expect(dom.landmarks.nav).toBeGreaterThan(0);
    expect(dom.landmarks.main).toBe(1);
    expect(dom.landmarks.footer).toBeGreaterThan(0);
    expect(dom.skipLink.exists).toBeTruthy();
    expect(dom.skipLink.targetExists).toBeTruthy();
    expect(failedRequests).toHaveLength(0);
    expect(consoleMessages.filter((m) => m.type === 'error')).toHaveLength(0);
  });
}
