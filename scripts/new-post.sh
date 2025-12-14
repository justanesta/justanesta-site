#!/usr/bin/env bash
#
# new-post.sh - Create a new blog post for justanesta.com
#
# This script automates the creation of a new blog post including:
# - Generating the markdown file with proper front matter
# - Creating the thumbnail directory structure
# - Updating thumbnails.js with the new post entry
# - Optionally opening the new post in your editor
#
# Usage:
#   ./scripts/new-post.sh
#   ./scripts/new-post.sh --title "My Post Title" --category "Economics"
#

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Parse command line arguments
TITLE=""
CATEGORY=""
DESCRIPTION=""
TAGS=""
SKIP_THUMBNAIL=false
EDITOR_CMD="${EDITOR:-code}"

while [[ $# -gt 0 ]]; do
    case $1 in
        --title|-t)
            TITLE="$2"
            shift 2
            ;;
        --category|-c)
            CATEGORY="$2"
            shift 2
            ;;
        --description|-d)
            DESCRIPTION="$2"
            shift 2
            ;;
        --tags)
            TAGS="$2"
            shift 2
            ;;
        --no-thumbnail)
            SKIP_THUMBNAIL=true
            shift
            ;;
        --editor|-e)
            EDITOR_CMD="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -t, --title TITLE          Post title (will be prompted if not provided)"
            echo "  -c, --category CATEGORY    Post category (will be prompted if not provided)"
            echo "  -d, --description DESC     Post description (will be prompted if not provided)"
            echo "  --tags TAGS                Comma-separated tags (e.g., 'Economics,Finance')"
            echo "  --no-thumbnail             Skip thumbnail directory creation"
            echo "  -e, --editor EDITOR        Editor command (default: \$EDITOR or 'code')"
            echo "  -h, --help                 Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Banner
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📝 New Blog Post Creator"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get project root (script is in scripts/ subdirectory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

# Verify we're in the right directory
if [[ ! -f ".eleventy.js" ]]; then
    print_error "Not in project root (missing .eleventy.js)"
    exit 1
fi

# Interactive prompts if values not provided
if [[ -z "$TITLE" ]]; then
    read -p "Post title: " TITLE
    if [[ -z "$TITLE" ]]; then
        print_error "Title is required"
        exit 1
    fi
fi

if [[ -z "$CATEGORY" ]]; then
    echo ""
    print_info "Common categories: Economics, Sports, Data Journalism, Personal, Technology"
    read -p "Category: " CATEGORY
    if [[ -z "$CATEGORY" ]]; then
        print_error "Category is required"
        exit 1
    fi
fi

if [[ -z "$DESCRIPTION" ]]; then
    read -p "Short description: " DESCRIPTION
    if [[ -z "$DESCRIPTION" ]]; then
        print_warning "No description provided (you can add it later)"
    fi
fi

if [[ -z "$TAGS" ]]; then
    read -p "Tags (comma-separated, optional): " TAGS
fi

# Generate slug from title
# Convert to lowercase, replace spaces with hyphens, remove special chars
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9 -]//g' | \
    sed 's/ \+/-/g' | \
    sed 's/^-\+//' | \
    sed 's/-\+$//')

print_info "Generated slug: $SLUG"

# Get today's date in YYYY-MM-DD format
DATE=$(date +%Y-%m-%d)

# File paths
BLOG_FILE="src/blog/${SLUG}.md"
THUMBNAIL_DIR="src/public/images/posts/${SLUG}"
THUMBNAIL_FILE="${THUMBNAIL_DIR}/thumbnail.jpg"
THUMBNAILS_DATA="src/_data/thumbnails.js"

# Check if post already exists
if [[ -f "$BLOG_FILE" ]]; then
    print_error "A post with this slug already exists: $BLOG_FILE"
    read -p "Open existing file instead? (y/N): " OPEN_EXISTING
    if [[ "$OPEN_EXISTING" =~ ^[Yy]$ ]]; then
        $EDITOR_CMD "$BLOG_FILE"
        exit 0
    fi
    exit 1
fi

# Parse tags into YAML array format
TAGS_YAML=""
if [[ -n "$TAGS" ]]; then
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    for tag in "${TAG_ARRAY[@]}"; do
        # Trim whitespace
        tag=$(echo "$tag" | xargs)
        if [[ -n "$tag" ]]; then
            TAGS_YAML="${TAGS_YAML}  - ${tag}
"
        fi
    done
fi

# Create the markdown file with front matter
echo ""
print_info "Creating blog post file..."

cat > "$BLOG_FILE" << EOF
---
layout: layouts/post.njk
title: "$TITLE"
date: $DATE
category: "$CATEGORY"
description: "$DESCRIPTION"
tags:
$(echo -e "$TAGS_YAML")  - post
---

Write your blog post content here using Markdown.

## Example Section

You can use:
- **Bold** and *italic* text
- [Links](https://example.com)
- Code blocks
- Images
- And more!

### Subsection

Remember to add your thumbnail image to:
\`$THUMBNAIL_DIR/thumbnail.jpg\`

Recommended size: 1200×675 pixels (16:9 ratio)
Target file size: Under 100KB
EOF

print_success "Created: $BLOG_FILE"

# Create thumbnail directory
if [[ "$SKIP_THUMBNAIL" == false ]]; then
    echo ""
    print_info "Creating thumbnail directory..."

    mkdir -p "$THUMBNAIL_DIR"
    print_success "Created: $THUMBNAIL_DIR"

    print_warning "Don't forget to add your thumbnail image:"
    echo "           $THUMBNAIL_FILE"
    echo "           Recommended: 1200×675px (16:9), under 100KB"
fi

# Update thumbnails.js
echo ""
print_info "Updating thumbnails.js..."

# Create the new thumbnail entry (unified slug-based system)
# Only stores alt text - path is auto-generated from slug
NEW_THUMB_ENTRY="    '${SLUG}': {
      alt: 'TODO: Add descriptive alt text for ${TITLE}'
    },"

# Find the posts section and insert the new entry
# We'll insert it after the "posts: {" line
if grep -q "posts: {" "$THUMBNAILS_DATA"; then
    # Use awk to insert after "posts: {" line
    awk -v entry="$NEW_THUMB_ENTRY" '
        /posts: \{/ { print; print entry; next }
        { print }
    ' "$THUMBNAILS_DATA" > "${THUMBNAILS_DATA}.tmp"

    mv "${THUMBNAILS_DATA}.tmp" "$THUMBNAILS_DATA"
    print_success "Added thumbnail entry to $THUMBNAILS_DATA"
    print_warning "Remember to update the alt text in thumbnails.js!"
else
    print_error "Could not find 'posts:' section in $THUMBNAILS_DATA"
    print_info "You'll need to manually add the thumbnail entry"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✨ Post Created Successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📄 Blog post: $BLOG_FILE"
echo "🖼️  Thumbnail: $THUMBNAIL_FILE"
echo ""
echo "Next steps:"
echo "  1. Write your blog post content in the markdown file"
echo "  2. Add a thumbnail image (1200×675px, under 100KB)"
echo "  3. Update the alt text in $THUMBNAILS_DATA"
echo "  4. Preview with: npm run serve"
echo "  5. Build with: npm run build"
echo ""

# Open in editor
read -p "Open in editor now? (Y/n): " OPEN_EDITOR
if [[ ! "$OPEN_EDITOR" =~ ^[Nn]$ ]]; then
    print_info "Opening in $EDITOR_CMD..."
    $EDITOR_CMD "$BLOG_FILE"
fi

print_success "Done! Happy writing! 📝"
echo ""