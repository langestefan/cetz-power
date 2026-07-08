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
      description:
        'Power-system single-line diagrams in Typst, on top of CeTZ.',
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
        {
          icon: 'github',
          label: 'GitHub',
          href: 'https://github.com/langestefan/cetz-power',
        },
      ],
      editLink: {
        baseUrl: 'https://github.com/langestefan/cetz-power/edit/main/docs/',
      },
      sidebar: [
        {
          label: 'Getting started',
          items: [
            { label: 'Installation', slug: 'getting-started/installation' },
            {
              label: 'Your first diagram',
              slug: 'getting-started/first-diagram',
            },
            { label: 'Anchors', slug: 'getting-started/anchors' },
            {
              label: 'One- vs two-node placement',
              slug: 'getting-started/placement',
            },
            { label: 'Styling', slug: 'getting-started/styling' },
            { label: 'Labels', slug: 'getting-started/labels' },
            { label: 'Wires and elbows', slug: 'getting-started/wires' },
          ],
        },
        {
          label: 'Symbol reference',
          items: [
            {
              label: 'Grid',
              items: [
                { label: 'Overview', slug: 'symbols/grid' },
                { label: 'Bus', slug: 'symbols/grid/bus' },
                { label: 'Wires', slug: 'symbols/grid/wire' },
                { label: 'Junction', slug: 'symbols/grid/junction' },
                { label: 'External grid', slug: 'symbols/grid/external-grid' },
                { label: 'Transformer', slug: 'symbols/grid/transformer' },
                {
                  label: 'Transformer (3-winding)',
                  slug: 'symbols/grid/transformer3',
                },
                {
                  label: 'Autotransformer',
                  slug: 'symbols/grid/autotransformer',
                },
                { label: 'Current transformer', slug: 'symbols/grid/ct' },
                { label: 'Voltage transformer', slug: 'symbols/grid/vt' },
              ],
            },
            {
              label: 'Winding configurations',
              items: [
                { label: 'Overview', slug: 'symbols/winding' },
                { label: 'Delta', slug: 'symbols/winding/delta' },
                { label: 'Wye / star', slug: 'symbols/winding/wye' },
                { label: 'Zigzag', slug: 'symbols/winding/zigzag' },
              ],
            },
            {
              label: 'Generation',
              items: [
                { label: 'Overview', slug: 'symbols/generation' },
                { label: 'Machine', slug: 'symbols/generation/machine' },
                { label: 'PV panel', slug: 'symbols/generation/pv-panel' },
                { label: 'Device block', slug: 'symbols/generation/block' },
                { label: 'Generation plant', slug: 'symbols/generation/plant' },
              ],
            },
            {
              label: 'Loads',
              items: [
                { label: 'Overview', slug: 'symbols/loads' },
                { label: 'Load', slug: 'symbols/loads/load' },
                { label: 'Factory', slug: 'symbols/loads/factory' },
                { label: 'EV charger', slug: 'symbols/loads/ev-charger' },
              ],
            },
            {
              label: 'Electrical components',
              items: [
                { label: 'Overview', slug: 'symbols/electrical' },
                { label: 'Capacitor', slug: 'symbols/electrical/capacitor' },
                { label: 'Resistor', slug: 'symbols/electrical/resistor' },
                { label: 'Inductor', slug: 'symbols/electrical/inductor' },
                { label: 'Diode', slug: 'symbols/electrical/diode' },
                {
                  label: 'Voltage source',
                  slug: 'symbols/electrical/voltagesource',
                },
                {
                  label: 'Current source',
                  slug: 'symbols/electrical/currentsource',
                },
                { label: 'Ground', slug: 'symbols/electrical/ground' },
                { label: 'Battery', slug: 'symbols/electrical/battery' },
                { label: 'Converter', slug: 'symbols/electrical/converter' },
              ],
            },
            {
              label: 'Control',
              items: [
                { label: 'Overview', slug: 'symbols/control' },
                { label: 'Adder', slug: 'symbols/control/adder' },
                { label: 'Mixer', slug: 'symbols/control/mixer' },
              ],
            },
            {
              label: 'Protection & switching',
              items: [
                { label: 'Overview', slug: 'symbols/protection' },
                { label: 'Switch', slug: 'symbols/protection/switch' },
                {
                  label: 'Circuit breaker',
                  slug: 'symbols/protection/breaker',
                },
                { label: 'Fuse', slug: 'symbols/protection/fuse' },
                { label: 'Relay', slug: 'symbols/protection/relay' },
                {
                  label: 'Surge arrester',
                  slug: 'symbols/protection/arrester',
                },
              ],
            },
          ],
        },
        {
          label: 'Composition helpers',
          items: [
            { label: 'Feeder', slug: 'helpers/feeder' },
            { label: 'Bus run', slug: 'helpers/bus-run' },
            { label: 'DALI metering unit', slug: 'helpers/dali' },
            { label: 'Flow arrow', slug: 'helpers/flow-arrow' },
            { label: 'Area box', slug: 'helpers/area' },
            { label: 'Phase ticks', slug: 'helpers/phase-ticks' },
          ],
        },
        {
          label: 'Extending',
          items: [
            {
              label: 'Creating your own symbol',
              slug: 'extending/custom-symbol',
            },
            {
              label: 'Composing with regular CeTZ',
              slug: 'extending/composing-with-cetz',
            },
          ],
        },
        {
          label: 'Recipes',
          items: [
            {
              label: 'Fundamentals',
              items: [
                { label: 'Radial feeder', slug: 'recipes/radial-feeder' },
                {
                  label: 'Parallel transformers',
                  slug: 'recipes/parallel-transformers',
                },
                { label: 'Phase-to-earth fault', slug: 'recipes/phase-fault' },
                {
                  label: 'MV cable equivalent',
                  slug: 'recipes/mv-cable-equivalent',
                },
                {
                  label: 'Feeder compensation',
                  slug: 'recipes/feeder-compensation',
                },
                { label: 'MV transport link', slug: 'recipes/ms-transport' },
                {
                  label: 'Reactive power flow',
                  slug: 'recipes/reactive-flow',
                },
              ],
            },
            {
              label: 'Generation & control',
              items: [
                { label: 'Wind turbine', slug: 'recipes/wind-turbine' },
                {
                  label: 'Wind turbine (DFIG)',
                  slug: 'recipes/wind-turbine-dfig',
                },
                {
                  label: 'Grid-side converter control',
                  slug: 'recipes/gsc-control',
                },
                {
                  label: 'Hybrid renewable park',
                  slug: 'recipes/hybrid-park',
                },
              ],
            },
            {
              label: 'Distribution networks',
              items: [
                {
                  label: 'MV radial distribution feeder',
                  slug: 'recipes/mv-radial-feeder',
                },
                {
                  label: 'Urban LV grid (34 buses)',
                  slug: 'recipes/urban-lv',
                },
                {
                  label: 'Distribution rings (hoofdring)',
                  slug: 'recipes/distribution-rings',
                },
                {
                  label: 'LV service connections',
                  slug: 'recipes/lv-service-connections',
                },
              ],
            },
            {
              label: 'Benchmark networks',
              items: [
                {
                  label: 'Modified CIGRE LV network',
                  slug: 'recipes/cigre-lv',
                },
                {
                  label: 'Modified CIGRE MV network',
                  slug: 'recipes/cigre-mv',
                },
                {
                  label: 'Modified IEEE 9-bus with DVPP',
                  slug: 'recipes/ieee9-dvpp',
                },
                {
                  label: 'IEEE 9-bus with GFM converters',
                  slug: 'recipes/ieee9-gfm',
                },
                {
                  label: 'IEEE 13-bus feeder with DER',
                  slug: 'recipes/ieee13-der',
                },
              ],
            },
          ],
        },
      ],
      customCss: ['./src/styles/snippet.css'],
    }),
  ],
});
