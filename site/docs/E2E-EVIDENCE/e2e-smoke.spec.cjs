const { test, expect } = require('@playwright/test');
const routes = ['/', '/proposta-pedagogica/', '/turmas/', '/estrutura/', '/tecnologia/', '/seguranca/', '/contato/', '/matriculas/', '/politica-de-privacidade/'];
for (const route of routes) {
  test(`smoke ${route}`, async ({ page }) => {
    const errors = [];
    const failedResponses = [];
    page.on('console', msg => { if (msg.type() === 'error') errors.push(msg.text()); });
    page.on('pageerror', err => errors.push(err.message));
    page.on('response', res => { if (res.status() >= 400) failedResponses.push(`${res.status()} ${res.url()}`); });
    const response = await page.goto(`http://localhost:4321${route}`, { waitUntil: 'networkidle' });
    expect(response && response.status(), `${route} HTTP status`).toBeLessThan(400);
    await expect(page.locator('main')).toBeVisible();
    await expect(page.locator('h1')).toHaveCount(1);
    await expect(page.locator('nav').first()).toBeVisible();
    await expect(page.locator('footer')).toBeVisible();
    const screenshotName = route === '/' ? 'home' : route.replaceAll('/', '');
    await page.screenshot({ path: `docs/E2E-EVIDENCE/${screenshotName}-desktop.png`, fullPage: false });
    expect(errors.filter(e => !/favicon/i.test(e)), `${route} console errors`).toEqual([]);
    expect(failedResponses, `${route} failed responses`).toEqual([]);
  });
}
