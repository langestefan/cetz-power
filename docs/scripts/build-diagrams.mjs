// Compiles every Typst snippet under `snippets/` to an SVG under
// `public/diagrams/`. Skips snippets whose existing SVG is newer than
// the source (incremental builds).
//
// Run from inside `docs-site/`:
//   node scripts/build-diagrams.mjs
//
// CI invokes this via `npm run build:diagrams` before `astro build`.

import { spawnSync } from 'node:child_process';
import { readdirSync, statSync, mkdirSync, existsSync } from 'node:fs';
import { join, basename, extname, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const docsSite = resolve(__dirname, '..');
const repoRoot = resolve(docsSite, '..');
const snippetsDir = join(docsSite, 'snippets');
const outDir = join(docsSite, 'public', 'diagrams');

mkdirSync(outDir, { recursive: true });

const snippets = readdirSync(snippetsDir)
  .filter((f) => extname(f) === '.typ')
  .sort();

if (snippets.length === 0) {
  console.error(`No .typ snippets found in ${snippetsDir}`);
  process.exit(1);
}

let built = 0;
let skipped = 0;
let failed = 0;

for (const file of snippets) {
  const name = basename(file, '.typ');
  const src = join(snippetsDir, file);
  const dst = join(outDir, `${name}.svg`);

  if (existsSync(dst) && statSync(dst).mtimeMs > statSync(src).mtimeMs) {
    skipped += 1;
    continue;
  }

  const result = spawnSync(
    'typst',
    ['compile', '--root', repoRoot, '--format', 'svg', src, dst],
    { stdio: ['ignore', 'inherit', 'inherit'] },
  );
  if (result.status !== 0) {
    console.error(`\n✗ failed to compile ${file}`);
    failed += 1;
    continue;
  }
  built += 1;
}

const total = snippets.length;
console.log(
  `\nDiagrams: ${built} built, ${skipped} unchanged, ${failed} failed (of ${total})`,
);
process.exit(failed === 0 ? 0 : 1);
