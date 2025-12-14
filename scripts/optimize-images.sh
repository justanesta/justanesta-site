#!/usr/bin/env bash
#
# optimize-images.sh - Optimize images for web in justanesta.com
#
# This script optimizes images for web use including:
# - Finding images that are too large (file size or dimensions)
# - Providing recommendations for optimization
# - Optionally compressing images (if tools are installed)
#
# Usage:
#   ./scripts/optimize-images.sh               # Check only
#   ./scripts/optimize-images.sh --fix         # Optimize images
#   ./scripts/optimize-images.sh --type posts  # Check specific type
#

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_stat() {
    echo -e "${CYAN}→${NC} $1"
}

# Parse command line arguments
FIX_MODE=false
IMAGE_TYPE=""
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --fix|-f)
            FIX_MODE=true
            shift
            ;;
        --type|-t)
            IMAGE_TYPE="$2"
            shift 2
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -f, --fix              Actually optimize images (default: check only)"
            echo "  -t, --type TYPE        Check specific type only (posts, projects, or all)"
            echo "  -v, --verbose          Show detailed information"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./scripts/optimize-images.sh                  # Check all images"
            echo "  ./scripts/optimize-images.sh --type posts     # Check only blog post images"
            echo "  ./scripts/optimize-images.sh --fix            # Optimize all images"
            echo ""
            echo "Requirements (optional, for --fix mode):"
            echo "  - imagemagick (convert): Resize images"
            echo "  - jpegoptim: Optimize JPEG files"
            echo "  - optipng: Optimize PNG files"
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
if [[ "$FIX_MODE" == true ]]; then
    echo "  🔧 Image Optimizer (Fix Mode)"
else
    echo "  🔍 Image Checker (Analysis Mode)"
fi
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

# Check for required tools if in fix mode
if [[ "$FIX_MODE" == true ]]; then
    MISSING_TOOLS=""

    if ! command -v convert &> /dev/null; then
        MISSING_TOOLS="${MISSING_TOOLS}imagemagick, "
    fi

    if ! command -v jpegoptim &> /dev/null; then
        MISSING_TOOLS="${MISSING_TOOLS}jpegoptim, "
    fi

    if ! command -v optipng &> /dev/null; then
        MISSING_TOOLS="${MISSING_TOOLS}optipng, "
    fi

    if [[ -n "$MISSING_TOOLS" ]]; then
        print_warning "Some optimization tools are missing: ${MISSING_TOOLS%, }"
        echo "Install them for full functionality:"
        echo "  Ubuntu/Debian: sudo apt-get install imagemagick jpegoptim optipng"
        echo "  macOS: brew install imagemagick jpegoptim optipng"
        echo ""
        read -p "Continue anyway? (y/N): " CONTINUE
        if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
fi

# Thresholds
POST_MAX_WIDTH=1200
POST_MAX_HEIGHT=675
POST_MAX_SIZE_KB=100

PROJECT_MAX_WIDTH=256
PROJECT_MAX_HEIGHT=256
PROJECT_MAX_SIZE_KB=50

# Counters
TOTAL_CHECKED=0
TOTAL_ISSUES=0
TOTAL_OPTIMIZED=0
TOTAL_SAVINGS_KB=0

# Function to check and optimize an image
check_image() {
    local file="$1"
    local type="$2"  # 'post' or 'project'
    local max_width=$3
    local max_height=$4
    local max_size_kb=$5

    TOTAL_CHECKED=$((TOTAL_CHECKED + 1))

    # Get file size in KB
    local size_kb=$(du -k "$file" | cut -f1)

    # Get image dimensions if imagemagick is available
    local width=0
    local height=0
    if command -v identify &> /dev/null; then
        local dimensions=$(identify -format "%w %h" "$file" 2>/dev/null || echo "0 0")
        width=$(echo "$dimensions" | cut -d' ' -f1)
        height=$(echo "$dimensions" | cut -d' ' -f2)
    fi

    # Check for issues
    local has_issue=false
    local issue_msg=""

    if [[ $size_kb -gt $max_size_kb ]]; then
        has_issue=true
        issue_msg="${issue_msg}Size: ${size_kb}KB (max: ${max_size_kb}KB) "
    fi

    if [[ $width -gt $max_width || $height -gt $max_height ]]; then
        has_issue=true
        issue_msg="${issue_msg}Dimensions: ${width}×${height} (max: ${max_width}×${max_height}) "
    fi

    if [[ "$has_issue" == true ]]; then
        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
        print_warning "Issue: $file"
        echo "           $issue_msg"

        if [[ "$FIX_MODE" == true ]]; then
            local original_size=$size_kb
            local optimized=false

            # Resize if needed
            if [[ $width -gt $max_width || $height -gt $max_height ]]; then
                if command -v convert &> /dev/null; then
                    print_info "   Resizing to ${max_width}×${max_height}..."
                    convert "$file" -resize "${max_width}x${max_height}>" "$file"
                    optimized=true
                fi
            fi

            # Optimize JPEG
            if [[ "$file" =~ \.(jpg|jpeg)$ ]]; then
                if command -v jpegoptim &> /dev/null; then
                    print_info "   Optimizing JPEG..."
                    jpegoptim --max=85 --strip-all "$file" > /dev/null 2>&1
                    optimized=true
                fi
            fi

            # Optimize PNG
            if [[ "$file" =~ \.png$ ]]; then
                if command -v optipng &> /dev/null; then
                    print_info "   Optimizing PNG..."
                    optipng -o2 "$file" > /dev/null 2>&1
                    optimized=true
                fi
            fi

            if [[ "$optimized" == true ]]; then
                local new_size=$(du -k "$file" | cut -f1)
                local savings=$((original_size - new_size))
                TOTAL_OPTIMIZED=$((TOTAL_OPTIMIZED + 1))
                TOTAL_SAVINGS_KB=$((TOTAL_SAVINGS_KB + savings))
                print_success "   Optimized! Saved ${savings}KB (${original_size}KB → ${new_size}KB)"
            fi
        fi
    elif [[ "$VERBOSE" == true ]]; then
        print_success "OK: $file (${size_kb}KB, ${width}×${height})"
    fi
}

