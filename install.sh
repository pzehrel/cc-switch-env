#!/usr/bin/env sh
# cc-switch-env install script

set -e

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ccenv"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ccenv"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> cc-switch-env install"

# 创建目录
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR/providers"
mkdir -p "$CONFIG_DIR/completions"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/vars"

# 安装记录
LOG="$DATA_DIR/install.log"
> "$LOG"

# 安装 ccenv 脚本
cp "$SCRIPT_DIR/ccenv" "$BIN_DIR/ccenv"
chmod +x "$BIN_DIR/ccenv"
echo "$BIN_DIR/ccenv" >> "$LOG"

# 安装 provider 文件
for f in "$SCRIPT_DIR/providers"/*.zsh; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    cp "$f" "$CONFIG_DIR/providers/$name"
    echo "$CONFIG_DIR/providers/$name" >> "$LOG"
done

# 安装补全文件
if [ -f "$SCRIPT_DIR/completions/_ccse" ]; then
    cp "$SCRIPT_DIR/completions/_ccse" "$CONFIG_DIR/completions/_ccse"
    echo "$CONFIG_DIR/completions/_ccse" >> "$LOG"
fi
if [ -f "$SCRIPT_DIR/completions/ccse.bash" ]; then
    cp "$SCRIPT_DIR/completions/ccse.bash" "$CONFIG_DIR/completions/ccse.bash"
    echo "$CONFIG_DIR/completions/ccse.bash" >> "$LOG"
fi

# secrets 模板（仅在不存在时复制）
if [ ! -f "$CONFIG_DIR/secrets" ]; then
    cp "$SCRIPT_DIR/secrets.example" "$CONFIG_DIR/secrets"
    echo "$CONFIG_DIR/secrets" >> "$LOG"
    echo "==> secrets 文件已创建: $CONFIG_DIR/secrets"
    echo "    请编辑此文件，填入真实的 API key"
else
    echo "==> secrets 文件已存在，跳过"
fi

echo ""
echo "==> 安装完成"
echo ""
echo "在 .zshrc 或 .bashrc 中添加以下行："
echo ""
echo "    eval \"\$(ccenv init)\""
echo "    source $CONFIG_DIR/completions/_ccse     # zsh"
echo "    # source $CONFIG_DIR/completions/ccse.bash   # bash"
echo ""
echo "然后重新打开终端或执行 source ~/.zshrc"
