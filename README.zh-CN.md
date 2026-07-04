# cc-switch-env

[English](README.md)

Claude Code 运行环境切换工具。一键切换 provider、模型和运行参数。

## 安装

**在线安装（推荐）：**

```bash
curl -fsSL https://raw.githubusercontent.com/pzehrel/cc-switch-env/main/install.sh | bash
```

**从源码安装：**

```bash
git clone git@github.com:pzehrel/cc-switch-env.git
cd cc-switch-env
./install.sh
```

## 配置

### 1. Shell 集成

**zsh** — 在 `~/.zshrc` 中添加：

```zsh
eval "$(ccse init)"
source ~/.config/ccse/completions/_ccse
```

**bash** — 在 `~/.bashrc` 中添加：

```bash
eval "$(ccse init)"
source ~/.config/ccse/completions/ccse.bash
```

### 2. 填写 API Key

```bash
vim ~/.config/ccse/secrets
```

按模板填入各 provider 的 API key。

## 使用

| 命令 | 效果 |
|------|------|
| `ccse ls` | 列出所有 provider（含别名） |
| `ccse current` | 查看当前 provider、默认值、上次使用 |
| `ccse kimi` | 切换到 kimi（会话级，自动记录为 last） |
| `ccse ds` | 使用别名切换（ds → deepseek） |
| `ccse default kimi` | 切换 + 设为默认 |
| `ccse default -d` | 清除默认 |

开终端即可直接 `cc`（`claude`），无需任何手动操作。

## 目录结构

```
~/.local/bin/ccse               ← CLI 本体
~/.config/ccse/                  ← 用户配置
├── secrets                      ← API keys（不提交）
├── providers/                   ← provider 定义
└── completions/                 ← Tab 补全
~/.local/share/ccse/             ← 运行时数据
├── state                        ← 默认 provider
├── last                         ← 上次使用的 provider
└── vars/                        ← provider 变量缓存
```

## 自定义 Provider

在 `~/.config/ccse/providers/` 下新增 `.zsh` 文件：

```zsh
# @alias: my
# 我的 Provider
# Required secrets: CCE_MY_TOKEN

export ANTHROPIC_BASE_URL="https://api.example.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="${CCE_MY_TOKEN:?}"
```

同步更新 `~/.config/ccse/secrets` 添加对应 key。`ccse ls` 自动发现。

### `@noreset`

标记切换 provider 时不清理的变量：

```zsh
# @noreset: ANTHROPIC_CUSTOM_HEADERS
export ANTHROPIC_CUSTOM_HEADERS="x-org-id: my-org"
```

## 卸载

```bash
./uninstall.sh
```

然后手动从 `.zshrc` / `.bashrc` 中删除 integration 行。

## License

MIT
