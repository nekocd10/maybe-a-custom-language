#!/usr/bin/env bash
# Nexus Programming Language - Local Installation Script
# Local installation script - runs from the repository
# For curl-based installation, see installer.sh

set -e

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Disable colors on devices that don't support them
if [ "$TERM" = "dumb" ] || [ -z "$TERM" ]; then
    RED='' GREEN='' BLUE='' YELLOW='' NC=''
fi

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

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Nexus (nxs) Programming Language     ║${NC}"
echo -e "${BLUE}║    Installing from local repository       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Detect OS and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Linux*)
        PLATFORM="linux"
        ;;
    Darwin*)
        PLATFORM="macos"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        PLATFORM="windows"
        ;;
    *)
        PLATFORM="unknown"
        ;;
esac

# Detect if running on Termux
if [ -d "$HOME/.termux" ] || [ -n "$TERMUX_VERSION" ]; then
    PLATFORM="termux"
    print_success "Detected: Termux"
else
    print_success "Detected: $PLATFORM"
fi

# Detect architecture
case "$ARCH" in
    x86_64|amd64)
        ARCH_NAME="64-bit x86_64"
        ;;
    x86|i386|i686)
        ARCH_NAME="32-bit x86"
        ;;
    armv7l|armv7)
        ARCH_NAME="32-bit ARM (armv7)"
        ;;
    aarch64|arm64)
        ARCH_NAME="64-bit ARM (aarch64)"
        ;;
    *)
        ARCH_NAME="$ARCH"
        ;;
esac

print_success "Architecture: $ARCH_NAME"

# Check Python installation
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        print_error "Python 3 is required but not installed"
        echo "Please install Python 3.8 or higher"
        if [ "$PLATFORM" = "termux" ]; then
            echo "On Termux, run: pkg install python"
        fi
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2)
print_success "Python version: $PYTHON_VERSION"

# Delete all markdown files to reduce size and clutter
print_info "Cleaning up documentation files..."
find "$SCRIPT_DIR" -maxdepth 1 -name "*.md" -type f -delete 2>/dev/null || true
rm -f "$SCRIPT_DIR/SHOWCASE.md" "$SCRIPT_DIR/pormt-for-later.txt" 2>/dev/null || true
print_success "Removed markdown files"

# Install Python package
echo ""
echo "Installing Nexus package in development mode..."
cd "$SCRIPT_DIR"
$PYTHON_CMD -m pip install -q -e . 2>/dev/null || {
    print_warning "Trying with --user flag..."
    $PYTHON_CMD -m pip install -q --user -e . 2>/dev/null || {
        print_error "Failed to install package"
        exit 1
    }
}

print_success "Package installed successfully"

# Verify installation
echo ""
echo "Verifying installation..."
if nexus --version &> /dev/null; then
    print_success "Nexus CLI is available"
    nexus --version
else
    print_warning "Nexus CLI not found in PATH"
    echo "Please restart your terminal or run:"
    echo "export PATH=\"\$PATH:\$($PYTHON_CMD -m site --user-base)/bin\""
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Quick start:"
echo "  1. Restart terminal or run: source ~/.bashrc"
echo "  2. Create a program: echo 'println \"Hello!\"' > hello.nexus"
echo "  3. Run it: nexus hello.nexus"
echo ""
echo "Commands:"
echo "  nexus script.nexus      # Run a Nexus program"
echo "  nexus --help            # Show help"
echo "  nxs script.nexus        # Alias for nexus"
echo ""
print_success "Enjoy Nexus (nxs)!"
echo ""
