#!/usr/bin/env sh
# cc-switch-env uninstall script

set -e

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ccenv"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ccenv"
LOG="$DATA_DIR/install.log"

echo "==> cc-switch-env uninstall"

if [ ! -f "$LOG" ]; then
    echo "未找到 install.log，可能已卸载"
    echo ""
    echo "手动清理："
    echo "  1. 从 .zshrc / .bashrc 中删除 eval \"\$(ccenv init)\" 行"
    echo "  2. 删除 completion source 行"
    echo "  3. rm -rf $CONFIG_DIR"
    echo "  4. rm -rf $DATA_DIR"
    echo "  5. rm -f ~/.local/bin/ccenv"
    exit 0
fi

# 按 install.log 逐文件删除
while IFS= read -r file; do
    [ -z "$file" ] && continue
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "rm $file"
    fi
done < "$LOG"

# 删除 install.log
rm -f "$LOG"

# 清理空目录
rmdir "$DATA_DIR/vars" 2>/dev/null || true
rmdir "$DATA_DIR" 2>/dev/null || true

# 清理 completions 目录（可能残留用户自己的文件）
if [ -d "$CONFIG_DIR/completions" ]; then
    rm -f "$CONFIG_DIR/completions/_ccse"
    rm -f "$CONFIG_DIR/completions/ccse.bash"
    rmdir "$CONFIG_DIR/completions" 2>/dev/null || true
fi

echo ""
echo "==> 卸载完成"
echo ""
echo "还需要手动操作："
echo "  1. 从 .zshrc / .bashrc 中删除 eval \"\$(ccenv init)\" 行"
echo "  2. 删除 completion source 行"
echo ""
echo "以下目录仍保留（可能含 secrets 和自定义 provider）："
echo "  $CONFIG_DIR"
echo "  如确认不再需要，手动执行: rm -rf $CONFIG_DIR"
