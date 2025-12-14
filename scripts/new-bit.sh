#!/usr/bin/env bash
#
# new-bit.sh - Create a new bit (short-form post) for justanesta.com
#
# This script automates the creation of a new bit including:
# - Generating the markdown file with proper front matter
# - Optionally opening the new bit in your editor
#
# Bits are short how-to posts and don't typically have:
# - Categories (only tags)
# - Thumbnail images (short-form content)
#
# Usage:
#   ./scripts/new-bit.sh
#   ./scripts/new-bit.sh --title "How to Setup SSH Keys" --tags "ssh,security"
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
DESCRIPTION=""
TAGS=""
EDITOR_CMD="${EDITOR:-code}"

while [[ $# -gt 0 ]]; do
    case $1 in
        --title|-t)
            TITLE="$2"
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
        --editor|-e)
            EDITOR_CMD="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -t, --title TITLE          Bit title (will be prompted if not provided)"
            echo "  -d, --description DESC     Bit description (will be prompted if not provided)"
            echo "  --tags TAGS                Comma-separated tags (e.g., 'ssh,security,linux')"
            echo "  -e, --editor EDITOR        Editor command (default: \$EDITOR or 'code')"
            echo "  -h, --help                 Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --title 'How to Setup SSH Keys' --tags 'ssh,security'"
            echo "  $0 -t 'Python Virtual Environments' -d 'Quick guide to venv' --tags 'python'"
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
echo "  💡 New Bit Creator"
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
    read -p "Bit title: " TITLE
    if [[ -z "$TITLE" ]]; then
        print_error "Title is required"
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
    echo ""
    print_info "Common tags: python, javascript, linux, git, cli, productivity, vscode"
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

# File path
BIT_FILE="src/bits/${SLUG}.md"

# Check if bit already exists
if [[ -f "$BIT_FILE" ]]; then
    print_error "A bit with this slug already exists: $BIT_FILE"
    read -p "Open existing file instead? (y/N): " OPEN_EXISTING
    if [[ "$OPEN_EXISTING" =~ ^[Yy]$ ]]; then
        $EDITOR_CMD "$BIT_FILE"
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
print_info "Creating bit file..."

cat > "$BIT_FILE" << EOF
---
layout: layouts/bit.njk
title: "$TITLE"
date: $DATE
description: "$DESCRIPTION"
tags:
$(echo -e "$TAGS_YAML")  - bit
---

Write your bit content here using Markdown. Keep it concise and focused!

## Quick Steps

1. First step
2. Second step
3. Third step

## Code Example

\`\`\`bash
# Example command
echo "Hello, World!"
\`\`\`

## Notes

- Bits are short-form content (typically under 500 words)
- Focus on practical "how-to" content
- Use code examples liberally
- Keep it scannable with headers and lists
EOF

print_success "Created: $BIT_FILE"

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✨ Bit Created Successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📄 Bit file: $BIT_FILE"
echo ""
echo "Next steps:"
echo "  1. Write your bit content (keep it short and practical!)"
echo "  2. Preview with: npm run serve"
echo "  3. Build with: npm run build"
echo ""

# Open in editor
read -p "Open in editor now? (Y/n): " OPEN_EDITOR
if [[ ! "$OPEN_EDITOR" =~ ^[Nn]$ ]]; then
    print_info "Opening in $EDITOR_CMD..."
    $EDITOR_CMD "$BIT_FILE"
fi

print_success "Done! Happy writing! 💡"
echo ""
