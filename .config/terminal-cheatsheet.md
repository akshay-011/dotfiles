# Modern Foot Terminal & Git Environment Guide

Your **Foot terminal**, **Starship prompt**, and **Bash CLI workflow** on Omarchy have been customized according to your selections.

---

## 1. Starship Prompt & Git Integration

Configured in [`~/.config/starship.toml`](file:///home/akshay/.config/starship.toml):

* **Two-Line Developer Layout**:
  * **Line 1 (Context)**: Directory (`repo/path`) → Git Branch (` main`) → Git Status Badges → Line Diff Metrics (`+10 -2`) → **Project Language/Compiler** (`📦 v26.13.0`, `☕ v21.0.4`, etc.) → Execution Duration (`took 2.5s `) → Exit Status (`✘`).
  * **Line 2 (Action)**: Clean prompt input character (`❯`).
* **Project Language & Compiler Detection (2x Emoji Logos)**:
  * `📦 <version>`: Node.js (`package.json`, `.node-version`)
  * `🦀 <version>`: Rust (`Cargo.toml`)
  * `🐹 <version>`: Go (`go.mod`, `*.go`)
  * `🐍 <version>`: Python (`pyproject.toml`, `requirements.txt`, venv)
  * `☕ <version>`: Java (`pom.xml`, `build.gradle`)
  * `⚙️ <version>`: C/C++ (`CMakeLists.txt`, `compile_flags.txt`)
  * `🥟 <version>` / `🦕 <version>`: Bun / Deno
  * `🌙 <version>`: Lua
  * `🐳 <context>`: Docker context
* **Git Status Indicators**:
  * ` <branch>`: Active branch with Nerd Font Octicon glyph.
  * `+<count>`: Files staged for commit (`git add`).
  * `!<count>`: Modified/dirty unstaged files.
  * `?<count>`: Untracked new files.
  * `⇡<count>` / `⇣<count>`: Commits ahead/behind upstream remote.
  * `⇕⇡ahead⇣behind`: Diverged branches.
  * ` <count>`: Merge / rebase conflicts.
  * `󰆓`: Stashed changes present.
  * ``: Clean & synced with remote.
  * `(rebase 2/5)`: Active rebase, merge, or bisect state.

---

## 2. Foot Terminal Enhancements

Configured in [`~/.config/foot/foot.ini`](file:///home/akshay/.config/foot/foot.ini):

* **Appearance & Typography**:
  * **Transparency**: `alpha=0.94` subtle translucency that blends with the wallpaper while preserving 100% opaque, razor-sharp text.
  * **Background Tone**: Softened from pitch black (`#060606`) to a gentle dark charcoal tone (`#16151a`) for easier readability.
  * **Selection Highlight**: Neutral slate background (`#363d4a`) with crisp white text (`#ffffff`) for high contrast readability (10.9:1 WCAG AAA).
  * **Font**: JetBrains Mono Nerd Font (`size=9.5`) with full Unicode and glyph coverage.
  * **Box Drawings**: `box-drawings-uses-font-glyphs=no` for pixel-perfect TUI borders without gaps in `lazygit`, `btop`, and `yazi`.
  * **Cursor**: Blinking block cursor (`blink-rate=500ms`).
* **Interactive Keyboard Shortcuts**:

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd> | **URL Launcher** | Displays letter hints over all links on screen; press letter to open in browser |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Y</kbd> | **URL Copy** | Copy selected URL hint to clipboard without opening |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> / <kbd>R</kbd> | **Search Scrollback** | Regex-powered interactive search with match jumping |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> | **New Window** | Spawns a new foot terminal instance |
| <kbd>Ctrl</kbd> + <kbd>+</kbd> / <kbd>-</kbd> / <kbd>0</kbd> | **Font Zoom** | Increase, decrease, or reset terminal font size |
| <kbd>Shift</kbd> + <kbd>PageUp</kbd> / <kbd>PageDown</kbd> | **Scroll** | Fast page scrolling in history buffer |

* **Desktop Bell Notifications**:
  * Foot notifies via `notify-send` when background tasks complete or emit a bell character (`\a`).

---

## 3. Shell UX & CLI Upgrades

Configured in [`~/.bashrc`](file:///home/akshay/.bashrc):

### A. `ble.sh` (Bash Line Editor)
* **Real-Time Syntax Highlighting**: Commands, arguments, quotes, and valid paths are highlighted in color as you type.
* **Fish-Like Autosuggestions**: Grayed-out completions from your history appear ahead of the cursor. Press <kbd>Enter</kbd> to accept and run immediately, or press <kbd>→</kbd> / <kbd>End</kbd> to insert without running. Press <kbd>↓</kbd> or <kbd>Ctrl</kbd>+<kbd>G</kbd> to dismiss suggestions.
* **Direct Execution (No Multiline)**: Multiline mode and the `-- MULTILINE --` prompt banner are disabled; <kbd>Enter</kbd> always executes commands directly.
* **Enhanced Menu Completion**: Enhanced tab completions with interactive navigation.

### B. `yazi` Terminal File Manager
* Installed at [`~/.local/bin/yazi`](file:///home/akshay/.local/bin/yazi).
* **Launch**: Run `y` in any terminal to open Yazi.
* **cd-on-exit**: When you exit Yazi with <kbd>q</kbd>, your shell automatically changes directories to the folder you navigated to in Yazi!

### C. Supercharged `fzf` Search
* <kbd>Ctrl</kbd> + <kbd>T</kbd>: Fuzzy search files with live syntax-highlighted `bat` previews.
* <kbd>Alt</kbd> + <kbd>C</kbd>: Fuzzy search directories with live `eza` tree previews.
* Colored manual pages via `bat` (`man <command>` displays with syntax highlighting).

### D. `glow` Markdown Previewer
* Installed at [`~/.local/bin/glow`](file:///home/akshay/.local/bin/glow).
* `md <file.md>`: View any Markdown document in an interactive, scrollable full-screen pager.
* `glow`: Launch the interactive Markdown dashboard to browse and search all Markdown files in the current directory or git repo.
* `cheatsheet`: Open this cheatsheet rendered beautifully via Glow.

### E. Smart Directory Navigation (`cd` → `zd`)
* `cd <dir>`: Works like regular `cd`, but if `<dir>` is not in your current folder, it automatically queries Zoxide to jump straight there.
* `cd <space><tab>`: Launches interactive fuzzy search across your most visited directories.

### F. Neovim Theme Integration
* Linked to Omarchy's live theme state via [`~/.config/nvim/lua/plugins/theme.lua`](file:///home/akshay/.config/nvim/lua/plugins/theme.lua).
* Uses `aether.nvim` matching your active Foot terminal palette (soft `#16151a` background, `#f0d4e4` foreground, transparent editor canvas).
* Word & Visual selection + LSP cursor reference highlights styled in neutral slate (`#2e3340` / `#363d4a`) with crisp white text (`#ffffff`) and subtle underline, eliminating white-on-white solid blocks.
* Automatically updates whenever you change your system theme with `omarchy theme set <theme>`.

---

## 4. Backup & Rollback Safety

All configuration files were backed up prior to modification:
* `~/.config/foot/foot.ini.bak.1793793774`
* `~/.config/starship.toml.bak.1793793774`
* `~/.bashrc.bak.1793793774`
