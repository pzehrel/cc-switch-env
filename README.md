# cc-switch-env

[中文](README.zh-CN.md)

Claude Code environment switcher. Switch providers, models, and parameters with a single command.

## Install

```bash
git clone git@github.com:pzehrel/cc-switch-env.git
cd cc-switch-env
./install.sh
```

## Setup

### 1. Shell integration

**zsh** — add to `~/.zshrc`:

```zsh
eval "$(ccse init)"
source ~/.config/ccse/completions/_ccse
```

**bash** — add to `~/.bashrc`:

```bash
eval "$(ccse init)"
source ~/.config/ccse/completions/ccse.bash
```

### 2. Fill in API keys

```bash
vim ~/.config/ccse/secrets
```

## Usage

| Command | Effect |
|---------|--------|
| `ccse ls` | List all providers |
| `ccse current` | Show current provider, default, last used |
| `ccse kimi` | Switch to kimi (session only, recorded as last) |
| `ccse ds` | Switch using alias (ds → deepseek) |
| `ccse default kimi` | Switch + set as default |
| `ccse default -d` | Clear default |

Open a terminal and start typing `cc` directly — no manual steps needed.

## Directory structure

```
~/.local/bin/ccse               ← CLI binary
~/.config/ccse/                  ← User config
├── secrets                      ← API keys (do not commit)
├── providers/                   ← Provider definitions
└── completions/                 ← Tab completions
~/.local/share/ccse/             ← Runtime data
├── state                        ← Default provider
├── last                         ← Last used provider
└── vars/                        ← Provider variable cache
```

## Custom providers

Add a `.zsh` file to `~/.config/ccse/providers/`:

```zsh
# @alias: my
# My Provider
# Required secrets: CCE_MY_TOKEN

export ANTHROPIC_BASE_URL="https://api.example.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="${CCE_MY_TOKEN:?}"
```

Update `~/.config/ccse/secrets` with the corresponding key. `ccse ls` picks it up automatically.

### `@noreset`

Mark variables that should persist across provider switches:

```zsh
# @noreset: ANTHROPIC_CUSTOM_HEADERS
export ANTHROPIC_CUSTOM_HEADERS="x-org-id: my-org"
```

## Uninstall

```bash
./uninstall.sh
```

Then manually remove the integration lines from `.zshrc` / `.bashrc`.

## License

MIT
