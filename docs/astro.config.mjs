// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

// Vendored Typst grammar (originally shipped by the typst-lsp VS Code
// extension). Far richer than Shiki's bundled `typst` grammar — it
// emits the same scopes the VS Code Typst extension does, so paired
// with the `dark-plus` / `light-plus` themes the highlighting matches
// what users see in their editor.
const typstGrammar = JSON.parse(
  readFileSync(
    fileURLToPath(new URL('./syntaxes/typst.tmLanguage.json', import.meta.url)),
    'utf8',
  ),
);

// https://astro.build/config
export default defineConfig({
  // GitHub Pages project page at https://langestefan.github.io/cetz-power/
  // (drop `base` if you ever rehome to a user/org root page).
  site: 'https://langestefan.github.io',
  base: '/cetz-power',

  integrations: [
    starlight({
      title: 'cetz-power',
      description: 'Power-system single-line diagrams in Typst, on top of CeTZ.',
      // Starlight uses Expressive Code, which keeps its own Shiki
      // language registry. Register the vendored Typst grammar (it
      // overrides Shiki's bundled one) and pin the themes to VS
      // Code's defaults so the rendered colors match what users see
      // in their editor.
      expressiveCode: {
        themes: ['dark-plus', 'light-plus'],
        shiki: {
          langs: [{ ...typstGrammar, name: 'typst' }],
          langAlias: { typ: 'typst' },
        },
      },
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/langestefan/cetz-power' },
      ],
      editLink: {
        baseUrl: 'https://github.com/langestefan/cetz-power/edit/main/docs/',
      },
      sidebar: [
        {
          label: 'Getting started',
          items: [
            { label: 'Installation', slug: 'getting-started/installation' },
            { label: 'Your first diagram', slug: 'getting-started/first-diagram' },
            { label: 'Anchors', slug: 'getting-started/anchors' },
            { label: 'One- vs two-node placement', slug: 'getting-started/placement' },
            { label: 'Styling', slug: 'getting-started/styling' },
            { label: 'Labels', slug: 'getting-started/labels' },
            { label: 'Wires and elbows', slug: 'getting-started/wires' },
          ],
        },
        {
          label: 'Symbol reference',
          items: [
            { label: 'Bus', slug: 'symbols/bus' },
            { label: 'Wires', slug: 'symbols/wire' },
            { label: 'External grid', slug: 'symbols/external-grid' },
            { label: 'Machine', slug: 'symbols/machine' },
            { label: 'Transformer', slug: 'symbols/transformer' },
            { label: 'Load', slug: 'symbols/load' },
            { label: 'PV panel', slug: 'symbols/pv-panel' },
          ],
        },
        {
          label: 'Recipes',
          items: [
            { label: 'Radial feeder', slug: 'recipes/radial-feeder' },
            { label: 'Wind turbine', slug: 'recipes/wind-turbine' },
          ],
        },
      ],
      customCss: ['./src/styles/snippet.css'],
    }),
  ],
});
