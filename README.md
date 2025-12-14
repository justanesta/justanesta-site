# justanesta.com - Portfolio & Blog

Personal portfolio and blog site built with 11ty, Bulma CSS, and Pagefind search. Deployed on Cloudflare Pages with automated workflows for content creation.

**📖 Read time: 3 minutes**

---

## Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm start
# → http://localhost:8080

# Build for production
npm run build
```

---

## Creating Content

### New Blog Post

**Using the automation script:**
```bash
# Via npm script (recommended)
npm run new:post

# Or run directly with bash
./scripts/new-post.sh
```

The script will:
1. Prompt for title, category, description, and tags
2. Generate URL-friendly slug from title
3. Create markdown file with proper front matter in `src/blog/`
4. Create thumbnail directory at `src/public/images/posts/[slug]/`
5. Update `src/_data/thumbnails.js` with entry
6. Open file in your editor

**What you do next:**
1. Write your post content in the generated markdown file
2. Add thumbnail image (1200×675px, under 100KB) to the created directory
3. Update the alt text in `src/_data/thumbnails.js`

**Manual creation:**
Create `src/blog/my-post.md`:
```markdown
---
layout: layouts/post.njk
title: "My Post Title"
date: 2025-01-15
category: "Economics"
description: "Brief summary"
tags:
  - Economics
  - Data Analysis
  - post
---

Your content here...
```

### New Project

```bash
# Via npm script
npm run new:project

# Or run directly with bash
./scripts/new-project.sh
```

Prompts for project details, creates entry in `src/_data/projects.js`, thumbnail directory, and thumbnails.js entry.

### New Clip (Published Work)

```bash
# Via npm script
npm run new:clip

# Or run directly with bash
./scripts/new-clip.sh
```

Prompts for article details, adds to `src/_data/clips.js` grouped by publication.

### Optimize Images

```bash
# Check images for size/dimension issues
npm run optimize
# Or: ./scripts/optimize-images.sh

# Automatically fix issues
npm run optimize:fix
# Or: ./scripts/optimize-images.sh --fix
```

Standards:
- **Blog posts**: 1200×675px, under 100KB
- **Projects**: 256×256px (square), under 50KB

---

## npm vs npx Commands

### npm commands (from package.json scripts)
```bash
npm start              # Start dev server
npm run build          # Build production site + search index
npm run new:post       # Create new blog post
npm run new:project    # Create new project
npm run new:clip       # Add published work
npm run optimize       # Check image sizes
npm run optimize:fix   # Optimize images
```

### npx commands (run packages directly)
```bash
npx @11ty/eleventy --serve     # What npm start does
npx @11ty/eleventy             # Build site only
npx pagefind --site _site      # Build search index only
```

### bash commands (run scripts directly)
```bash
./scripts/new-post.sh           # Create blog post
./scripts/new-project.sh        # Add project
./scripts/new-clip.sh           # Add clip
./scripts/optimize-images.sh    # Check images
./scripts/optimize-images.sh --fix  # Fix images
```

**Difference:**
- `npm run [script]` → Runs scripts defined in package.json
- `npx [package]` → Executes npm packages directly without installing globally
- `./scripts/[script].sh` → Runs bash scripts directly

---

## Tech Stack

### Core
- **11ty (Eleventy) v3.0** - Static site generator, processes templates and markdown
- **Nunjucks** - Templating language for HTML layouts
- **Bulma v1.0** - CSS framework (no JavaScript)
- **Pagefind v1.4** - Static search (client-side, no server needed)

### Extra
- **Custom CSS** - Dark mode, blog styling, archive tabs (`src/css/custom.css`)
- **Custom JS** - Navbar toggle, archive tabs, search interface (`src/js/`)
- **Font Awesome** - Icons (CDN)

---

## Architecture & File Structure

### How 11ty Works

1. **Input** (`src/` folder):
   - Templates (`.njk` files) define page structure
   - Markdown (`.md` files) contain blog posts
   - Data files (`.js` in `src/_data/`) provide site-wide data
   - Static assets (CSS, JS, images)

2. **Processing** (`.eleventy.js` config):
   - Collections group content (posts by year/category/tag)
   - Filters transform data (dates, thumbnails)
   - Templates render with data
   - Markdown converts to HTML

3. **Output** (`_site/` folder):
   - Static HTML files
   - Optimized for deployment
   - Pagefind builds search index

### Directory Structure

```
justanesta-site/
├── .eleventy.js              # 11ty configuration, collections, filters
├── package.json              # Dependencies and npm scripts
├── scripts/                  # Automation scripts
│   ├── new-post.sh          # Create blog posts
│   ├── new-project.sh       # Add projects
│   ├── new-clip.sh          # Add clips
│   └── optimize-images.sh   # Image optimization
│
└── src/                      # Source files (input)
    ├── _data/               # Global data (available to all templates)
    │   ├── site.js         # Site metadata, nav, social links
    │   ├── projects.js     # Project collection
    │   ├── skills.js       # Skill definitions + lookup methods
    │   ├── clips.js        # Published work collection
    │   └── thumbnails.js   # Image paths and alt text
    │
    ├── _includes/           # Reusable templates
    │   ├── base.njk        # Main layout (header, footer, nav)
    │   ├── layouts/        # Page-specific layouts
    │   │   ├── post.njk   # Blog post layout
    │   │   └── home.njk   # Homepage layout
    │   └── partials/       # Reusable components
    │       ├── blog-card.njk
    │       ├── project-card.njk
    │       └── social-buttons.njk
    │
    ├── blog/                # Blog posts (markdown)
    │   └── *.md            # Individual posts
    │
    ├── archive/             # Archive page (year/category/tag views)
    ├── projects/            # Projects page
    ├── clips/              # Published work page
    ├── about/              # About page
    │
    ├── css/                # Stylesheets
    │   └── custom.css     # Custom styles (Bulma loaded from node_modules)
    │
    ├── js/                 # JavaScript
    │   ├── navbar.js      # Mobile menu
    │   ├── archive.js     # Archive tabs
    │   └── search.js      # Pagefind search interface
    │
    ├── public/             # Static assets (copied as-is)
    │   ├── images/        # Images organized by content type
    │   │   ├── posts/     # Blog thumbnails (slug-based directories)
    │   │   └── projects/  # Project thumbnails (id-based directories)
    │   └── fonts/         # Custom fonts (if any)
    │
    └── index.njk           # Homepage

