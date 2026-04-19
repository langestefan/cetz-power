// Runs the snippet watcher and `astro dev` side by side so editing a
// file under `snippets/` automatically rebuilds its SVG and triggers a
// Vite page reload. `Ctrl+C` tears both children down together.

import { spawn } from 'node:child_process';

const opts = { stdio: 'inherit', shell: true };
const children = [
  spawn('node --watch-path=./snippets scripts/build-diagrams.mjs', [], opts),
  spawn('astro dev', [], opts),
];

let shuttingDown = false;
const shutdown = (code) => {
  if (shuttingDown) return;
  shuttingDown = true;
  for (const c of children) c.kill('SIGTERM');
  process.exit(code);
};

process.on('SIGINT', () => shutdown(0));
process.on('SIGTERM', () => shutdown(0));
for (const c of children) c.on('exit', (code) => shutdown(code ?? 0));
