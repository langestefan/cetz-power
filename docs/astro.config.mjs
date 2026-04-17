// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  // GitHub Pages project page at https://langestefan.github.io/cetz-power/
  // (drop `base` if you ever rehome to a user/org root page).
  site: 'https://langestefan.github.io',
  base: '/cetz-power',

  integrations: [
    starlight({
      title: 'powergretz',
      description: 'Power-system single-line diagrams in Typst, on top of CeTZ.',
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
            { label: 'Transformer', slug: 'symbols/transformer' },
            { label: 'Load', slug: 'symbols/load' },
            { label: 'PV panel', slug: 'symbols/pv-panel' },
          ],
        },
        {
          label: 'Recipes',
          items: [
            { label: 'Radial feeder', slug: 'recipes/radial-feeder' },
            { label: 'Simple SLD', slug: 'recipes/simple-sld' },
          ],
        },
      ],
      customCss: ['./src/styles/snippet.css'],
    }),
  ],
});
