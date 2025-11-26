# [KaiOS.dev](https://kaios.dev)

[KaiOS.dev](https://kaios.dev) is a [Hugo](https://gohugo.io/) static site hosted on Cloudflare Pages focused on [KaiOS](https://kaiostech.com) development. It is written by [Tom Barrasso](https://barrasso.me), a KaiOS and [Cloud Phone](https://cloudphone.tech) developer.

## Dev Environment

This project includes a [DevContainer](https://containers.dev/) setup with Hugo, [Typos](https://crates.io/crates/typos), and uses the [Puppet](https://github.com/roninro/hugo-theme-puppet/) theme. DevContainers require [Docker](https://docker.io/), otherwise you can install Hugo locally and build directly on your machine.

### Local Server

```bash
hugo server --bind 0.0.0.0 --disableFastRender --noHTTPCache
```

Run local development server with live reload. The site will be available at [http://localhost:1313](http://localhost:1313).

### Building

```bash
hugo --minify --gc--cleanDestinationDir --environment production
```

This builds the website, including all HTML, CSS, and JavaScript, in the default `public/` directory.

## Contributions

Edits and corrections are welcome. File an [Issue](https://github.com/Tombarr/kaios-dev-blog/issues) or open a [Pull Request](https://github.com/Tombarr/kaios-dev-blog/pulls). Guest submissions focused on KaiOS development will be considered, but at the discretion of the author.

For contribution guidelines, local setup instructions, and licensing information, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Deployment

This site is deployed to [KaiOS.dev](https://kaios.dev), hosted on Cloudflare Pages, and built automatically using a [GitHub Action](.github/workflows/deploy.yml) on pushes to the `main` branch.

## Legal

The content of this website is licensed under the [Creative Commons Attribution 4.0 License](https://creativecommons.org/licenses/by/4.0/), and code samples are licensed under the [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0). External images are sourced primarily from the public domain and are the property of their respective owners. Best effort is made to provide links and citations where possible. Code samples are provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement.

For detailed licensing information, including what license applies to which files and contribution guidelines, see [LICENSES.md](LICENSES.md).
