const { test, expect } = require('@playwright/test');
const { AxeBuilder } = require('@axe-core/playwright');
const fs = require('fs');
const path = require('path');
const routes = ['/', '/proposta-pedagogica/', '/turmas/', '/estrutura/', '/tecnologia/', '/seguranca/', '/contato/', '/matriculas/', '/politica-de-privacidade/'];
const slug = route => route === '/' ? 'home' : route.replace(/^\//, '').replace(/\/$/, '').replaceAll('/', '-');
for (const route of routes) {
  test(`axe ${route}`, async ({ page }) => {
    await page.goto(`http://localhost:4321${route}`, { waitUntil: 'networkidle' });
    const results = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa']).analyze();
    fs.writeFileSync(path.join('docs', 'a11y-raw', `${slug(route)}.json`), JSON.stringify(results, null, 2));
    const critical = results.violations.filter(v => v.impact === 'critical');
    const serious = results.violations.filter(v => v.impact === 'serious');
    const h1Count = await page.locator('h1').count();
    const hasMain = await page.locator('main').count();
    const hasFooter = await page.locator('footer').count();
    const hasHeader = await page.locator('header').count();
    const hasNav = await page.locator('nav').count();
    expect(h1Count, `${route} h1 count`).toBe(1);
    expect(hasMain, `${route} main`).toBeGreaterThan(0);
    expect(hasFooter, `${route} footer`).toBeGreaterThan(0);
    expect(hasHeader, `${route} header`).toBeGreaterThan(0);
    expect(hasNav, `${route} nav`).toBeGreaterThan(0);
    expect(critical, `${route} critical axe`).toEqual([]);
    expect(serious, `${route} serious axe`).toEqual([]);
  });
}
