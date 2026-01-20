#!/usr/bin/env bash
# Nexus Programming Language - Universal Installer
# Works on: Linux, macOS, Windows, Termux, 32-bit, 64-bit
# Usage: bash <(curl -sL https://github.com/nekocd10/maybe-a-custom-language/raw/main/installer.sh)
# Or:    bash <(wget -qO- https://github.com/nekocd10/maybe-a-custom-language/raw/main/installer.sh)

set -e

# Color codes (compatible with Termux and all devices)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Disable colors on devices that don't support them
if [ "$TERM" = "dumb" ] || [ -z "$TERM" ]; then
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      Nexus (nxs) Programming Language      ║${NC}"
    echo -e "${BLUE}║       Universal Installer v2.0             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""
}

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

print_header

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"
KERNEL="$(uname -r)"

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

# Detect Linux distribution for helpful error messages
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Auto-install Python if missing
install_python_if_needed() {
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        return 0
    fi
    
    if command -v python &> /dev/null; then
        PYTHON_CMD="python"
        return 0
    fi
    
    # Python is missing, try to install it
    print_warning "Python 3 not found, attempting to install..."
    
    DISTRO=$(detect_distro)
    
    if [ "$PLATFORM" = "termux" ]; then
        print_info "Installing Python via pkg (Termux)..."
        pkg install -y python 2>/dev/null || {
            print_error "Failed to install Python on Termux"
            exit 1
        }
    elif [ "$DISTRO" = "alpine" ]; then
        print_info "Installing Python via apk (Alpine)..."
        apk add --no-cache python3 py3-pip 2>/dev/null || {
            print_error "Failed to install Python on Alpine. Try manually: apk add --no-cache python3 py3-pip"
            exit 1
        }
    elif [ "$DISTRO" = "debian" ] || [ "$DISTRO" = "ubuntu" ]; then
        print_info "Installing Python via apt (Debian/Ubuntu)..."
        apt-get update 2>/dev/null && apt-get install -y python3 python3-pip 2>/dev/null || {
            print_error "Failed to install Python on Debian/Ubuntu. Try manually: apt-get install -y python3 python3-pip"
            exit 1
        }
    elif [ "$DISTRO" = "fedora" ] || [ "$DISTRO" = "rhel" ] || [ "$DISTRO" = "centos" ]; then
        print_info "Installing Python via dnf (Fedora/RHEL/CentOS)..."
        dnf install -y python3 python3-pip 2>/dev/null || {
            print_error "Failed to install Python on Fedora/RHEL/CentOS. Try manually: dnf install -y python3 python3-pip"
            exit 1
        }
    elif [ "$DISTRO" = "arch" ]; then
        print_info "Installing Python via pacman (Arch)..."
        pacman -S --noconfirm python python-pip 2>/dev/null || {
            print_error "Failed to install Python on Arch. Try manually: pacman -S python python-pip"
            exit 1
        }
    elif [ "$DISTRO" = "opensuse" ] || [ "$DISTRO" = "opensuse-leap" ]; then
        print_info "Installing Python via zypper (openSUSE)..."
        zypper install -y python3 python3-pip 2>/dev/null || {
            print_error "Failed to install Python on openSUSE. Try manually: zypper install -y python3 python3-pip"
            exit 1
        }
    else
        print_error "Could not detect your Linux distribution"
        echo "Please install Python 3.8 or higher manually and try again"
        exit 1
    fi
    
    # Verify installation worked
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        print_success "Python installed successfully"
        return 0
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
        print_success "Python installed successfully"
        return 0
    else
        print_error "Python installation failed"
        exit 1
    fi
}

# Check Python installation
install_python_if_needed

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2)
print_success "Python version: $PYTHON_VERSION"

# Create temporary directory for download
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

print_info "Creating temporary directory: $TEMP_DIR"

# Download the repository
print_info "Downloading Nexus from GitHub..."
cd "$TEMP_DIR"

CLONE_SUCCESS=0

# Try git first
if command -v git &> /dev/null; then
    if git clone --depth 1 https://github.com/nekocd10/maybe-a-custom-language.git nxs-temp 2>/dev/null; then
        mv nxs-temp nxs-repo
        CLONE_SUCCESS=1
    fi
fi

