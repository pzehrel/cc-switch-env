#!/usr/bin/env sh
# cc-switch-env uninstall script

set -e

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ccse"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ccse"
LOG="$DATA_DIR/install.log"

echo "==> cc-switch-env uninstall"

if [ ! -f "$LOG" ]; then
    echo "install.log not found — may already be uninstalled"
    echo ""
    echo "Manual cleanup:"
    echo "  1. Remove eval \"\$(ccse init)\" from .zshrc / .bashrc"
    echo "  2. Remove completion source line"
    echo "  3. rm -rf $CONFIG_DIR"
    echo "  4. rm -rf $DATA_DIR"
    echo "  5. rm -f ~/.local/bin/ccse"
    exit 0
fi

# Remove files recorded in install.log
while IFS= read -r file; do
    [ -z "$file" ] && continue
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "rm $file"
    fi
done < "$LOG"

# Remove install.log itself
rm -f "$LOG"

# Remove empty directories
rmdir "$DATA_DIR/vars" 2>/dev/null || true
rmdir "$DATA_DIR" 2>/dev/null || true

# Clean completion directory
if [ -d "$CONFIG_DIR/completions" ]; then
    rm -f "$CONFIG_DIR/completions/_ccse"
    rm -f "$CONFIG_DIR/completions/ccse.bash"
    rmdir "$CONFIG_DIR/completions" 2>/dev/null || true
fi

echo ""
echo "==> Uninstall complete"
echo ""
echo "Manual steps remaining:"
echo "  1. Remove eval \"\$(ccse init)\" from .zshrc / .bashrc"
echo "  2. Remove completion source line"
echo ""
echo "The following directory still exists (may contain secrets and custom providers):"
echo "  $CONFIG_DIR"
echo "  If you no longer need it, run: rm -rf $CONFIG_DIR"
