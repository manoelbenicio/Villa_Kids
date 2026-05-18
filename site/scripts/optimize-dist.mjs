import { brotliCompressSync, gzipSync } from 'node:zlib';
import { mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { extname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { minify } from 'html-minifier-terser';

const distDir = fileURLToPath(new URL('../dist/', import.meta.url));
const compressible = new Set(['.html', '.css', '.js', '.xml', '.txt', '.svg', '.json']);

function walk(dir) {
  return readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const file = join(dir, entry.name);
    return entry.isDirectory() ? walk(file) : [file];
  });
}

const files = walk(distDir);

for (const file of files.filter((file) => extname(file) === '.html')) {
  const source = readFileSync(file, 'utf8');
  const optimized = await minify(source, {
    collapseBooleanAttributes: true,
    collapseWhitespace: true,
    decodeEntities: false,
    minifyCSS: true,
    minifyJS: true,
    removeAttributeQuotes: false,
    removeComments: true,
    removeEmptyAttributes: false,
  });
  writeFileSync(file, optimized);
}

mkdirSync(join(distDir, '.compressed'), { recursive: true });

for (const file of walk(distDir).filter((file) => compressible.has(extname(file)))) {
  const relative = file.slice(distDir.length).replaceAll('\\', '/');
  if (relative.startsWith('.compressed/')) continue;

  const source = readFileSync(file);
  writeFileSync(`${file}.gz`, gzipSync(source, { level: 9 }));
  writeFileSync(`${file}.br`, brotliCompressSync(source));
}

const total = walk(distDir).reduce((sum, file) => sum + statSync(file).size, 0);
writeFileSync(join(distDir, '.compressed', 'manifest.json'), JSON.stringify({ totalBytes: total }, null, 2));