# Try wget if git failed
if [ $CLONE_SUCCESS -eq 0 ] && command -v wget &> /dev/null; then
    print_info "Using wget fallback..."
    if wget -q https://github.com/nekocd10/maybe-a-custom-language/archive/refs/heads/main.zip -O main.zip 2>/dev/null; then
        if command -v unzip &> /dev/null; then
            unzip -q main.zip 2>/dev/null
            mv maybe-a-custom-language-main nxs-repo
            CLONE_SUCCESS=1
        fi
    fi
fi

# Try curl if both failed
if [ $CLONE_SUCCESS -eq 0 ] && command -v curl &> /dev/null; then
    print_info "Using curl fallback..."
    if curl -sL https://github.com/nekocd10/maybe-a-custom-language/archive/refs/heads/main.zip -o main.zip 2>/dev/null; then
        if command -v unzip &> /dev/null; then
            unzip -q main.zip 2>/dev/null
            mv maybe-a-custom-language-main nxs-repo
            CLONE_SUCCESS=1
        fi
    fi
fi

if [ $CLONE_SUCCESS -eq 0 ]; then
    print_error "Failed to download repository with any method"
    print_error "Available tools: git=$(command -v git &>/dev/null && echo yes || echo no), wget=$(command -v wget &>/dev/null && echo yes || echo no), curl=$(command -v curl &>/dev/null && echo yes || echo no), unzip=$(command -v unzip &>/dev/null && echo yes || echo no)"
    exit 1
fi

cd nxs-repo
print_success "Repository downloaded successfully"

# Delete all markdown files to reduce size
print_info "Cleaning up documentation files..."
find . -maxdepth 1 -name "*.md" -type f -delete 2>/dev/null || true
rm -f SHOWCASE.md pormt-for-later.txt 2>/dev/null || true
print_success "Removed markdown files"

# Install Python package to system/user Python environment
print_info "Installing Nexus package..."

# Verify pip is available
if ! $PYTHON_CMD -m pip --version &> /dev/null; then
    print_warning "pip not found, attempting to install it..."
    if command -v apt-get &> /dev/null; then
        apt-get install -y python3-pip 2>/dev/null || true
    elif command -v dnf &> /dev/null; then
        dnf install -y python3-pip 2>/dev/null || true
    elif command -v pacman &> /dev/null; then
        pacman -S --noconfirm python-pip 2>/dev/null || true
    elif command -v apk &> /dev/null; then
        apk add --no-cache py3-pip 2>/dev/null || true
    elif command -v zypper &> /dev/null; then
        zypper install -y python3-pip 2>/dev/null || true
    fi
    
    if ! $PYTHON_CMD -m pip --version &> /dev/null; then
        print_error "pip is not available. Try installing it manually first."
        exit 1
    fi
fi

# Try standard installation
if $PYTHON_CMD -m pip install -e . 2>&1 | grep -q "Successfully installed"; then
    print_success "Package installed to Python environment"
else
    # Try with --user flag
    print_info "Retrying with --user flag..."
    if $PYTHON_CMD -m pip install --user -e . 2>&1 | grep -q "Successfully installed"; then
        print_success "Package installed to Python environment (--user)"
    else
        # Try without editable mode
        print_info "Retrying without editable mode..."
        if $PYTHON_CMD -m pip install --user . 2>&1 | grep -q "Successfully installed"; then
            print_success "Package installed to Python environment"
        else
            print_error "Failed to install package with pip. Try manually:"
            echo "  $PYTHON_CMD -m pip install --user ."
            exit 1
        fi
    fi
fi

# Verify installation

echo ""
echo -e "${GREEN}╔═════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉               ║${NC}"
echo -e "${GREEN}╚═════════════════════════════════════════════╝${NC}"
echo ""
echo "Nexus is now installed!"
echo ""
echo "Quick start:"
echo "  1. Try a command: nexus --version"
echo "  2. Create a program: echo 'println \"Hello!\"' > hello.nexus"
echo "  3. Run it: nexus hello.nexus"
echo ""
echo "Commands:"
echo "  nexus script.nexus      # Run a Nexus program"
echo "  nexus --help            # Show help"
echo "  nxs script.nexus        # Alias for nexus"
echo ""
echo "Supported platforms: Linux, macOS, Windows, Termux (32-bit, 64-bit)"
echo ""
print_success "Enjoy Nexus (nxs)!"
echo ""
