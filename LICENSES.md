# Licensing

This project uses a dual-licensing model to balance open content sharing with code reusability.

## Quick Reference

| Content Type | License | File Locations |
|--------------|---------|----------------|
| Blog posts & written content | CC BY 4.0 | `content/posts/`, `content/about/`, `content/faq/`, `content/privacy/` |
| Code, scripts, templates | Apache 2.0 | `layouts/`, `static/js/`, `static/css/`, `.github/workflows/` |
| Configuration files | Apache 2.0 | `hugo.toml`, `_typos.toml`, `.devcontainer/`, `.vscode/` |
| Theme | Apache 2.0 | `themes/puppet/` (see [`themes/puppet/LICENSE`](https://github.com/roninro/hugo-theme-puppet/blob/master/LICENSE)) |

## Full License Texts

### Creative Commons Attribution 4.0 International (Content)

**Applies to:** All content in `content/` directory (Markdown files and source material), and all images in the `static/` directory

**You are free to:**
- **Share** — copy and redistribute the material in any medium or format
- **Adapt** — remix, transform, and build upon the material for any purpose, even commercially

**Under these conditions:**
- **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- **No additional restrictions** — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

**Official License:** https://creativecommons.org/licenses/by/4.0/

**Full Legal Text:** https://creativecommons.org/licenses/by/4.0/legalcode

### Apache License 2.0 (Code)

**Applies to:** All code, configuration, templates, and infrastructure

**You are free to:**
- **Use** — use the software for any purpose
- **Modify** — modify the software
- **Distribute** — distribute the original or modified software
- **Sublicense** — grant rights to the software
- **Commercial use** — use the software for commercial purposes
- **Private use** — use the software for private purposes

**Under these conditions:**
- **License and copyright notice** — Include a copy of the license and copyright notice with the software
- **State changes** — Document any changes made to the software
- **Notice** — If the software includes a NOTICE file, you must include it in distributions

**Official License:** https://www.apache.org/licenses/LICENSE-2.0

**Full Legal Text:** https://www.apache.org/licenses/LICENSE-2.0.txt

## Contributing

When contributing to this project, please be aware of the licensing implications:

### Content Contributions

Pull requests with new blog posts or content updates are licensed under **CC BY 4.0**.

**What this means:**
- Your contributed content can be freely shared and adapted by others
- You will be attributed in the commit history and/or article byline
- By contributing, you agree to license your contribution under CC BY 4.0
- You retain copyright to your original work

**Examples:**
- New blog posts in `content/posts/`
- Updates to existing articles
- FAQ entries

### Code/Infrastructure Contributions

Pull requests with code, templates, or configuration changes are licensed under **Apache 2.0**.

**What this means:**
- Your code can be used, modified, and distributed (including commercially)
- Contributors are acknowledged in commit history
- By contributing, you agree to license your contribution under Apache 2.0
- You retain copyright to your original work

**Examples:**
- Hugo templates in `layouts/`
- JavaScript or CSS files
- GitHub Actions workflows
- DevContainer configuration
- Build scripts

### Mixed Contributions

If your contribution includes both content and code (e.g., a blog post with accompanying custom shortcode), the appropriate license applies to each part separately:
- The blog post content → CC BY 4.0
- The shortcode implementation → Apache 2.0

## Why This Licensing Model?

### Content: CC BY 4.0
Encourages educational sharing while ensuring attribution to original authors. This license is perfect for technical documentation and tutorials that others may want to adapt for their own contexts, remix into derivative works, or translate into other languages.

### Code: Apache 2.0
This license is compatible with most other open source licenses and is well-understood by the developer community.

## Copyright Information

Copyright © 2023-2025 Last Byte LLC

Individual contributors retain copyright to their contributions while granting the above licenses.

## Third-Party Licenses

This project includes third-party components with their own licenses:

### Puppet Theme
- **License:** Apache 2.0
- **Copyright:** [roninro](https://github.com/roninro/) (Hugo port), [Huxpro](https://github.com/huxpro) (original Hux Blog design)
- **Location:** `themes/puppet/LICENSE`

### Bootstrap
- **License:** MIT
- **Copyright:** Twitter, Inc. (2011-2019)
- **Included in:** Theme dependencies

### Other Dependencies
See theme LICENSE file and JavaScript library headers for complete third-party attribution.

## Questions?

For licensing clarifications:
1. Review this document
2. Consult the LICENSE file (code) in the root directory
3. Check the footer at https://kaios.dev for visitor-facing licensing information
4. Open an issue on GitHub for further discussion

## Additional Resources

- [Creative Commons BY 4.0 FAQ](https://creativecommons.org/faq/)
- [Apache License 2.0 FAQ](https://www.apache.org/foundation/license-faq.html)
- [Choose a License Guide](https://choosealicense.com/)
- [GitHub Licensing Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)
