#!/usr/bin/env bash
#
# new-clip.sh - Add a new clip/published work to justanesta.com
#
# This script automates adding a new clip including:
# - Adding clip entry to clips.js with proper date handling
# - Optionally opening clips.js in your editor
#
# Usage:
#   ./scripts/new-clip.sh
#   ./scripts/new-clip.sh --title "My Article" --publication "Publication Name"
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
PUBLICATION=""
DATE=""
DESCRIPTION=""
TAGS=""
URL=""
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
        --publication|-p)
            PUBLICATION="$2"
            shift 2
            ;;
        --date)
            DATE="$2"
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
        --url|-u)
            URL="$2"
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
            echo "  -t, --title TITLE          Article/clip title (will be prompted if not provided)"
            echo "  --id ID                    Clip ID/slug (auto-generated from title if not provided)"
            echo "  -p, --publication PUB      Publication name"
            echo "  --date DATE                Publication date (YYYY-MM-DD, defaults to today)"
            echo "  -d, --description DESC     Brief description of the article"
            echo "  --tags TAGS                Comma-separated tags (e.g., 'Data Analysis,Economics')"
            echo "  -u, --url URL              URL to the published article"
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
echo "  📰 New Clip Creator"
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

CLIPS_FILE="src/_data/clips.js"

# Interactive prompts if values not provided
if [[ -z "$TITLE" ]]; then
    read -p "Article title: " TITLE
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

if [[ -z "$PUBLICATION" ]]; then
    echo ""
    print_info "Common publications: Verywell Health, Investopedia, City Limits"
    read -p "Publication: " PUBLICATION
    if [[ -z "$PUBLICATION" ]]; then
        print_error "Publication is required"
        exit 1
    fi
fi

if [[ -z "$DATE" ]]; then
    DATE=$(date +%Y-%m-%d)
    print_info "Using today's date: $DATE"
else
    print_info "Using provided date: $DATE"
fi

if [[ -z "$DESCRIPTION" ]]; then
    read -p "Description: " DESCRIPTION
    if [[ -z "$DESCRIPTION" ]]; then
        print_warning "No description provided (you can add it later)"
    fi
fi

if [[ -z "$TAGS" ]]; then
    echo ""
    print_info "Common tags: Data Analysis, Data Viz, Economics, Health"
    read -p "Tags (comma-separated, optional): " TAGS
fi

if [[ -z "$URL" ]]; then
    read -p "Article URL: " URL
    if [[ -z "$URL" ]]; then
        print_error "URL is required"
        exit 1
    fi
fi

# Parse tags into JavaScript array format
TAGS_ARRAY=""
if [[ -n "$TAGS" ]]; then
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    for tag in "${TAG_ARRAY[@]}"; do
        # Trim whitespace
        tag=$(echo "$tag" | xargs)
        if [[ -n "$tag" ]]; then
            if [[ -z "$TAGS_ARRAY" ]]; then
                TAGS_ARRAY="'${tag}'"
            else
                TAGS_ARRAY="${TAGS_ARRAY}, '${tag}'"
            fi
        fi
    done
fi

# Create the new clip entry
NEW_CLIP="  {
    id: '${ID}',
    title: '${TITLE}',
    publication: '${PUBLICATION}',
    date: new Date('${DATE}'),"

if [[ -n "$DESCRIPTION" ]]; then
    NEW_CLIP="${NEW_CLIP}
    description: '${DESCRIPTION}',"
fi

if [[ -n "$TAGS_ARRAY" ]]; then
    NEW_CLIP="${NEW_CLIP}
    tags: [${TAGS_ARRAY}],"
fi

NEW_CLIP="${NEW_CLIP}
    url: '${URL}'
  }"

# Add clip to clips.js
echo ""
print_info "Adding clip to $CLIPS_FILE..."

# Group by publication for better organization
# Find if publication already exists and add after last entry of that publication
# Otherwise add at the end of the array

if grep -q "publication: '${PUBLICATION}'" "$CLIPS_FILE"; then
    print_info "Found existing ${PUBLICATION} entries, grouping with them..."

    # Find the last occurrence of this publication and insert after it
    awk -v entry="$NEW_CLIP" -v pub="$PUBLICATION" '
        /publication:/ {
            if ($0 ~ pub) {
                last_pub_line = NR
            }
        }
        {
            lines[NR] = $0
        }
        END {
            for (i = 1; i <= NR; i++) {
                print lines[i]
                if (i == last_pub_line) {
                    # Find the closing brace of this entry
                    for (j = i + 1; j <= NR; j++) {
                        print lines[j]
                        i = j
                        if (lines[j] ~ /^  \},?$/) {
                            print ","
                            print entry
                            break
                        }
                    }
                }
            }
        }
    ' "$CLIPS_FILE" > "${CLIPS_FILE}.tmp"
else
    print_info "No existing ${PUBLICATION} entries, adding to end..."

    # Add at the end of the array
    awk -v entry="$NEW_CLIP" '
        /^];/ {
            if (prev_line !~ /module.exports = \[/) {
                print ","
            }
            print ""
            print "  // " toupper(substr(entry, index(entry, "publication:") + 15, 20))
            print entry
            print
            next
        }
        { prev_line = $0; print }
    ' "$CLIPS_FILE" > "${CLIPS_FILE}.tmp"
fi

mv "${CLIPS_FILE}.tmp" "$CLIPS_FILE"
print_success "Added clip to $CLIPS_FILE"

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✨ Clip Created Successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📰 Clip: $TITLE"
echo "📅 Date: $DATE"
echo "📖 Publication: $PUBLICATION"
echo "🆔 ID: $ID"
echo "🔗 URL: $URL"
echo "📄 Clips file: $CLIPS_FILE"
echo ""
echo "Next steps:"
echo "  1. Review the clip entry in $CLIPS_FILE"
echo "  2. Preview with: npm run start"
echo "  3. Build with: npm run build"
echo ""

# Open in editor
read -p "Open clips.js in editor now? (Y/n): " OPEN_EDITOR
if [[ ! "$OPEN_EDITOR" =~ ^[Nn]$ ]]; then
    print_info "Opening in $EDITOR_CMD..."
    $EDITOR_CMD "$CLIPS_FILE"
fi

print_success "Done! 📰"
echo ""