Generated after build:
├── _site/                  # Built site (deploy this folder)
│   └── pagefind/          # Search index
```

### How Files Interrelate

**Data Flow:**
```
1. .eleventy.js loads first
   ↓
2. Reads src/_data/*.js files → Available as {{ site }}, {{ projects }}, etc.
   ↓
3. Scans src/blog/*.md → Creates collections.posts, collections.postsByYear, etc.
   ↓
4. Renders templates with data
   - base.njk provides page structure
   - Layout templates (post.njk) add content-specific structure
   - Partials (blog-card.njk) provide reusable components
   ↓
5. Outputs to _site/ as static HTML
   ↓
6. Pagefind indexes content for search
```

**Example: How a blog post renders**

1. You create `src/blog/my-post.md` with `layout: layouts/post.njk`
2. 11ty reads the markdown and front matter
3. Converts markdown to HTML
4. `layouts/post.njk` wraps content with post structure
5. `post.njk` includes `base.njk` for full page layout
6. Filters transform data (dates, thumbnails)
7. Outputs `_site/blog/my-post/index.html`

**Collections:**
- Defined in `.eleventy.js`
- Group content automatically based on tags or custom logic
- `collections.posts` - All blog posts (has tag "post")
- `collections.postsByYear` - Posts grouped by year
- `collections.postsByCategory` - Posts grouped by category
- `collections.tagList` - All unique tags

**Filters:**
- Custom functions in `.eleventy.js`
- Transform data in templates
- Examples: `readableDate`, `thumbnailPath`, `thumbnailAlt`

---

## Common Bugs & Debugging

### Posts not appearing in archive

**Symptom:** Blog post exists but doesn't show in archive page

**Causes & Fixes:**
- ❌ Missing `post` tag in front matter
  ```yaml
  tags:
    - Economics
    - post  # ← REQUIRED
  ```
- ❌ Post not in `src/blog/` directory → Move it there
- ❌ Invalid YAML syntax → Check indentation and quotes
- ❌ Invalid date format → Use `YYYY-MM-DD`

**Debug:**
```bash
npm start
# Check terminal output for collection sizes
# Should see: "posts collection: X items"
```

### Thumbnails not displaying

**Symptom:** Image doesn't show on post or project card

**Causes & Fixes:**
- ❌ Image file missing → Check path in file system
- ❌ Wrong path in `thumbnails.js` → Verify matches actual file location
- ❌ Thumbnail entry missing → Add to `src/_data/thumbnails.js`:
  ```javascript
  posts: {
    'post-slug': {
      alt: 'Description of image'
    }
  }
  ```
- ❌ Mismatched slug/ID → For posts, use `post.fileSlug`; for projects, use `project.id`

**Debug:**
```javascript
// In template, add:
{{ post.fileSlug }}  <!-- Should match thumbnails.js key -->
{{ thumbnails.posts[post.fileSlug] | dump }}  <!-- Shows thumbnail data -->
```

### Build fails with "Cannot find module"

**Symptom:** `npm start` or `npm run build` errors with module not found

**Causes & Fixes:**
- ❌ `node_modules/` missing → Run `npm install`
- ❌ New dependency not installed → Run `npm install [package]`
- ❌ Corrupted dependencies → Delete `node_modules/` and run `npm install`
- ❌ Wrong Node version → Check `node --version` (need v18+)

### Archive tabs not switching

**Symptom:** Clicking tabs doesn't change view

**Causes & Fixes:**
- ❌ JavaScript not loading → Check browser console for errors
- ❌ Font Awesome CSS missing → Check `<head>` for Font Awesome CDN link
- ❌ Hash navigation broken → Check `archive.js` is loaded
- ❌ Tab panels have wrong IDs → Verify `id="by-year"`, `id="by-category"`, `id="by-tag"`

**Debug:**
```javascript
// In browser console:
document.querySelectorAll('.tabs li')  // Should return tab elements
document.querySelectorAll('.tab-content')  // Should return 3 panels
```

### Dark mode colors wrong

**Symptom:** Text hard to read in dark mode

**Causes & Fixes:**
- ❌ Missing CSS variable → Check `custom.css` has `--text-primary`, `--bg-dark`, etc.
- ❌ Inline styles override → Check for `style="color: black"` in templates
- ❌ Bulma defaults conflict → Add `!important` or more specific selectors

**Debug:**
```css
/* In browser DevTools, check computed styles: */
.content { color: var(--text-primary); }
```

### Search not working

**Symptom:** Pagefind search returns no results or doesn't load

**Causes & Fixes:**
- ❌ Pagefind index not built → Run `npm run build` (includes Pagefind)
- ❌ Searching on dev server → Pagefind only works after full build
- ❌ `pagefind/` folder missing → Check `_site/pagefind/` exists after build
- ❌ Search UI script not loaded → Verify `search.js` is included

**Debug:**
```bash
# Build and check for pagefind
npm run build
ls _site/pagefind/
# Should show: pagefind.js, index files, etc.
```

### Changes not reflecting

**Symptom:** Edit file but don't see changes in browser

**Causes & Fixes:**
- ❌ Browser cache → Hard refresh (Ctrl+Shift+R or Cmd+Shift+R)
- ❌ Dev server not restarting → Check terminal for errors, restart `npm start`
- ❌ Wrong file edited → Verify you're editing `src/` not `_site/`
- ❌ Data file change not picked up → Restart dev server (data files don't hot-reload)

### Collections empty or wrong

**Symptom:** `collections.posts` is empty or missing posts

**Causes & Fixes:**
- ❌ Missing `post` tag → Add to all blog post front matter
- ❌ Collection definition error → Check `.eleventy.js` for syntax errors
- ❌ Wrong glob pattern → Verify `src/blog/*.md` matches your structure

**Debug:**
```javascript
// In .eleventy.js, add logging:
eleventyConfig.addCollection("posts", function(collectionApi) {
  const posts = collectionApi.getFilteredByTag("post");
  console.log(`Found ${posts.length} posts`);  // Check terminal output
  return posts.reverse();
});
```

### Deployment fails on Cloudflare Pages

**Symptom:** Build succeeds locally but fails on Cloudflare

**Causes & Fixes:**
- ❌ Build command wrong → Should be `npm run build` in Cloudflare settings
- ❌ Output directory wrong → Should be `_site`
- ❌ Node version mismatch → Add environment variable `NODE_VERSION=18`
- ❌ Dependencies missing → Ensure all used packages in `package.json`

**Debug:**
- Check Cloudflare build logs for specific error
- Try exact build command locally: `npm run build`
- Verify `_site/` folder has all expected files

---

## Deployment

Site deployed on **Cloudflare Pages** with automatic builds on every push to `main` branch.

**Build settings:**
- Build command: `npm run build`
- Output directory: `_site`
- Node version: 18

**Workflow:**
```bash
# Make changes
git add -A
git commit -m "Add new post about economics"
git push

# Cloudflare auto-deploys in ~2 minutes
```

---

## Documentation

- **[GUIDE.md](./project_documentation/GUIDE.md)** - Comprehensive 5-7 minute guide covering architecture, content management, and advanced topics

---

## License
[Creative Commons CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

[![CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)   