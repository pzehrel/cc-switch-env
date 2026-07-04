#!/usr/bin/env sh
# cc-switch-env install script
#
# Local install:
#   git clone ... && cd cc-switch-env && ./install.sh
#
# Online install:
#   curl -fsSL https://raw.githubusercontent.com/pzehrel/cc-switch-env/main/install.sh | bash

set -e

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ccse"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ccse"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_URL="https://raw.githubusercontent.com/pzehrel/cc-switch-env/main"

# Detect install mode: local repo or online
if [ -f "$SCRIPT_DIR/ccse" ]; then
    MODE="local"
    SRC="$SCRIPT_DIR"
else
    MODE="online"
    SRC="$DATA_DIR/.tmp-install"
    mkdir -p "$SRC/providers" "$SRC/completions"
    echo "==> Downloading from $REPO_URL ..."
    curl -fsSL "$REPO_URL/ccse" -o "$SRC/ccse"
    curl -fsSL "$REPO_URL/secrets.example" -o "$SRC/secrets.example"
    for f in deepseek kimi glm minimax litellm; do
        curl -fsSL "$REPO_URL/providers/${f}.zsh" -o "$SRC/providers/${f}.zsh"
    done
    curl -fsSL "$REPO_URL/completions/_ccse" -o "$SRC/completions/_ccse"
    curl -fsSL "$REPO_URL/completions/ccse.bash" -o "$SRC/completions/ccse.bash"
fi

echo "==> cc-switch-env install ($MODE)"

# Create target directories
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR/providers"
mkdir -p "$CONFIG_DIR/completions"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/vars"

# Install log (for uninstall)
LOG="$DATA_DIR/install.log"
> "$LOG"

# Install main script
cp "$SRC/ccse" "$BIN_DIR/ccse"
chmod +x "$BIN_DIR/ccse"
echo "$BIN_DIR/ccse" >> "$LOG"

# Install provider files
for f in "$SRC/providers"/*.zsh; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    cp "$f" "$CONFIG_DIR/providers/$name"
    echo "$CONFIG_DIR/providers/$name" >> "$LOG"
done

# Install completion files
if [ -f "$SRC/completions/_ccse" ]; then
    cp "$SRC/completions/_ccse" "$CONFIG_DIR/completions/_ccse"
    echo "$CONFIG_DIR/completions/_ccse" >> "$LOG"
fi
if [ -f "$SRC/completions/ccse.bash" ]; then
    cp "$SRC/completions/ccse.bash" "$CONFIG_DIR/completions/ccse.bash"
    echo "$CONFIG_DIR/completions/ccse.bash" >> "$LOG"
fi

# Secrets template (only if not already present)
if [ ! -f "$CONFIG_DIR/secrets" ]; then
    cp "$SRC/secrets.example" "$CONFIG_DIR/secrets"
    echo "$CONFIG_DIR/secrets" >> "$LOG"
    echo "==> secrets created: $CONFIG_DIR/secrets"
    echo "    Edit this file and fill in your real API keys"
else
    echo "==> secrets already exists, skipping"
fi

# Clean up online temp files
[ "$MODE" = "online" ] && rm -rf "$SRC"

echo ""
echo "==> Install complete"
echo ""
echo "Add the following lines to your .zshrc or .bashrc:"
echo ""
echo "    eval \"\$(ccse init)\""
echo "    source $CONFIG_DIR/completions/_ccse     # zsh"
echo "    # source $CONFIG_DIR/completions/ccse.bash   # bash"
echo ""
echo "Then restart your terminal or run: source ~/.zshrc"
