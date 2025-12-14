#!/usr/bin/env bash
#
# new-project.sh - Add a new project to justanesta.com
#
# This script automates adding a new project including:
# - Adding project entry to projects.js
# - Creating the thumbnail directory structure
# - Adding thumbnail entry to thumbnails.js
# - Optionally opening projects.js in your editor
#
# Usage:
#   ./scripts/new-project.sh
#   ./scripts/new-project.sh --title "My Project" --id "my-project"
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
ID=""
SUBTITLE=""
DESCRIPTION=""
SKILLS=""
DEMO_URL=""
GITHUB_URL=""
SKIP_THUMBNAIL=false
EDITOR_CMD="${EDITOR:-code}"

while [[ $# -gt 0 ]]; do
    case $1 in
        --title|-t)
            TITLE="$2"
            shift 2
            ;;
        --id)
            ID="$2"
            shift 2
            ;;
        --subtitle|-s)
            SUBTITLE="$2"
            shift 2
            ;;
        --description|-d)
            DESCRIPTION="$2"
            shift 2
            ;;
        --skills)
            SKILLS="$2"
            shift 2
            ;;
        --demo)
            DEMO_URL="$2"
            shift 2
            ;;
        --github|-g)
            GITHUB_URL="$2"
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
            echo "  -t, --title TITLE          Project title (will be prompted if not provided)"
            echo "  --id ID                    Project ID/slug (auto-generated from title if not provided)"
            echo "  -s, --subtitle SUBTITLE    Project subtitle/tagline"
            echo "  -d, --description DESC     Project description"
            echo "  --skills SKILLS            Comma-separated skills (e.g., 'python,Django,PostgreSQL')"
            echo "  --demo URL                 Demo/live site URL"
            echo "  -g, --github URL           GitHub repository URL"
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
echo "  🚀 New Project Creator"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

# Verify we're in the right directory
if [[ ! -f ".eleventy.js" ]]; then
    print_error "Not in project root (missing .eleventy.js)"
    exit 1
fi

PROJECTS_FILE="src/_data/projects.js"
THUMBNAILS_FILE="src/_data/thumbnails.js"

# Interactive prompts if values not provided
if [[ -z "$TITLE" ]]; then
    read -p "Project title: " TITLE
    if [[ -z "$TITLE" ]]; then
        print_error "Title is required"
        exit 1
    fi
fi

# Generate ID from title if not provided
if [[ -z "$ID" ]]; then
    ID=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | \
        sed 's/[^a-z0-9 -]//g' | \
        sed 's/ \+/-/g' | \
        sed 's/^-\+//' | \
        sed 's/-\+$//')
    print_info "Generated ID: $ID"
else
    print_info "Using provided ID: $ID"
fi

if [[ -z "$SUBTITLE" ]]; then
    read -p "Subtitle/tagline: " SUBTITLE
fi

if [[ -z "$DESCRIPTION" ]]; then
    read -p "Description: " DESCRIPTION
    if [[ -z "$DESCRIPTION" ]]; then
        print_warning "No description provided (you can add it later)"
    fi
fi

if [[ -z "$SKILLS" ]]; then
    echo ""
    print_info "Common skills: python, JavaScript, R, Django, React, PostgreSQL, MongoDB"
    read -p "Skills (comma-separated, optional): " SKILLS
fi

if [[ -z "$DEMO_URL" ]]; then
    read -p "Demo/live URL (optional): " DEMO_URL
fi

if [[ -z "$GITHUB_URL" ]]; then
    read -p "GitHub URL (optional): " GITHUB_URL
fi

# Parse skills into JavaScript array format
SKILLS_ARRAY=""
if [[ -n "$SKILLS" ]]; then
    IFS=',' read -ra SKILL_ARRAY <<< "$SKILLS"
    for skill in "${SKILL_ARRAY[@]}"; do
        # Trim whitespace
        skill=$(echo "$skill" | xargs)
        if [[ -n "$skill" ]]; then
            if [[ -z "$SKILLS_ARRAY" ]]; then
                SKILLS_ARRAY="'${skill}'"
            else
                SKILLS_ARRAY="${SKILLS_ARRAY}, '${skill}'"
            fi
        fi
    done
fi

