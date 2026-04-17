// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  // Update these for your GitHub Pages URL. For a project page hosted at
  // https://<user>.github.io/powergretz/ keep `base: '/powergretz'`. For a
  // user/organisation page (https://<user>.github.io/) drop the base.
  site: 'https://langestefan.github.io',
  base: '/powergretz',

  integrations: [
    starlight({
      title: 'powergretz',
      description: 'Power-system single-line diagrams in Typst, on top of CeTZ.',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/langestefan/powergretz' },
      ],
      editLink: {
        baseUrl: 'https://github.com/langestefan/powergretz/edit/main/docs-site/',
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