# Check blog post images
if [[ -z "$IMAGE_TYPE" || "$IMAGE_TYPE" == "posts" || "$IMAGE_TYPE" == "all" ]]; then
    echo "Checking blog post thumbnails..."
    echo ""

    if [[ -d "src/public/images/posts" ]]; then
        while IFS= read -r -d '' dir; do
            if [[ -f "$dir/thumbnail.jpg" ]]; then
                check_image "$dir/thumbnail.jpg" "post" $POST_MAX_WIDTH $POST_MAX_HEIGHT $POST_MAX_SIZE_KB
            fi
            if [[ -f "$dir/thumbnail.jpeg" ]]; then
                check_image "$dir/thumbnail.jpeg" "post" $POST_MAX_WIDTH $POST_MAX_HEIGHT $POST_MAX_SIZE_KB
            fi
            if [[ -f "$dir/thumbnail.png" ]]; then
                check_image "$dir/thumbnail.png" "post" $POST_MAX_WIDTH $POST_MAX_HEIGHT $POST_MAX_SIZE_KB
            fi
        done < <(find src/public/images/posts -mindepth 1 -maxdepth 1 -type d -print0)
    else
        print_warning "No blog post image directory found"
    fi

    echo ""
fi

# Check project images
if [[ -z "$IMAGE_TYPE" || "$IMAGE_TYPE" == "projects" || "$IMAGE_TYPE" == "all" ]]; then
    echo "Checking project thumbnails..."
    echo ""

    if [[ -d "src/public/images/projects" ]]; then
        while IFS= read -r -d '' dir; do
            if [[ -f "$dir/thumbnail.jpg" ]]; then
                check_image "$dir/thumbnail.jpg" "project" $PROJECT_MAX_WIDTH $PROJECT_MAX_HEIGHT $PROJECT_MAX_SIZE_KB
            fi
            if [[ -f "$dir/thumbnail.jpeg" ]]; then
                check_image "$dir/thumbnail.jpeg" "project" $PROJECT_MAX_WIDTH $PROJECT_MAX_HEIGHT $PROJECT_MAX_SIZE_KB
            fi
            if [[ -f "$dir/thumbnail.png" ]]; then
                check_image "$dir/thumbnail.png" "project" $PROJECT_MAX_WIDTH $PROJECT_MAX_HEIGHT $PROJECT_MAX_SIZE_KB
            fi
        done < <(find src/public/images/projects -mindepth 1 -maxdepth 1 -type d -print0)
    else
        print_warning "No project image directory found"
    fi

    echo ""
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📊 Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_stat "Images checked: $TOTAL_CHECKED"
print_stat "Issues found: $TOTAL_ISSUES"

if [[ "$FIX_MODE" == true ]]; then
    print_stat "Images optimized: $TOTAL_OPTIMIZED"
    print_stat "Total space saved: ${TOTAL_SAVINGS_KB}KB"
    echo ""

    if [[ $TOTAL_OPTIMIZED -gt 0 ]]; then
        print_success "Optimization complete!"
    else
        print_info "No images needed optimization"
    fi
else
    echo ""
    if [[ $TOTAL_ISSUES -gt 0 ]]; then
        print_warning "$TOTAL_ISSUES image(s) need optimization"
        echo ""
        echo "Run with --fix to automatically optimize:"
        echo "  ./scripts/optimize-images.sh --fix"
    else
        print_success "All images are optimized!"
    fi
fi

echo ""
echo "Recommendations:"
echo "  • Blog posts: 1200×675px (16:9), under 100KB, 85% JPEG quality"
echo "  • Projects: 256×256px or smaller (square), under 50KB"
echo "  • Use JPEG for photos, PNG for graphics/logos"
echo ""