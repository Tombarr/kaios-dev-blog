# Contributing to KaiOS.dev

Thank you for your interest in contributing to KaiOS.dev! Whether it's bug reports, content improvements, or new features, all contributions are welcome.

## Types of Contributions

### Blog Post Content

Contributions of new technical articles, corrections to existing articles, or guest submissions.

**License:** Content contributions are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

**What to contribute:**
- New technical articles about KaiOS development
- Corrections and updates to existing articles
- Translations of existing content
- Guest developer showcases

**Process:**
1. Fork the repository
2. Create a new branch: `git checkout -b post/your-post-title`
3. Add your content to `content/posts/` using proper frontmatter:
   ```toml
   +++
   title = "Your Post Title"
   description = "Brief description"
   date = 2025-01-26T00:00:00+08:00
   toc = true
   draft = false
   header_img = "img/home-alt.png"
   tags = ["KaiOS", "Tag1", "Tag2"]
   categories = []
   series = ["Series Name"]
   +++
   ```
4. Test locally: `hugo server --bind 0.0.0.0`
5. Submit a pull request

**Content Guidelines:**
- Focus on KaiOS development and technical learning
- Include proper attribution for external sources
- Use code examples where helpful
- Add appropriate tags and series classification
- Optimize images for 240x320 screens when showing KaiOS screenshots

### Code & Infrastructure

Bug fixes, performance optimizations, workflow automation, and template improvements.

**License:** Code contributions are licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

**What to contribute:**
- Bug fixes and improvements
- Performance optimizations
- GitHub Actions workflow enhancements
- Layout and template improvements
- DevContainer configuration updates
- Build and deployment improvements

**Process:**
1. Fork the repository
2. Create a new branch: `git checkout -b fix/issue-description` or `git checkout -b feature/feature-name`
3. Make your changes
4. Test thoroughly locally
5. Submit a pull request with a clear description

**Code Standards:**
- Maintain existing code style and conventions
- Test locally in the DevContainer or with Hugo
- Update documentation when adding new features
- Follow Hugo and web development best practices
- Keep accessibility in mind for templates

### Documentation & Corrections

README improvements, license clarifications, development setup guides, and issue reports.

**License:** Documentation contributions follow the same model as the underlying content (content-related docs = CC BY 4.0, code-related docs = Apache 2.0)

**What to contribute:**
- Typo fixes and corrections
- README enhancements
- Setup guide improvements
- Bug reports with reproduction steps
- Feature suggestions

## Getting Started

### Prerequisites

- **Docker** (for DevContainer) OR **Hugo** extended version locally
- **Git**
- **GitHub account**

### Local Setup

#### Option 1: DevContainer (Recommended)

The easiest way to get started is using the DevContainer configuration:

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Install [VS Code](https://code.visualstudio.com/)
3. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
4. Clone the repository:
   ```bash
   git clone https://github.com/Tombarr/kaios-dev-blog.git
   cd kaios-dev-blog
   ```
5. Open in VS Code: `code .`
6. Press `F1` and select "Dev Containers: Reopen in Container"
7. Wait for the container to build (first time only)
8. Hugo server will start automatically at http://localhost:1313

#### Option 2: Manual Setup

If you prefer to run Hugo locally:

1. Install Hugo Extended:
   - **macOS:** `brew install hugo`
   - **Windows:** `choco install hugo-extended`
   - **Linux:** Download from [Hugo releases](https://github.com/gohugoio/hugo/releases)

2. Verify installation:
   ```bash
   hugo version  # Should show v0.120+ with extended
   ```

3. Clone and run:
   ```bash
   git clone https://github.com/Tombarr/kaios-dev-blog.git
   cd kaios-dev-blog
   git submodule update --init --recursive  # Initialize theme
   hugo server --bind 0.0.0.0 --buildDrafts --buildFuture
   ```

4. Visit http://localhost:1313

### Creating New Content

Use Hugo's content creation command:

```bash
hugo new posts/your-post-title.md
```

This creates a new post in `content/posts/` with the correct frontmatter template.

## Development Workflow

### Testing Your Changes

Before submitting a pull request:

1. **Test the build:**
   ```bash
   hugo --minify
   ```

2. **Check for typos:**
   ```bash
   typos
   ```
   Or use VS Code task: `Tasks: Run Task` → `Typos: Check`

3. **Verify locally:**
   - View your changes in the browser
   - Test on different screen sizes
   - Check that all links work
   - Verify code syntax highlighting

### Pull Request Guidelines

1. **Title:** Use a clear, descriptive title
   - Content: `docs: add guide for KaiOS geolocation API`
   - Code: `fix: correct mobile navbar responsive styling`
   - Chore: `chore: update Hugo to v0.121.0`

2. **Description:** Include:
   - What problem you're solving
   - How your solution works
   - Screenshots (if UI changes)
   - Testing steps you've performed
   - Related issues (use `Fixes #123` to auto-close)

3. **Commits:**
   - Write clear commit messages
   - Keep commits focused and atomic
   - Squash commits if needed before final merge

4. **Review Process:**
   - Expect feedback and be ready to iterate
   - Respond to review comments
   - Make requested changes in new commits
   - Once approved, changes will be merged to `main`

### Code Review

We review pull requests for:

- **Technical correctness** — Does it work as intended?
- **Code quality** — Is it maintainable and well-structured?
- **Consistency** — Does it match existing patterns and style?
- **License compliance** — Is the licensing clear?
- **Documentation** — Are changes documented appropriately?
- **Security** — Are there any security implications?
- **Performance** — Will it impact site build time or load time?

## License Acknowledgment

**Important:** By submitting a pull request, you agree that your contribution will be licensed under the appropriate license for that content type:

- **Content** (Markdown posts, articles) → Licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- **Code** (templates, scripts, configuration) → Licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

For detailed licensing information, see [LICENSES.md](LICENSES.md).

## Questions or Need Help?

- **Licensing questions:** See [LICENSES.md](LICENSES.md)
- **Technical questions:** Open an issue with the `question` label
- **Bug reports:** Open an issue with reproduction steps
- **Feature requests:** Open an issue describing the use case
- **General discussion:** Use GitHub Discussions

## Resources

- [Hugo Documentation](https://gohugo.io/documentation/)
- [Markdown Guide](https://www.markdownguide.org/)
- [KaiOS Developer Portal](https://developer.kaiostech.com/)
- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)

Thank you for contributing to KaiOS.dev! Your contributions help developers worldwide build better applications for KaiOS devices.
