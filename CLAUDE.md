# Project: justanesta.com (11ty + Bulma)

## Purpose

This repo contains my personal site `justanesta.com`, built with:

- **Eleventy (11ty)** for static site generation
- **Bulma** for CSS (no JS framework)
- Hosted on **Cloudflare Pages**

The site has:
- Home/landing page with intro + “skills & experience”
- Blog with archive by year, category, and tags
- Projects page
- About page
- Social/contact icons

## Tech & structure

- Static site only; no server-side code/logic.
- Key files (conventions):
  - `.eleventy.js` – Eleventy config, collections, pagination, directory structure
  - `src/_includes/base.njk` – global layout & `<head>` (Bulma, fonts, favicons, meta tags)
  - `src/_includes/layouts/` – page/post layouts (home, generic page, post, archive, etc.)
  - `src/_includes/partials/` – header, footer, and shared components
  - `src/_data/site.js` – site metadata (title, description, socials, etc.)
  - `src/posts/` – blog posts (markdown with front matter)
  - `src/projects/` – projects content
  - `src/clips/` – clips/published work content (if present)
  - `src/blog/` – blog index, archive, tag/category/year templates
  - `src/public/` – static assets (favicons, images, CSS), copied to the site root

Eleventy directories are configured with `input: "src"`, `includes: "_includes"`, `data: "_data"`, `output: "_site"`.

## Conventions

## Content conventions

**Blog posts (`src/posts/`):**

- **Front matter**:

  ```yaml
  ---
  title: "Post title"
  description: "Short summary"
  date: YYYY-MM-DD
  layout: layouts/post.njk
  tags:
    - post          # required so it appears in collections.posts
    - other-tag
  categories:
    - Category Name # one or more high-level categories
  ---
  ```
- **Posts**:
  - Live in `src/posts/`.
  - Must include:
    - `layout: layouts/post.njk`
    - `tags` always includes `post` so Eleventy’s `collections.posts` works correctly.
    - `categories` is an array of higher-level buckets (e.g. `Data Journalism`, `Personal`, etc.).
- **CSS**:
  - Prefer Bulma utility classes first.
  - Only add custom CSS when Bulma’s defaults aren’t enough.
  - Keep any new global CSS in `src/public/css/custom.css` (or equivalent).
- **Eleventy collections**:
  - `collections.posts` = all content tagged `post`, sorted newest → oldest.
  - `collections.tagList`, `collections.categoryList`, `collections.postsByYear` are defined in `.eleventy.js`.
- **Projects / Clips**:
  - Stored as markdown files in their own folders (`src/projects/`, `src/clips/`) or via data collections.
  - Use consistent front matter (`title`, `subtitle`, `date`, `links`, etc.) so we can loop over them easily.
- **Archive system**:
  - Archive page(s) use 11ty collections and front matter to group posts by:
    - Year (`collections.postsByYear` or similar)
    - Category (`collections.categoryList`)
    - Tag (`collections.tagList`)
  - Tab switching / view switching is handled by lightweight Javascript, but the data is all from Eleventy collections.

## How I want you to work


1. **Before changing multiple files**, briefly outline:
   - The goal
   - Which files you plan to modify
2. **Read the relevant files first** (don’t assume structure).
3. **Keep edits small, safe, and DRY**:
   - Prefer reusing layouts and partials instead of duplicating markup.
   - Prefer Bulma classes over custom CSS where possible.
4. For anything involving 11ty configuration, pagination, or collections:
   - Check the Eleventy docs for the exact API before guessing.
5. For layout/styling:
   - Prefer Bulma’s grid, columns, and helpers instead of writing lots of custom CSS.
6. For documentation:
   - Summarize complex changes in plain English and update existing docs (README, SETUP, FILE-STRUCTURE) instead of creating lots of ad-hoc notes.

## When to consult external docs

Use tools / web to fetch docs **only when needed**, and fetch only the relevant pages:

- **Eleventy docs** – https://www.11ty.dev/docs/
  - For: collections, pagination, directory config, filters, Nunjucks syntax
- **Bulma docs** – https://bulma.io/documentation/
  - For: layout (columns, sections, hero), responsive helpers, spacing, typography
- **Cloudflare Pages docs** – https://developers.cloudflare.com/pages/
  - For: build configuration, environment variables, deployment issues
  - Use for layout, responsive behavior, and components.

Do **not** embed docs in this file. Instead:
- When you need details on 11ty or Bulma, fetch only the relevant page or section via tools or web (not the entire docs).

Do **not** paste large doc sections into this repo or into messages. Instead:
- Link to the specific page and summarize only what’s needed for the current task.

## Out of scope

- Do not add a JS framework (React/Vue/etc.) unless I explicitly request it.
- Do not introduce heavy build tooling (Webpack, Vite, etc.) for this project.
- Do not add backend logic; this site should remain static.
- Do not significantly change URL structures (permalinks) without confirming.
- Do not remove or break the existing archive functionalities (year/category/tag) unless we’re explicitly redesigning them.
