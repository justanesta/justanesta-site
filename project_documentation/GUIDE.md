# justanesta.com - Comprehensive Guide

**📖 Read time: 6-8 minutes**

This guide covers the architecture, content management system, data architecture, thumbnail system, automation scripts, and advanced topics for the justanesta.com site.

---

## Table of Contents

1. [Site Architecture](#site-architecture)
2. [Content Organization](#content-organization)
3. [Data Architecture](#data-architecture)
4. [Thumbnail System](#thumbnail-system)
5. [Collections & Filters](#collections--filters)
6. [Automation Scripts](#automation-scripts)
7. [Adding Content](#adding-content)
8. [Customization](#customization)
9. [Deployment & CI/CD](#deployment--cicd)

---

## Site Architecture

### Technology Overview

The site is built using a **modern static site approach** with these technologies:

- **11ty (Eleventy) v3.0** - Static site generator using JavaScript
- **Nunjucks** - Template engine for HTML layouts
- **Bulma v1.0** - CSS-only framework (no JavaScript dependencies)
- **Pagefind v1.4** - Client-side static search (indexes at build time)
- **Font Awesome** - Icon library (CDN)
- **Custom CSS/JS** - Dark mode, archive tabs, search UI

### How 11ty Processes the Site

```
Phase 1: Configuration
.eleventy.js loads and registers:
├─ Collections (posts, postsByYear, postsByCategory, tagList)
├─ Filters (readableDate, thumbnailPath, thumbnailAlt)
├─ Passthrough copies (CSS, JS, images, fonts)
└─ Directory settings (input: src, output: _site)

Phase 2: Data Loading
src/_data/ files execute and become globally available:
├─ site.js       → {{ site }} (metadata, nav, social links)
├─ projects.js   → {{ projects }} (project collection)
├─ skills.js     → {{ skills }} (skill lookup methods)
├─ clips.js      → {{ clips }} (published work collection)
└─ thumbnails.js → {{ thumbnails }} (image metadata)

Phase 3: Collection Population
Blog posts and bits scanned and organized:
├─ src/blog/*.md → collections.posts (all posts, reverse chrono)
├─ src/bits/*.md → collections.bits (all bits, reverse chrono)
├─ Grouped by year → collections.postsByYear, collections.bitsByYear
├─ Grouped by category → collections.postsByCategory (blog-only)
└─ All tags extracted → collections.tagList, collections.bitsTagList

Phase 4: Template Rendering
Templates process with data and collections:
├─ base.njk (main layout) wraps all pages
├─ layouts/post.njk adds blog post structure
├─ partials/*.njk provide reusable components
└─ Filters transform data during rendering

Phase 5: Output
Static files generated in _site/:
├─ HTML files for all pages
├─ CSS copied from node_modules and src/
├─ JS copied from src/
├─ Images copied from src/public/
└─ Pagefind builds search index
```

### Why This Architecture?

**Separation of Concerns:**
- **`.eleventy.js`** - Build configuration and processing rules
- **`src/_data/`** - Content and site metadata
- **`src/_includes/`** - Presentation layer (templates)
- **`src/blog/`** - Editorial content (markdown)

**Benefits:**
- Clear responsibility boundaries
- Easy to maintain and extend
- Scales well as content grows
- No framework lock-in (outputs plain HTML)

---

## Content Organization

The site uses a **hybrid approach** optimized for each content type:

### Blog Posts (Markdown + Collections)

**Storage:** Individual markdown files in `src/blog/`

**Why markdown?**
- Content and metadata coexist naturally
- Built-in support for tags, categories, dates
- Powerful filtering via 11ty collections
- Content creators find markdown intuitive
- Scales well as blog grows

**Front matter structure:**
```yaml
---
layout: layouts/post.njk  # Required
title: "Post Title"       # Required
date: YYYY-MM-DD          # Required
category: "Category Name" # Optional (one per post)
description: "Summary"    # Optional (for cards/SEO)
tags:                     # Optional (multiple allowed)
  - Tag 1
  - Tag 2
  - post                  # REQUIRED - enables collection membership
---
```

**Available in templates:**
- `post.fileSlug` - Slug from filename (e.g., "solar-power-analysis")
- `post.url` - Generated URL ("/blog/solar-power-analysis/")
- `post.date` - Date object
- `post.data.title` - Title from front matter
- `post.data.description` - Description
- `post.data.category` - Category string
- `post.data.tags` - Array of tags
- `post.content` - Rendered HTML from markdown

### Bits (Short-Form Posts)

**Storage:** Individual markdown files in `src/bits/`

**What are bits?**
- Short-form "how-to" content (typically under 500 words)
- Quick tips, code snippets, TIL (Today I Learned) moments
- More focused than blog posts - one concept per bit
- No categories (only tags)
- No thumbnails (text-focused content)

**Why separate from blog posts?**
- Different content length and purpose
- Simpler structure (no categories, no thumbnails)
- Easier to discover quick tips vs long-form articles
- Unified archive allows browsing both together

**Front matter structure:**
```yaml
---
layout: layouts/bit.njk   # Required (different from blog posts)
title: "Bit Title"        # Required
date: YYYY-MM-DD          # Required
description: "Summary"    # Optional (for cards/SEO)
tags:                     # Optional (multiple allowed)
  - Tag 1
  - Tag 2
  - bit                   # REQUIRED - enables collection membership
---
```

**Key differences from blog posts:**
- No `category` field
- Uses `layouts/bit.njk` instead of `layouts/post.njk`
- Must include `bit` tag (not `post`)
- No thumbnail support by default
- Integrated into unified archive at `/archive/`

**Available in templates:**
- Same as blog posts: `bit.fileSlug`, `bit.url`, `bit.date`, etc.
- Access via `collections.bits`, `collections.bitsByYear`, `collections.bitsTagList`

### Projects (Data File)

**Storage:** Centralized JavaScript array in `src/_data/projects.js`

**Why data file?**
- Structured metadata (not editorial content)
- External links don't fit markdown model
- Small, static set that doesn't need complex filtering
- Easier to manage in one file
- Can be programmatically generated

**Data structure:**
```javascript
{
  id: 'unique-project-id',          // Used for thumbnail lookup
  title: 'Project Title',
  subtitle: 'Tagline or short description',
  description: 'Full description of the project',
  skillDetails: [                   // Enriched with skills.getSkill()
    { displayName, icon, category, ... }
  ],
  links: {
    demo: 'https://example.com',    // Optional
    github: 'https://github.com/...' // Optional
  }
}
```

**Available in templates:**
```nunjucks
{% for project in projects %}
  {{ project.title }}
  {{ project.id }}  <!-- For thumbnail lookup -->
  {% for skill in project.skillDetails %}
    {{ skill.displayName }}
    {{ skill.icon }}
  {% endfor %}
{% endfor %}
```

### Clips (Data File)

**Storage:** Centralized JavaScript array in `src/_data/clips.js`

**Why data file?**
- Just metadata + external URL (no body content)
- Needs custom grouping by publication
- Small, static collection
- Date needs to be JavaScript Date object for sorting

**Data structure:**
```javascript
{
  id: 'unique-clip-id',
  title: 'Article/Media Title',
  publication: 'Publication Name',   // Used for grouping
  date: new Date('2024-01-15'),     // Date object for proper sorting
  description: 'Brief description',
  tags: ['tag1', 'tag2'],
  url: 'https://example.com/article'
}
```

---

## Data Architecture

### Data Files (`src/_data/`)

**Purpose:** Make information globally available to all templates.

**Execution:** Data files run early in the build, before templates render.

**Current files:**
```
src/_data/
├── site.js         # Site config, nav, social links
├── projects.js     # Project collection with skill enrichment
├── skills.js       # Skill definitions + lookup methods
├── clips.js        # Published work collection
├── thumbnails.js   # Image paths and alt text
└── colorScheme.js  # (Optional) Color mappings
```

**Accessing data:**
```nunjucks
{# site.js data #}
<title>{{ site.title }}</title>
<a href="{{ site.social.github }}">GitHub</a>

{# projects.js data #}
{% for project in projects %}
  <h2>{{ project.title }}</h2>
{% endfor %}

{# Using filters from .eleventy.js #}
{% set skill = "python" | getSkill %}
<span>{{ skill.displayName }}</span>
```

### Configuration (`.eleventy.js`)

**Purpose:** Configure how Eleventy processes your site.

**Execution:** Runs first, before data files or templates.

**What it contains:**
1. **Pass-through copies** - Static files to copy as-is
2. **Collections** - Groupings of content with transformations
3. **Filters** - Template transformation functions
4. **Imports** - Can import data files to use in filters
5. **Configuration object** - Directory paths and engines

**Key distinction:**
- `.eleventy.js` = Build rules and processing logic
- `src/_data/` = Content and metadata
- `.eleventy.js` CAN import from `src/_data/`
- `src/_data/` CANNOT import from `.eleventy.js`

### Skills Bridge Pattern

This pattern shows how data files and config work together:

```javascript
// src/_data/skills.js (DATA FILE)
module.exports = {
  byName: {
    python: { displayName: 'Python', icon: 'fab fa-python', ... },
    // ... more skills
  },
  getSkill(name) {
    return this.byName[name.toLowerCase()] || null;
  },
  getByCategory(categoryId) {
    // Filter method
  }
};

// .eleventy.js (CONFIG FILE)
const skills = require('./src/_data/skills.js');

eleventyConfig.addFilter("getSkill", function(skillName) {
  return skills.getSkill(skillName);
});

// Template usage
{{ "python" | getSkill }}
```

**Pattern benefits:**
- `skills.js` = pure data + methods
- `.eleventy.js` = wraps methods as filters
- Templates use filters cleanly

---

## Thumbnail System

### Overview

The site uses a **unified slug-based thumbnail system** that auto-generates paths from content slugs.

**Core principles:**
1. Slug-based directories - Each content item gets its own directory
2. Auto-generated paths - Paths created automatically via filters
3. Centralized metadata - Only alt text stored in `thumbnails.js`
4. Consistent pattern - Same approach for posts and projects

### Directory Structure

```
src/public/images/
├── posts/
│   ├── [post-slug]/           # Directory name matches post.fileSlug
│   │   └── thumbnail.jpg      # Standard filename
│   ├── solar-power-analysis/
│   │   └── thumbnail.jpg
│   └── nursing-occupation-analysis/
│       └── thumbnail.jpg
└── projects/
    ├── [project-id]/           # Directory name matches project.id
    │   └── thumbnail.jpg
    ├── econanalyzr-r-package/
    │   └── thumbnail.jpg
    └── middle-class-checker/
        └── thumbnail.jpg
```

### Metadata File (`src/_data/thumbnails.js`)

```javascript
module.exports = {
  posts: {
    'solar-power-analysis': {
      alt: 'Solar power expansion and correlation vs causation'
      // Path auto-generated: /images/posts/solar-power-analysis/thumbnail.jpg
    },
    'nursing-occupation-analysis': {
      alt: 'Hospital occupation vs home health workers',
      ext: 'jpeg'  // Optional extension override (defaults to 'jpg')
    }
  },
  projects: {
    'econanalyzr-r-package': {
      alt: 'R package with functions to help analyze economic data'
    },
    'middle-class-checker': {
      alt: 'Interactive tool to check if you are middle class'
    }
  }
};
```

**What's NOT stored:**
- ❌ Full image paths (auto-generated by filters)
- ❌ Image dimensions (handled by CSS)
- ❌ Existence flags (templates check `thumbnails.[type][slug] != undefined`)

### Eleventy Filters

Filters defined in `.eleventy.js` generate paths automatically:

```javascript
const thumbnails = require('./src/_data/thumbnails.js');

// Generate thumbnail path from slug
eleventyConfig.addFilter("thumbnailPath", function(slug, type = 'posts') {
  const meta = thumbnails[type] && thumbnails[type][slug];
  const ext = meta && meta.ext ? meta.ext : 'jpg';
  return `/images/${type}/${slug}/thumbnail.${ext}`;
});

// Get alt text from thumbnails.js or use slug as fallback
eleventyConfig.addFilter("thumbnailAlt", function(slug, type = 'posts') {
  const meta = thumbnails[type] && thumbnails[type][slug];
  return meta && meta.alt ? meta.alt : slug;
});
```

### Template Usage

**Blog posts:**
```nunjucks
{% set postMeta = thumbnails.posts[post.fileSlug] %}
{% set hasThumbnail = postMeta != undefined %}

{% if hasThumbnail %}
  <img src="{{ post.fileSlug | thumbnailPath('posts') }}"
       alt="{{ post.fileSlug | thumbnailAlt('posts') }}">
{% endif %}
```

**Projects:**
```nunjucks
{% set projectMeta = thumbnails.projects[project.id] %}
{% set hasThumbnail = projectMeta != undefined %}

{% if hasThumbnail %}
  <img src="{{ project.id | thumbnailPath('projects') }}"
       alt="{{ project.id | thumbnailAlt('projects') }}">
{% endif %}
```

### Image Specifications

**Blog Posts:**
- Dimensions: 1200×675 pixels (16:9 aspect ratio)
- Format: JPEG (photos) or PNG (graphics)
- File size: Under 100KB (aim for 50-80KB)
- Quality: 85% compression for JPEG

**Projects:**
- Dimensions: 256×256 pixels or smaller (square)
- Format: JPEG or PNG (PNG for logos with transparency)
- File size: Under 50KB

---

## Collections & Filters

### Collections

Collections are defined in `.eleventy.js` and group content for easy access in templates.

**`collections.posts`**
```javascript
eleventyConfig.addCollection("posts", function(collectionApi) {
  return collectionApi.getFilteredByTag("post").reverse();
});
```
- All blog posts (must have tag "post")
- Sorted newest first
- Used in: blog listing, homepage

**`collections.postsByYear`**
```javascript
eleventyConfig.addCollection("postsByYear", function(collectionApi) {
  const posts = collectionApi.getFilteredByTag("post");
  const postsByYear = {};

  posts.forEach(post => {
    const year = post.date.getFullYear();
    if (!postsByYear[year]) postsByYear[year] = [];
    postsByYear[year].push(post);
  });

  return Object.keys(postsByYear)
    .sort((a, b) => b - a)
    .map(year => ({
      year: year,
      posts: postsByYear[year].reverse()
    }));
});
```
- Posts grouped by year
- Returns: `[{year: "2024", posts: [...]}, {year: "2023", posts: [...]}]`
- Used in: archive page "By Year" tab

**`collections.postsByCategory`**
```javascript
eleventyConfig.addCollection("postsByCategory", function(collectionApi) {
  const posts = collectionApi.getFilteredByTag("post");
  const postsByCategory = {};

  posts.forEach(post => {
    const category = post.data.category || 'Uncategorized';
    if (!postsByCategory[category]) postsByCategory[category] = [];
    postsByCategory[category].push(post);
  });

  return Object.keys(postsByCategory).sort().map(category => ({
    category: category,
    posts: postsByCategory[category].reverse()
  }));
});
```
- Posts grouped by category
- Returns: `[{category: "Economics", posts: [...]}, ...]`
- Used in: archive page "By Category" tab

**`collections.tagList`**
```javascript
eleventyConfig.addCollection("tagList", function(collectionApi) {
  const tagSet = new Set();
  collectionApi.getAll().forEach(item => {
    (item.data.tags || []).forEach(tag => {
      if (tag !== "post") tagSet.add(tag);
    });
  });
  return Array.from(tagSet).sort();
});
```
- All unique tags (excluding "post")
- Returns: Sorted array of tag strings
- Used in: archive page "By Tag" section

**`collections.bits`**
```javascript
eleventyConfig.addCollection("bits", function(collectionApi) {
  return collectionApi.getFilteredByGlob("src/bits/*.md").reverse();
});
```
- All bits (short-form posts)
- Sorted newest first
- Used in: bits listing, homepage, unified archive

**`collections.bitsByYear`**
```javascript
eleventyConfig.addCollection("bitsByYear", function(collectionApi) {
  const bits = collectionApi.getFilteredByGlob("src/bits/*.md");
  const bitsByYear = {};

  bits.forEach(bit => {
    const year = bit.date.getFullYear();
    if (!bitsByYear[year]) bitsByYear[year] = [];
    bitsByYear[year].push(bit);
  });

  return Object.keys(bitsByYear)
    .sort((a, b) => b - a)
    .map(year => ({
      year: year,
      bits: bitsByYear[year].sort((a, b) => b.date - a.date)
    }));
});
```
- Bits grouped by year
- Returns: `[{year: "2025", bits: [...]}, ...]`
- Used in: archive page "By Year" tab

**`collections.bitsTagList`**
```javascript
eleventyConfig.addCollection("bitsTagList", function(collectionApi) {
  const tagSet = new Set();
  collectionApi.getFilteredByGlob("src/bits/*.md").forEach(item => {
    if ("tags" in item.data) {
      let tags = item.data.tags;
      for (let tag of tags) {
        if (tag !== "bit") tagSet.add(tag);
      }
    }
  });
  return [...tagSet].sort();
});
```
- All unique tags from bits (excluding "bit")
- Returns: Sorted array of tag strings
- Used in: bits filtering and organization

### Filters

Custom filters transform data in templates.

**Date Filters:**
```javascript
eleventyConfig.addFilter("readableDate", dateObj => {
  return new Date(dateObj).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
});
// Usage: {{ post.date | readableDate }}
// Output: "January 15, 2024"

eleventyConfig.addFilter("htmlDateString", dateObj => {
  return new Date(dateObj).toISOString().split('T')[0];
});
// Usage: <time datetime="{{ post.date | htmlDateString }}">
// Output: <time datetime="2024-01-15">

eleventyConfig.addFilter("monthYear", dateObj => {
  return new Date(dateObj).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short'
  });
});
// Usage: {{ clip.date | monthYear }}
// Output: "Jan 2024"
```

**Thumbnail Filters:**
```javascript
eleventyConfig.addFilter("thumbnailPath", function(slug, type = 'posts') {
  const meta = thumbnails[type] && thumbnails[type][slug];
  const ext = meta && meta.ext ? meta.ext : 'jpg';
  return `/images/${type}/${slug}/thumbnail.${ext}`;
});
// Usage: {{ post.fileSlug | thumbnailPath('posts') }}

eleventyConfig.addFilter("thumbnailAlt", function(slug, type = 'posts') {
  const meta = thumbnails[type] && thumbnails[type][slug];
  return meta && meta.alt ? meta.alt : slug;
});
// Usage: {{ post.fileSlug | thumbnailAlt('posts') }}
```

**Skill Filter:**
```javascript
const skills = require('./src/_data/skills.js');

eleventyConfig.addFilter("getSkill", function(skillName) {
  return skills.getSkill(skillName);
});
// Usage: {% set skill = "python" | getSkill %}
//        {{ skill.displayName }} → "Python"
//        {{ skill.icon }} → "fab fa-python"
```

**Tag Filtering:**
```javascript
// Filter blog posts by tag
eleventyConfig.addFilter("filterByTag", function(posts, tag) {
  return posts.filter(post => {
    return post.data.tags && post.data.tags.includes(tag);
  });
});

// Filter bits by tag
eleventyConfig.addFilter("filterBitsByTag", function(bits, tag) {
  return bits.filter(bit => {
    return bit.data.tags && bit.data.tags.includes(tag);
  });
});
// Usage: {{ collections.posts | filterByTag("Economics") }}
//        {{ collections.bits | filterBitsByTag("python") }}
```

---

## Automation Scripts

The site includes five bash scripts in `scripts/` to automate common tasks:

### new-post.sh

**Purpose:** Automated blog post creation with all boilerplate setup.

**What it does:**
1. Creates markdown file (`src/blog/*.md`) with proper front matter
2. Generates URL-friendly slug from post title
3. Creates thumbnail directory structure (`src/public/images/posts/[slug]/`)
4. Updates `thumbnails.js` with new post entry
5. Opens file in your editor

**Usage:**
```bash
# Interactive mode (recommended)
./scripts/new-post.sh
# Or: npm run new:post

# Command-line mode
./scripts/new-post.sh \
  --title "My New Post Title" \
  --category "Economics" \
  --description "A brief summary" \
  --tags "Economics,Data Analysis,Finance"
```

**Options:**
- `-t, --title` - Post title (required)
- `-c, --category` - Post category (required)
- `-d, --description` - Short description
- `--tags` - Comma-separated tags
- `--no-thumbnail` - Skip creating thumbnail directory
- `-e, --editor` - Editor command (default: `$EDITOR` or `code`)

**After running:**
1. Write your content in the generated markdown file
2. Add thumbnail image (1200×675px, under 100KB)
3. Update alt text in `src/_data/thumbnails.js`

### new-project.sh

**Purpose:** Automated project creation with structured metadata.

**What it does:**
1. Adds project entry to `src/_data/projects.js`
2. Generates URL-friendly ID from project title
3. Creates thumbnail directory (`src/public/images/projects/[id]/`)
4. Updates `thumbnails.js` with project entry
5. Opens `projects.js` in your editor

**Usage:**
```bash
# Interactive mode (recommended)
./scripts/new-project.sh
# Or: npm run new:project

# Command-line mode
./scripts/new-project.sh \
  --title "My Project" \
  --subtitle "A cool tool" \
  --description "Full description here" \
  --skills "python,Django,PostgreSQL" \
  --demo "https://example.com" \
  --github "https://github.com/user/repo"
```

**Options:**
- `-t, --title` - Project title (required)
- `--id` - Project ID/slug (auto-generated if not provided)
- `-s, --subtitle` - Project subtitle/tagline
- `-d, --description` - Project description
- `--skills` - Comma-separated skills
- `--demo` - Demo/live site URL
- `-g, --github` - GitHub repository URL
- `--no-thumbnail` - Skip creating thumbnail directory

**After running:**
1. Add thumbnail image (square, under 50KB)
2. Update alt text in `src/_data/thumbnails.js`
3. Review project entry in `src/_data/projects.js`

### new-clip.sh

**Purpose:** Automated clip/published work creation for articles and media.

**What it does:**
1. Adds clip entry to `src/_data/clips.js` with proper date handling
2. Generates URL-friendly ID from article title
3. Groups clips by publication automatically
4. Opens `clips.js` in your editor

**Usage:**
```bash
# Interactive mode (recommended)
./scripts/new-clip.sh
# Or: npm run new:clip

# Command-line mode
./scripts/new-clip.sh \
  --title "Article Title" \
  --publication "Publication Name" \
  --date "2025-01-15" \
  --description "Brief summary" \
  --tags "Data Analysis,Economics" \
  --url "https://example.com/article"
```

**Options:**
- `-t, --title` - Article/clip title (required)
- `--id` - Clip ID/slug (auto-generated if not provided)
- `-p, --publication` - Publication name (required)
- `--date` - Publication date (YYYY-MM-DD, defaults to today)
- `-d, --description` - Brief description
- `--tags` - Comma-separated tags
- `-u, --url` - Article URL (required)

**After running:**
1. Review clip entry in `src/_data/clips.js`
2. Verify date is correct (uses JavaScript Date object)
3. Check grouping by publication

### new-bit.sh

**Purpose:** Automated bit (short-form post) creation.

**What it does:**
1. Creates markdown file (`src/bits/*.md`) with proper front matter
2. Generates URL-friendly slug from bit title
3. Opens file in your editor
4. No thumbnail creation (bits are text-focused)

**Usage:**
```bash
# Interactive mode (recommended)
./scripts/new-bit.sh
# Or: npm run new:bit

# Command-line mode
./scripts/new-bit.sh \
  --title "How to Setup SSH Keys" \
  --description "Quick guide to SSH setup" \
  --tags "ssh,security,linux"
```

**Options:**
- `-t, --title` - Bit title (required)
- `-d, --description` - Short description
- `--tags` - Comma-separated tags (e.g., "python,cli,productivity")
- `-e, --editor` - Editor command (default: `$EDITOR` or `code`)

**After running:**
1. Write your content (keep it short and practical!)
2. That's it! No thumbnails or categories needed

**The bit will automatically appear in:**
- Bits listing (`/bits/`)
- Unified archive (`/archive/`)
- RSS feed (combined with blog posts)
- Pagefind search (after build)

### optimize-images.sh

**Purpose:** Image optimization tool for checking and compressing images.

**What it does:**
1. Checks image dimensions against recommended sizes
2. Checks file sizes against optimal targets
3. Reports issues with detailed information
4. Optionally optimizes images automatically (with `--fix` flag)
5. Shows space savings after optimization

**Usage:**
```bash
# Check mode (default)
./scripts/optimize-images.sh
# Or: npm run optimize

# Fix mode (actually optimize)
./scripts/optimize-images.sh --fix
# Or: npm run optimize:fix

# Check specific type
./scripts/optimize-images.sh --type posts     # Only blog posts
./scripts/optimize-images.sh --type projects  # Only projects
```

**Options:**
- `-f, --fix` - Actually optimize images (default: check only)
- `-t, --type TYPE` - Check specific type (`posts`, `projects`, or `all`)
- `-v, --verbose` - Show detailed information for all images

**Requirements for --fix mode:**
```bash
# Ubuntu/Debian
sudo apt-get install imagemagick jpegoptim optipng

# macOS
brew install imagemagick jpegoptim optipng
```

**What gets optimized:**
- ✅ Resize images exceeding max dimensions
- ✅ Compress JPEG files to 85% quality
- ✅ Strip EXIF data from images
- ✅ Optimize PNG files without quality loss
- ✅ Report space savings

**Image standards:**
- Blog posts: 1200×675px, under 100KB
- Projects: 256×256px, under 50KB

---

## Adding Content

### Adding a Blog Post

**Option 1: Use automation script (recommended)**
```bash
npm run new:post
# or: ./scripts/new-post.sh
```

The script automates:
1. Creating markdown file with front matter
2. Generating URL-friendly slug
3. Creating thumbnail directory
4. Updating thumbnails.js
5. Opening file in editor

**Option 2: Manual creation**

1. Create `src/blog/my-post-slug.md`:
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

2. Create thumbnail directory:
   ```bash
   mkdir -p src/public/images/posts/my-post-slug
   ```

3. Add image (1200×675px, under 100KB):
   ```bash
   # Add your image as:
   src/public/images/posts/my-post-slug/thumbnail.jpg
   ```

4. Update `src/_data/thumbnails.js`:
   ```javascript
   'my-post-slug': {
     alt: 'Descriptive alt text for the image'
   }
   ```

**The post will automatically appear in:**
- Blog listing (`/blog/`)
- Homepage (if recent)
- Archive page (all three tabs)
- Pagefind search (after build)

### Adding a Project

**Option 1: Use automation script (recommended)**
```bash
npm run new:project
# or: ./scripts/new-project.sh
```

**Option 2: Manual creation**

1. Open `src/_data/projects.js`

2. Add new object to array:
   ```javascript
   {
     id: 'my-project-id',
     title: 'Project Title',
     subtitle: 'Tagline',
     description: 'Full description of the project.',
     skillDetails: ['python', 'Django', 'PostgreSQL'].map(skill =>
       skills.getSkill(skill)
     ).filter(Boolean),
     links: {
       demo: 'https://example.com',
       github: 'https://github.com/user/repo'
     }
   }
   ```

3. Create thumbnail directory:
   ```bash
   mkdir -p src/public/images/projects/my-project-id
   ```

4. Add image (256×256px, under 50KB)

5. Update `src/_data/thumbnails.js`:
   ```javascript
   projects: {
     'my-project-id': {
       alt: 'Descriptive alt text'
     }
   }
   ```

### Adding a Clip

**Option 1: Use automation script (recommended)**
```bash
npm run new:clip
# or: ./scripts/new-clip.sh
```

**Option 2: Manual creation**

1. Open `src/_data/clips.js`

2. Add new object to array:
   ```javascript
   {
     id: 'unique-clip-id',
     title: 'Article Title',
     publication: 'Publication Name',
     date: new Date('2025-01-15'),  // IMPORTANT: Date object
     description: 'Brief description',
     tags: ['Data Analysis', 'Economics'],
     url: 'https://example.com/article'
   }
   ```

**Note:** Clips are automatically grouped by publication in the template.

### Adding a Bit

**Option 1: Use automation script (recommended)**
```bash
npm run new:bit
# or: ./scripts/new-bit.sh
```

The script automates:
1. Creating markdown file with front matter
2. Generating URL-friendly slug
3. Opening file in editor

**Option 2: Manual creation**

1. Create `src/bits/my-bit-slug.md`:
   ```markdown
   ---
   layout: layouts/bit.njk
   title: "How to Do Something"
   date: 2025-01-15
   description: "Quick guide to..."
   tags:
     - python
     - cli
     - bit
   ---

   Your short-form content here...
   ```

**The bit will automatically appear in:**
- Bits listing (`/bits/`)
- Unified archive (`/archive/`)
- RSS feed (combined with blog posts)
- Pagefind search (after build)

---

## RSS Feed

The site includes an RSS/Atom feed at `/feed.xml` that combines both blog posts and bits.

**Features:**
- **Combined feed** - Includes both blog posts and bits in one feed
- **Content type metadata** - Each entry tagged as "blog" or "bit"
- **Auto-discovery** - Header includes `<link rel="alternate">` for feed readers
- **Full metadata** - Titles, dates, descriptions, tags, and categories

**Feed location:**
```
https://justanesta.com/feed.xml
```

**Implementation** ([src/feed.xml.njk](../src/feed.xml.njk)):
```nunjucks
{% set allContent = collections.posts.concat(collections.bits) | reverse %}
...
{% for item in allContent %}
  {% set contentType = "blog" if item.data.tags and "post" in item.data.tags else "bit" %}
  <entry>
    <title>{{ item.data.title }}</title>
    <content type="html">{{ item.data.description }}</content>
    <category term="{{ contentType }}" label="Content Type"/>
    ...
  </entry>
{% endfor %}
```

**Feed links:**
- RSS icon in header (top right)
- "RSS" link in footer of every blog post and bit

---

## Customization

### Updating Site Metadata

**File:** `src/_data/site.js`

```javascript
module.exports = {
  title: "Your Name - Portfolio & Blog",
  description: "Your site description",
  url: "https://yoursite.com",
  author: "Your Name",

  nav: [
    { url: "/blog/", label: "Blog", icon: "fa-pen" },
    { url: "/bits/", label: "Bits", icon: "fa-lightbulb" },
    { url: "/archive/", label: "Archive", icon: "fa-folder-open" },
    { url: "/projects/", label: "Projects", icon: "fa-code" },
    { url: "/clips/", label: "Clips", icon: "fa-newspaper" },
    { url: "/about/", label: "About", icon: "fa-user" },
    { url: "/search/", label: "Search", icon: "fa-search" }
  ],

  social: {
    email: "your@email.com",
    github: "https://github.com/yourusername",
    linkedin: "https://linkedin.com/in/yourusername",
    twitter: "https://twitter.com/yourusername"
  }
};
```

### Modifying Styles

**Dark Mode Variables:** `src/css/custom.css`

```css
:root {
  --text-primary: #333;
  --text-secondary: #666;
  --bg-light: #f5f5f5;
  --bg-white: #fff;
}

@media (prefers-color-scheme: dark) {
  :root {
    --text-primary: #e0e0e0;
    --text-secondary: #b0b0b0;
    --bg-dark: #1a1a1a;
    --bg-darker: #0d0d0d;
  }
}
```

**Custom Styles:**
Add new styles to `src/css/custom.css`. Bulma classes are available globally from `node_modules/bulma/css/bulma.min.css`.

### Adding New Collections

To create a new content type with collections:

1. Create directory: `src/mycontent/`
2. Add markdown files with tag: `mycontent`
3. Define collection in `.eleventy.js`:
   ```javascript
   eleventyConfig.addCollection("myCollection", function(collectionApi) {
     return collectionApi.getFilteredByTag("mycontent").reverse();
   });
   ```
4. Create listing template: `src/mycontent/index.njk`
5. Access in templates: `{{ collections.myCollection }}`

---

## Deployment & CI/CD

### Cloudflare Pages Setup

**Build settings:**
- Framework preset: Eleventy
- Build command: `npm run build`
- Build output directory: `_site`
- Node version: 22.20.0 (set via environment variable if needed)

**Continuous Deployment:**
```bash
# Make changes locally
git add -A
git commit -m "Add new post about economics"
git push origin main

# Cloudflare Pages auto-builds and deploys
# Live in ~2 minutes
```

**Preview Deployments:**
- Every pull request gets a unique preview URL
- Test changes before merging to main
- Automatic cleanup after merge

### Build Process

The site has three main build commands:

**`npm run serve` (Development with hot-reload):**
```bash
npm run serve
# Runs: npx @11ty/eleventy --serve --quiet
# - Builds site to _site/
# - Starts development server at http://localhost:8080
# - Watches for file changes and rebuilds automatically
# - Hot-reload enabled (browser refreshes on changes)
# - Does NOT run Pagefind (search won't work in dev)
```

**`npm start` (Same as serve):**
```bash
npm start
# Alias for: npm run serve
# Use this for local development with live reload
```

**`npm run build` (Production build):**
```bash
npm run build
# Runs: npx @11ty/eleventy && npx pagefind --site _site
# 1. Builds static site to _site/
# 2. Indexes all content with Pagefind for search
# 3. No development server (just builds files)
# 4. Used by Cloudflare Pages for deployment
```

**Key differences:**
- **Development** (`npm start` / `npm run serve`): Fast rebuilds, live reload, no search indexing
- **Production** (`npm run build`): Complete build with search indexing, ready for deployment

**What gets built:**
```
_site/
├── index.html                    # Homepage
├── blog/                         # All blog posts
│   └── [slug]/index.html
├── archive/index.html            # Archive with tabs
├── projects/index.html           # Projects page
├── clips/index.html              # Clips page
├── about/index.html              # About page
├── css/
│   ├── bulma.min.css            # From node_modules
│   └── custom.css               # Custom styles
├── js/
│   ├── navbar.js
│   ├── archive.js
│   └── search.js
├── images/                       # All images
│   ├── posts/
│   └── projects/
└── pagefind/                     # Search index
    ├── pagefind.js
    └── index/
```

***More information on Cloudflare pages deployment can be found [here](https://developers.cloudflare.com/pages/get-started/).***

### Cloudflare Pages Configuration & Optimization

#### Build Configuration Optimization

**Go to:** Your Pages project → Settings → Builds & deployments

**Recommended settings:**

**Production branch:**
- `main` (or whatever you set)

**Preview deployments:**
- Enable preview deployments: **ON**
- This creates preview URLs for pull requests
- Great for testing changes before merging

**Build watch paths (optional):**
- Can specify which files trigger rebuilds
- Leave empty to rebuild on any change (recommended for now)

#### Deploy Hooks (Optional)

Deploy hooks allow triggering builds via URL:

1. **Go to:** Settings → Builds & deployments → Deploy hooks
2. **Click:** "Add deploy hook"
3. **Name:** e.g., "Manual deploy"
4. **Branch:** main
5. **Save**

**You get a unique URL to trigger deployments:**
```bash
curl -X POST [your-deploy-hook-url]
```

**Useful for:**
- Triggering builds from external services
- Manual deploys without git push
- Integrations with CMS systems

#### Environment Variables (Production vs Preview)

If you need different environment variables for production vs preview:

1. **Go to:** Settings → Environment variables
2. **Add variables** with specific scope:
   - Production only
   - Preview only  
   - Both

**Example use case:**
- Different API endpoints for production/preview
- Different analytics IDs

---

#### Automatic Deployments

**How it works:**

**Every git push to production branch (main):**
1. Cloudflare detects commit
2. Automatically starts new build
3. Runs `npm install` and `npm run build`
4. Deploys new version
5. Updates live site
6. Previous version still accessible (can rollback)

**Timeline:** 2-5 minutes per deployment

#### Preview Deployments

**Every pull request created:**
1. Cloudflare builds PR branch
2. Creates unique preview URL
3. Updates preview on each PR commit
4. Preview URL pattern: `[hash].[project].pages.dev`

**Benefits:**
- Test changes before merging
- Share preview with others
- Safe experimentation

#### Deployment History

**View all deployments:**
1. **Go to:** Your Pages project → Deployments
2. **See list of all builds:**
   - Production deployments
   - Preview deployments
   - Status (success/failed)
   - Commit message
   - Build time
   - Deployment URL

**Actions available:**
- View deployment
- View build logs
- Rollback to previous version
- Delete deployment

#### Rollback if Needed

If you deploy a broken version:

1. **Go to:** Deployments tab
2. **Find:** Previous working deployment
3. **Click:** ⋮ (three dots) → "Rollback to this deployment"
4. **Confirm**

**Your live site immediately serves the previous version** while you fix issues.

#### Caching Configuration

Cloudflare Pages automatically handles caching well, but you can optimize:

**Go to:** Caching → Configuration (main Cloudflare dashboard)

**Browser Cache TTL:**
- Default: Respect existing headers (recommended)
- Or set specific TTL

**For 11ty sites:**
- HTML: Short cache (or no-cache)
- CSS/JS: Long cache with versioned URLs
- Images: Long cache

**11ty tip:** Use `eleventy-plugin-rev` or similar for cache-busting:
```bash
npm install eleventy-plugin-rev
```

This adds hashes to filenames: `style.css` → `style.abc123.css`

#### Performance Settings

**Go to:** Speed → Optimization

**Recommended for 11ty + Bulma:**

**Auto Minify:**
- ✓ JavaScript
- ✓ CSS  
- ✓ HTML

**Brotli:**
- ✓ Enable (better compression than gzip)

**Early Hints:**
- ✓ Enable (faster page loads)

**HTTP/3:**
- ✓ Enable (already on by default)

**Rocket Loader:**
- ⚠️ Test this - can break some JavaScript
- Try with OFF first, enable if no issues

#### Image Optimization

If your site has many images:

**Cloudflare Images:**
- Paid service (~$5/month for 100k images)
- Automatic WebP/AVIF conversion
- Resizing on-the-fly
- Not necessary for small sites

**Alternative: Optimize images before deployment**
- Use imagemin, sharp, or similar
- Add to your 11ty build process
- Free and effective for smaller sites

---

#### Quick Reference Commands

**Test local build:**
```bash
npm install
npm run build
# Check _site directory for output
```

**Manual deployment trigger:**
```bash
git add .
git commit -m "Update content"
git push origin main
# Cloudflare automatically deploys
```

**View build logs:**
- Cloudflare dashboard → Pages → Your project → Deployments → Click deployment → View logs

**Rollback to previous version:**
- Deployments → Previous deployment → ⋮ → Rollback

---

#### Post-Deployment Optimization Checklist

After successful deployment and configuration:

- [ ] Preview deployments enabled
- [ ] Auto Minify enabled (JS, CSS, HTML)
- [ ] Brotli compression enabled
- [ ] Early Hints enabled
- [ ] Cache-busting implemented (if needed)
- [ ] Images optimized
- [ ] Analytics set up (optional)
- [ ] Deploy hooks configured (if needed)
- [ ] Environment variables configured correctly
---

## Further Reading
- **[11ty Documentation](https://www.11ty.dev/docs/)** - Official Eleventy docs
- **[Bulma Documentation](https://bulma.io/documentation/)** - Bulma CSS framework
- **[Pagefind Documentation](https://pagefind.app/)** - Static search library
- **[Cloudflare Pages Docs](https://developers.cloudflare.com/pages/)** - Deployment platform

---

**Last updated:** December 2025