# Build links object
LINKS_OBJ=""
if [[ -n "$DEMO_URL" || -n "$GITHUB_URL" ]]; then
    LINKS_OBJ="links: {"
    if [[ -n "$DEMO_URL" ]]; then
        LINKS_OBJ="${LINKS_OBJ}
      demo: '${DEMO_URL}'"
        if [[ -n "$GITHUB_URL" ]]; then
            LINKS_OBJ="${LINKS_OBJ},"
        fi
    fi
    if [[ -n "$GITHUB_URL" ]]; then
        LINKS_OBJ="${LINKS_OBJ}
      github: '${GITHUB_URL}'"
    fi
    LINKS_OBJ="${LINKS_OBJ}
    }"
fi

# Create the new project entry
NEW_PROJECT="  {
    id: '${ID}',
    title: '${TITLE}',
    subtitle: '${SUBTITLE}',
    description: '${DESCRIPTION}',"

if [[ -n "$SKILLS_ARRAY" ]]; then
    NEW_PROJECT="${NEW_PROJECT}
    skillDetails: [${SKILLS_ARRAY}].map(skill => skills.getSkill(skill)).filter(Boolean),"
fi

if [[ -n "$LINKS_OBJ" ]]; then
    NEW_PROJECT="${NEW_PROJECT}
    ${LINKS_OBJ}"
fi

NEW_PROJECT="${NEW_PROJECT}
  }"

# Add project to projects.js
echo ""
print_info "Adding project to $PROJECTS_FILE..."

# Find the closing bracket of the array and insert before it
if grep -q "module.exports = \[" "$PROJECTS_FILE"; then
    # Create a temp file with the new project
    awk -v entry="$NEW_PROJECT" '
        /^];/ {
            if (prev_line !~ /module.exports = \[/) {
                print ","
            }
            print entry
            print
            next
        }
        { prev_line = $0; print }
    ' "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

    mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
    print_success "Added project to $PROJECTS_FILE"
else
    print_error "Could not find module.exports array in $PROJECTS_FILE"
    exit 1
fi

# Create thumbnail directory
THUMBNAIL_DIR="src/public/images/projects/${ID}"
THUMBNAIL_FILE="${THUMBNAIL_DIR}/thumbnail.jpg"

if [[ "$SKIP_THUMBNAIL" == false ]]; then
    echo ""
    print_info "Creating thumbnail directory..."

    mkdir -p "$THUMBNAIL_DIR"
    print_success "Created: $THUMBNAIL_DIR"

    print_warning "Don't forget to add your thumbnail image:"
    echo "           $THUMBNAIL_FILE"
    echo "           Recommended: 128×128px or larger (square), under 50KB"
fi

# Update thumbnails.js
echo ""
print_info "Updating thumbnails.js..."

NEW_THUMB_ENTRY="    '${ID}': {
      alt: 'TODO: Add descriptive alt text for ${TITLE}'
    },"

if grep -q "projects: {" "$THUMBNAILS_FILE"; then
    awk -v entry="$NEW_THUMB_ENTRY" '
        /projects: \{/ { print; print entry; next }
        { print }
    ' "$THUMBNAILS_FILE" > "${THUMBNAILS_FILE}.tmp"

    mv "${THUMBNAILS_FILE}.tmp" "$THUMBNAILS_FILE"
    print_success "Added thumbnail entry to $THUMBNAILS_FILE"
    print_warning "Remember to update the alt text in thumbnails.js!"
else
    print_error "Could not find 'projects:' section in $THUMBNAILS_FILE"
    print_info "You'll need to manually add the thumbnail entry"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✨ Project Created Successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📦 Project: $TITLE"
echo "🆔 ID: $ID"
echo "📄 Projects file: $PROJECTS_FILE"
echo "🖼️  Thumbnail: $THUMBNAIL_FILE"
echo ""
echo "Next steps:"
echo "  1. Add a thumbnail image (square, under 50KB)"
echo "  2. Update the alt text in $THUMBNAILS_FILE"
echo "  3. Review and refine the project entry in $PROJECTS_FILE"
echo "  4. Preview with: npm run start"
echo "  5. Build with: npm run build"
echo ""

# Open in editor
read -p "Open projects.js in editor now? (Y/n): " OPEN_EDITOR
if [[ ! "$OPEN_EDITOR" =~ ^[Nn]$ ]]; then
    print_info "Opening in $EDITOR_CMD..."
    $EDITOR_CMD "$PROJECTS_FILE"
fi

print_success "Done! 🚀"
echo ""
