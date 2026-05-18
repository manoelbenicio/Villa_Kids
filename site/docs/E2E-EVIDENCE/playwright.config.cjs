const { defineConfig } = require('@playwright/test');
module.exports = defineConfig({
  testDir: '.',
  timeout: 30000,
  workers: 1,
  reporter: [['json', { outputFile: 'docs/E2E-EVIDENCE/playwright-results.json' }]],
  use: {
    channel: 'chrome',
    headless: true,
    viewport: { width: 1440, height: 1000 },
    ignoreHTTPSErrors: true
  }
});
