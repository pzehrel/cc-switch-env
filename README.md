# cc-switch-env

Claude Code 运行环境切换工具。通过 shell 脚本实现 provider 的会话级和持久化切换。

## 安装

```bash
git clone git@github.com:pzehrel/cc-switch-env.git
cd cc-switch-env
./install.sh
```

## 配置

### 1. Shell 集成

**zsh** — 在 `~/.zshrc` 中添加：

```zsh
eval "$(ccenv init)"
source ~/.config/ccenv/completions/_ccse
```

**bash** — 在 `~/.bashrc` 中添加：

```bash
eval "$(ccenv init)"
source ~/.config/ccenv/completions/ccse.bash
```

### 2. 填写 API Key

```bash
vim ~/.config/ccenv/secrets
```

按模板填入各 provider 的 API key。

## 使用

| 命令 | 效果 |
|------|------|
| `ccse ls` | 列出所有可用 provider |
| `ccse current` | 查看当前 provider、默认值、上次使用 |
| `ccse kimi` | 临时切换到 kimi（记录为 last） |
| `ccse default kimi` | 切换 + 设为默认 |
| `ccse default -d` | 清除默认 |

开终端后无需手动操作，自动恢复上次使用的环境，直接 `cc`（`claude`）即可。

## 目录结构

```
~/.local/bin/ccenv              ← CLI 本体
~/.config/ccenv/                 ← 用户配置
├── secrets                      ← API keys（不提交）
├── providers/                   ← provider 定义
└── completions/                 ← Tab 补全
~/.local/share/ccenv/            ← 运行时数据
├── state                        ← 默认 provider
├── last                         ← 上次使用的 provider
└── vars/                        ← provider 变量缓存
```

## 自定义 Provider

在 `~/.config/ccenv/providers/` 下新增 `.zsh` 文件即可：

```zsh
# ~/.config/ccenv/providers/my-provider.zsh
export ANTHROPIC_BASE_URL="https://api.example.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="${CCE_MYPROVIDER_TOKEN:?}"
```

同时更新 `~/.config/ccenv/secrets` 添加对应的 key。

### @noreset

如果某个变量希望切换 provider 时不被清除，用注释标记：

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
