#!/usr/bin/env bash
# Repository health check script

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "🔍 Repository Health Check"
echo "=========================="

# Check git status
log_info "Checking git status..."
if git status --porcelain | grep -q .; then
    log_warning "Repository has uncommitted changes"
    git status --short
else
    log_success "Repository is clean"
fi

# Check for required tools
log_info "Checking required tools..."
tools=("git" "shellcheck" "python3" "make")
missing_tools=()

for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        log_success "$tool is available"
    else
        log_error "$tool is missing"
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    log_error "Missing tools: ${missing_tools[*]}"
    echo "Run 'make check-deps' for installation instructions"
    exit 1
fi

# Check file permissions
log_info "Checking script permissions..."
find scripts/ -name "*.sh" -type f ! -executable -print0 | while IFS= read -r -d '' script; do
    log_warning "Script not executable: $script"
done

find .config/ -name "*.sh" -type f ! -executable -print0 | while IFS= read -r -d '' script; do
    log_warning "Script not executable: $script"
done

# Validate configurations
log_info "Validating configuration files..."
if make validate >/dev/null 2>&1; then
    log_success "All configuration files are valid"
else
    log_error "Configuration validation failed"
    make validate
    exit 1
fi

# Check for potential security issues
log_info "Checking for potential security issues..."
if command -v detect-secrets >/dev/null 2>&1; then
    if detect-secrets scan --baseline .secrets.baseline >/dev/null 2>&1; then
        log_success "No new secrets detected"
    else
        log_warning "Potential secrets detected - run 'make security' for details"
    fi
else
    log_warning "detect-secrets not installed - skipping security scan"
fi

# Check disk usage in common cache directories
log_info "Checking cache directory sizes..."
cache_dirs=(
    "$HOME/.cache/wallpaper-selector"
    "$HOME/.cache"
    "$HOME/.local/share/Trash"
)

for dir in "${cache_dirs[@]}"; do
    if [ -d "$dir" ]; then
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        if [ -n "$size" ]; then
            echo "  $dir: $size"
        fi
    fi
done

# Summary
echo
echo "🎯 Health Check Summary"
echo "======================="
log_success "Repository health check completed"
echo "Run 'make help' to see available maintenance commands"