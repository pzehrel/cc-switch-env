#!/usr/bin/env sh
# cc-switch-env install script

set -e

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ccse"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ccse"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> cc-switch-env install"

# Create directories
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR/providers"
mkdir -p "$CONFIG_DIR/completions"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/vars"

# Install log (for uninstall)
LOG="$DATA_DIR/install.log"
> "$LOG"

# Install main script
cp "$SCRIPT_DIR/ccse" "$BIN_DIR/ccse"
chmod +x "$BIN_DIR/ccse"
echo "$BIN_DIR/ccse" >> "$LOG"

# Install provider files
for f in "$SCRIPT_DIR/providers"/*.zsh; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    cp "$f" "$CONFIG_DIR/providers/$name"
    echo "$CONFIG_DIR/providers/$name" >> "$LOG"
done

# Install completion files
if [ -f "$SCRIPT_DIR/completions/_ccse" ]; then
    cp "$SCRIPT_DIR/completions/_ccse" "$CONFIG_DIR/completions/_ccse"
    echo "$CONFIG_DIR/completions/_ccse" >> "$LOG"
fi
if [ -f "$SCRIPT_DIR/completions/ccse.bash" ]; then
    cp "$SCRIPT_DIR/completions/ccse.bash" "$CONFIG_DIR/completions/ccse.bash"
    echo "$CONFIG_DIR/completions/ccse.bash" >> "$LOG"
fi

# Secrets template (only if not already present)
if [ ! -f "$CONFIG_DIR/secrets" ]; then
    cp "$SCRIPT_DIR/secrets.example" "$CONFIG_DIR/secrets"
    echo "$CONFIG_DIR/secrets" >> "$LOG"
    echo "==> secrets created: $CONFIG_DIR/secrets"
    echo "    Edit this file and fill in your real API keys"
else
    echo "==> secrets already exists, skipping"
fi

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
