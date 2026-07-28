# Dotfiles Configuration Manual

A collection of personal dotfiles managed by **saoge2222**, covering terminal workflow tools with a focus on keyboard-driven efficiency and a consistent Gruvbox dark aesthetic.

---

## Table of Contents

1. [Overview](#overview)
2. [Tmux Configuration](#tmux-configuration)
   - [Plugins](#tmux-plugins)
   - [Keybindings](#tmux-keybindings)
   - [General Settings](#tmux-general-settings)
   - [Status Bar & Theme](#tmux-status-bar--theme)
3. [Neovim Configuration](#neovim-configuration)
   - [Editor Options](#neovim-editor-options)
   - [Plugin Manager](#neovim-plugin-manager)
   - [Plugins](#neovim-plugins)
   - [Keybindings](#neovim-keybindings)
   - [Status Bar](#neovim-status-bar)
4. [External Dependencies](#external-dependencies)
5. [Installation Guide](#installation-guide)
6. [Future Additions](#future-additions)

---

## Overview

### Scope

| Component | Config File | Status |
|-----------|------------|--------|
| Tmux | `tmux/tmux.conf` | Active |
| Neovim | `nvim/init.lua` | Active |
| Vim | `vim/.vimrc` | To Be Added |
| Zsh | `zsh/` | To Be Added |

### Design Philosophy

- **Keyboard-first**: prefix keys remapped for reachability, all common operations behind a single leader key
- **Dark, warm theme**: Gruvbox color scheme across Tmux and Neovim; TokyoNight and Catppuccin available as alternatives
- **Modern tooling**: Tree-sitter for syntax, Telescope for fuzzy search, lazy.nvim for lazy-loaded plugins
- **Mouse-friendly but not required**: mouse support enabled, but every action has a keyboard shortcut
- **Single-file configs**: one `init.lua` for Neovim, one `tmux.conf` for Tmux — no nested modular splits

---

## Tmux Configuration

**File**: `tmux/tmux.conf` (57 lines)

### Tmux Plugins

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager).
Install with `prefix + I` after bootstrapping TPM.

| Plugin | Function | Direct Dependencies | Install Method |
|--------|----------|---------------------|----------------|
| `tmux-plugins/tpm` | Plugin manager bootstrap | — | Manual `git clone` (see [Installation](#installation-guide)) |
| `tmux-plugins/tmux-sensible` | Sane default settings (escape-time, focus-events, etc.) | `tpm` | TPM (`prefix + I`) |
| `hendrikmi/tmux-cpu-mem-monitor` | CPU and memory usage display in status bar | `/proc/stat`, `/proc/meminfo` (Linux-only) | TPM |
| `sainnhe/tmux-fzf` | Fzf-powered fuzzy search for sessions, windows, and panes | `fzf` (system binary, see [External Dependencies](#external-dependencies)) | TPM |

### Tmux Keybindings

| Shortcut | Action | Notes |
|----------|--------|-------|
| `C-a` | Prefix key | Replaces default `C-b` |
| `C-a C-a` | Send prefix to application | Useful inside nested Tmux sessions |
| `C-a r` | Reload config | Sources `~/.config/tmux/tmux.conf` |
| `C-a s` | Split pane vertically (top/bottom) | Inherits current working directory |
| `C-a v` | Split pane horizontally (left/right) | Inherits current working directory |
| `C-a c` | Create new window | Inherits current working directory |

### Tmux General Settings

| Setting | Value | Effect |
|---------|-------|--------|
| `base-index` | `1` | Window numbering starts at 1 |
| `pane-base-index` | `1` | Pane numbering starts at 1 |
| `mouse` | `on` | Click to select panes/windows, drag to resize |
| `mode-keys` | `vi` | Copy mode uses vi-style keybindings (`/`, `?`, `v`, `y`) |
| `renumber-windows` | `on` | Auto-renumber windows when one is closed |
| `set-clipboard` | `on` | Copy selection to system clipboard |
| `detach-on-destroy` | `off` | Switch to another session when the current one is destroyed |
| `default-terminal` | `tmux-256color` | Declare 256-color terminal capability |
| `terminal-overrides` | `,*256col*:Tc` | Force True Color (24-bit) support |

### Tmux Status Bar & Theme

#### Color Palette (Gruvbox Dark)

| Variable | Hex | Role |
|----------|-----|------|
| `grey_light` | `#504945` | Borders, messages, active pane border |
| `grey_dark` | `#282828` | Status bar background, inactive pane border |
| `session_color` | `#83A598` | Session name label (blue-cyan accent) |
| `window_color` | `#1F1F1F` | Active window tab background |
| `font_color` | `#DBCCA7` | Foreground text (warm beige) |

#### Status Bar Layout

```
┌──────────────────────────────────────────────────────────────┐
│ ◈ 1:bash  2:nvim  3:htop       │   dev |  12%  3.2G  │
└──────────────────────────────────────────────────────────────┘
  Left side (empty)   Window list      Right side (session, CPU, memory)
```

**Components**:
- **Left side** (`status-left`): intentionally empty — keeps visual weight on the right
- **Window list** (`window-status-format` / `window-status-current-format`):
  - Active window: `◈ #I:#W` in bold on a contrasting background
  - Inactive windows: `#I:#W` in unbold text
- **Right side** (`status-right`):
  - ` #S`: session name with Nerd Font icon
  - ` #{cpu -i 1}`: CPU usage (1-second interval sample)
  - ` #{mem}`: memory usage

**Refresh interval**: 1 second (`status-interval 1`)

---

## Neovim Configuration

**File**: `nvim/init.lua` (127 lines)

### Neovim Editor Options

| Option | Value | Effect |
|--------|-------|--------|
| `number` | `true` | Show absolute line numbers |
| `relativenumber` | `true` | Show relative line numbers (ease `j`/`k` vertical jumps) |
| `tabstop` | `4` | Visual width of a tab character |
| `shiftwidth` | `4` | Indentation width for `>>`, `<<`, `==` |
| `expandtab` | `true` | Insert spaces when Tab is pressed |
| `autoindent` | `true` | Copy indentation from the previous line |
| `wrap` | `false` | Do not soft-wrap long lines |
| `scrolloff` | `20` | Keep 20 lines of context above/below the cursor |
| `sidescrolloff` | `20` | Keep 20 columns of context left/right of the cursor |
| `cursorline` | `true` | Highlight the current line |
| `splitright` | `true` | Vertical splits open on the right |
| `splitbelow` | `true` | Horizontal splits open below |
| `ignorecase` | `true` | Case-insensitive search |
| `smartcase` | `true` | Case-sensitive if search contains uppercase |
| `termguicolors` | `true` | Enable 24-bit True Color in the terminal |
| `signcolumn` | `"yes"` | Always reserve the sign column (prevents layout shift from LSP diagnostics) |
| `showmode` | `false` | Hide default mode indicator (rendered by lualine instead) |

**Leader key**: `Space` (`vim.g.mapleader = " "`)

### Neovim Plugin Manager

[lazy.nvim](https://github.com/folke/lazy.nvim) by Folke Lemaitre.
Auto-bootstrapped on first launch — no manual installation required.
The config specifies a `spec` table containing all plugins and their options.

### Neovim Plugins

#### 1. nvim-autopairs

- **Source**: [`windwp/nvim-autopairs`](https://github.com/windwp/nvim-autopairs)
- **Function**: Automatically inserts matching brackets, parentheses, and quotes
- **Direct Dependencies**: —
- **Install Method**: lazy.nvim (auto-downloaded on first startup)

#### 2. gruvbox.nvim (active theme)

- **Source**: [`ellisonleao/gruvbox.nvim`](https://github.com/ellisonleao/gruvbox.nvim)
- **Function**: Gruvbox dark colorscheme, set as the default via `config` callback
- **Direct Dependencies**: —
- **Install Method**: lazy.nvim

#### 3. tokyonight.nvim (alternative theme)

- **Source**: [`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim)
- **Function**: TokyoNight colorscheme in `moon` variant
- **Direct Dependencies**: —
- **Install Method**: lazy.nvim
- **Activation**: `:colorscheme tokyonight`

#### 4. catppuccin/nvim (alternative theme)

- **Source**: [`catppuccin/nvim`](https://github.com/catppuccin/nvim)
- **Function**: Catppuccin pastel colorscheme
- **Direct Dependencies**: —
- **Install Method**: lazy.nvim
- **Activation**: `:colorscheme catppuccin`

#### 5. oil.nvim (file explorer)

- **Source**: [`stevearc/oil.nvim`](https://github.com/stevearc/oil.nvim)
- **Function**: Directory-as-buffer file manager; edit filesystem entries like text
- **Direct Dependencies**: `nvim-tree/nvim-web-devicons` (Nerd Font icon glyphs)
- **Install Method**: lazy.nvim (pulls both oil.nvim and its dependency)
- **Key Settings**:
  - `columns`: `"permissions"`, `"size"`, `"icon"` — visible metadata columns
  - `view_options.show_hidden`: `true` — show dotfiles

#### 6. nvim-treesitter (syntax engine)

- **Source**: [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
- **Function**: Incremental syntax parsing for precise highlighting, folding, and text objects
- **System Dependencies**: `gcc` or `clang` + `make` (to compile `tree-sitter` CLI bindings)
- **Direct Plugin Dependencies**: —
- **Install Method**: lazy.nvim (triggers `:TSUpdate` post-install via `build` hook)
- **Pre-installed parser**: `lua`

#### 7. bufferline.nvim (tab bar)

- **Source**: [`akinsho/bufferline.nvim`](https://github.com/akinsho/bufferline.nvim)
- **Function**: Top-of-window buffer tabs styled like a modern editor
- **Direct Dependencies**: `nvim-tree/nvim-web-devicons`
- **Install Method**: lazy.nvim

#### 8. telescope.nvim (fuzzy finder)

- **Source**: [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)
- **Function**: Fuzzy search over files, buffers, live grep, help tags, and more
- **Direct Dependencies**:
  - `nvim-lua/plenary.nvim` — Lua utility library (pulled automatically by lazy.nvim)
  - `nvim-telescope/telescope-fzf-native.nvim` — native fzf C backend for performance (requires `make` + `gcc` to compile)
- **Install Method**: lazy.nvim

#### 9. noice.nvim (UI overhaul)

- **Source**: [`folke/noice.nvim`](https://github.com/folke/noice.nvim)
- **Function**: Replaces the default cmdline, messages, and popupmenu with floating windows; integrates command history and statusline notifications
- **Direct Dependencies**:
  - `MunifTanjim/nui.nvim` — UI component framework (splits, popups, inputs)
  - `rcarriga/nvim-notify` — notification backend for Lua messages
- **Install Method**: lazy.nvim

#### 10. lualine.nvim (status line)

- **Source**: [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)
- **Function**: Customizable status line replacing the default `-- INSERT --` display
- **Direct Dependencies**: `nvim-tree/nvim-web-devicons`
- **Install Method**: lazy.nvim

### Neovim Keybindings

All shortcuts use `<leader>` = `Space`.

| Shortcut | Plugin | Action |
|----------|--------|--------|
| `<leader>bh` | bufferline.nvim | Previous buffer |
| `<leader>bl` | bufferline.nvim | Next buffer |
| `<leader>bd` | bufferline.nvim | Delete current buffer |
| `<leader>tf` | telescope.nvim | Find files (fuzzy) |
| `<leader>tg` | telescope.nvim | Live grep (search in project) |
| `<leader>tb` | telescope.nvim | Browse open buffers |
| `<leader>th` | telescope.nvim | Search help tags |

### Neovim Status Bar

Lualine layout with custom section formatting:

```
┌─────────────────────────────────────────────────┐
│  NOR  │  init.lua  [32KB]  utf-8  │  12:88  85%  │
└─────────────────────────────────────────────────┘
  lualine_a    lualine_b              lualine_x
```

| Section | Content | Description |
|---------|---------|-------------|
| `lualine_a` | Mode (abbreviated) | `NORMAL` → `NOR`, `INSERT` → `INS`, `VISUAL` → `VIS` (truncated to 3 chars) |
| `lualine_b` | Filename, filesize, encoding | Current file context |
| `lualine_c` | — | Intentionally empty |
| `lualine_x` | Location, progress | Cursor position (`line:col`) and scroll percentage |
| `lualine_y` | — | Intentionally empty |
| `lualine_z` | — | Intentionally empty |

---

## External Dependencies

### System-Level (must be installed before deploying)

| Package | Required By | Purpose |
|---------|-------------|---------|
| **Git** | tpm, lazy.nvim | Plugin repository cloning |
| **Neovim ≥ 0.9** | `nvim/init.lua` | Lua configuration, `vim.loop`, telescope, treesitter, noice |
| **Tmux ≥ 3.0** | `tmux/tmux.conf` | TPM, true color support, `terminal-overrides` |
| **fzf** | `sainnhe/tmux-fzf`, `telescope-fzf-native.nvim` | Fuzzy search binary |
| **gcc / clang** | `nvim-treesitter`, `telescope-fzf-native.nvim` | Compile native parser/accelerator binaries |
| **GNU Make** | `nvim-treesitter`, `telescope-fzf-native.nvim` | Build automation |
| **Nerd Font** | `nvim-web-devicons`, tmux status bar | Icon glyphs (``, ``, ``, ``, bufferline/telescope icons) |
| **unzip** | lazy.nvim | Extracting lazy plugin archives |
| **curl / wget** | lazy.nvim | Downloading plugin archives |

### OS-Specific Install Commands

#### Debian / Ubuntu

```bash
sudo apt update
sudo apt install git neovim tmux fzf build-essential unzip curl
# Install a Nerd Font manually from https://www.nerdfonts.com
```

#### macOS (Homebrew)

```bash
brew install git neovim tmux fzf gcc make unzip curl
brew install --cask font-hack-nerd-font
```

#### Arch Linux

```bash
sudo pacman -S git neovim tmux fzf base-devel unzip curl
# Install a Nerd Font from AUR or manually
```

---

## Installation Guide

### Step 1: Clone the Repository

```bash
git clone https://github.com/saoge2222/dotfiles.git ~/dotfiles
```

### Step 2: Install System Dependencies

Run the appropriate command from the [External Dependencies](#external-dependencies) section above for your OS.

### Step 3: Create Symlinks

```bash
# Create config directories if they don't exist
mkdir -p ~/.config/tmux ~/.config/nvim

# Symlink dotfiles
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
```

> **Note**: The `vim/.vimrc` and `zsh/` configurations are not yet available. Symlinks for those will be documented here once they are added.

### Step 4: Bootstrap TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then launch Tmux and press `C-a I` (prefix + Shift+I) to install all plugins listed in `tmux.conf`. TPM will clone each plugin into `~/.tmux/plugins/`.

### Step 5: Bootstrap Neovim Plugins

Simply launch Neovim:

```bash
nvim
```

On first startup, `init.lua` will automatically:
1. Clone `lazy.nvim` into `~/.local/share/nvim/lazy/lazy.nvim`
2. Download and install all 10 plugins
3. Compile `nvim-treesitter` parsers and `telescope-fzf-native.nvim`

Wait for the lazy.nvim dashboard to finish. Subsequent launches will be instant thanks to lazy loading.

### Step 6: Verify

- **Tmux**: Status bar shows session name and CPU/memory on the right.
- **Neovim**: Gruvbox theme active, lualine at the bottom, bufferline tabs at the top.

---

## Future Additions

### Zsh Configuration (`zsh/`)

**Status**: To Be Added

Planned contents:
- `.zshrc` with prompt theme, aliases, and keybindings
- Plugin management via a Zsh plugin manager (TBD)
- Consistent Gruvbox terminal color palette

### Vim Configuration (`vim/.vimrc`)

**Status**: To Be Added

Planned contents:
- Minimal Vim backend configuration for environments without Neovim
- Core settings mirroring `nvim/init.lua` editor options
