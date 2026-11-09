# Akshay's Dotfiles

Modern, high-productivity terminal and CLI environment for Linux & macOS.

Includes configured themes and setups for:
* **Foot Terminal**: Soft dark charcoal background (`#16151a`), 94% opacity (`alpha=0.94`), high-contrast slate selection (`#363d4a` / `#ffffff`), URL hints, and regex scrollback search.
* **Starship Prompt**: 2-line developer prompt featuring real-time Git branch, dirty/staged/untracked badges, diff metrics (`+10 -2`), execution timing, and clean prompt character (`❯`).
* **`ble.sh` (Bash Line Editor)**: Fish-like autosuggestions, syntax highlighting, immediate <kbd>Enter</kbd> execution, and multiline suppression.
* **Neovim Enhancements**: Transparent canvas with high-contrast text selection and readable LSP hover/word reference highlights.
* **Git Configuration**: Modern histogram diff algorithm, moved-block color highlights, automatic upstream push setup, pull rebase, rerere conflict reuse, and portable GitHub CLI credential integration.
* **Window Manager & Ergonomics (Hyprland)**: Caps Lock remapped to Control (`ctrl:nocaps`) and natural touchpad scrolling.
* **Tmux Multiplexer**: Custom prefix (`C-Space` / `C-b`), vi copy mode, intuitive window splits, fast window switching, and high-contrast status bar.
* **CLI Productivity**:
  * **Yazi**: Terminal file manager with auto-cd on exit (`y`).
  * **Glow**: Terminal markdown viewer and interactive pager (`md <file>` or `cheatsheet`).
  * **FZF**: Supercharged with live `bat` syntax highlighting (<kbd>Ctrl</kbd>+<kbd>T</kbd>) and `eza` directory trees (<kbd>Alt</kbd>+<kbd>C</kbd>).
  * **Zoxide**: Smart `cd` / `zd` navigation with trailing-slash auto-resolution.
  * **Git Shortcuts**: Full suite of git aliases (`g`, `ga`, `gc`, `gd`, `gp`, `gl`, `gst`, `gco`, etc.).

---

## Quick Start (Fresh OS Installation)

When you wipe your machine or install a new OS, open a terminal and run this single command:

```bash
git clone https://github.com/akshay-011/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

The installer will:
1. Detect your package manager (`pacman`, `apt`, `dnf`, `brew`) and install missing tools.
2. Auto-download standalone CLI binaries (`starship`, `yazi`, `glow`, `ble.sh`).
3. Back up any existing config files and create symlinks pointing into `~/dotfiles`.
4. Integrate `~/.bash_custom` into your `~/.bashrc`.

After running, restart your terminal or run:
```bash
source ~/.bashrc
```

---

## Repository Structure

```text
dotfiles/
├── .config/
│   ├── foot/
│   │   └── foot.ini                 # Foot terminal configuration
│   ├── git/
│   │   └── config                   # Global Git preferences & credential helpers
│   ├── hypr/
│   │   └── input.lua                # Hyprland keyboard & touchpad ergonomics
│   ├── nvim/
│   │   └── plugin/
│   │       └── after/
│   │           └── transparency.lua # Neovim transparency & highlight styles
│   ├── starship.toml                # Starship prompt configuration
│   ├── terminal-cheatsheet.md       # Quick reference cheatsheet
│   └── tmux/
│       └── tmux.conf                # Tmux multiplexer bindings & style
├── .blerc                           # ble.sh keybindings & settings
├── .bash_custom                     # Modular custom aliases, functions & tools
├── install.sh                       # Idempotent automated setup script
└── README.md
```

---

## Daily Usage & Syncing Changes

Because configuration files are symlinked to `~/dotfiles`, any changes you make in `~/.config/foot/foot.ini`, `~/.blerc`, or `~/.bash_custom` are automatically tracked in git.

To push changes to GitHub:

```bash
cd ~/dotfiles
git status
git add .
git commit -m "Update terminal settings"
git push
```

To pull the latest changes on another machine:

```bash
cd ~/dotfiles
git pull
```
