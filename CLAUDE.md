# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on top of NvChad v2.5, a Neovim configuration framework. The setup is designed for multi-language development with a focus on Python, C++, C#, JavaScript/TypeScript, HTML/CSS, Rust, and Markdown.

## Architecture

### Core Structure
- `init.lua`: Main entry point that bootstraps lazy.nvim package manager and loads all configurations
- `lua/chadrc.lua`: NvChad-specific configuration (theme: aquarium)
- `lua/configs/`: Contains configuration files for various tools (LSP, formatters, lazy.nvim)
- `lua/plugins/init.lua`: Plugin definitions and configurations
- `lua/mappings.lua`: Custom keybindings (inherits from NvChad defaults)
- `lua/options.lua`: Vim options (inherits from NvChad defaults)

### Plugin Management
Uses lazy.nvim as the package manager. NvChad itself is loaded as a plugin with the base configuration, and custom plugins are added through the `plugins` directory.

### Language Support Configuration

#### LSP Servers (via Mason)
- **Python**: pyright (enhanced configuration with workspace diagnostics)
- **C/C++**: clangd
- **C#**: omnisharp
- **Rust**: rust-analyzer
- **HTML/CSS**: html-lsp, css-lsp
- **Markdown**: marksman
- **Lua**: lua-language-server

#### Formatters
- **Python**: black, isort
- **C/C++**: clang-format
- **Lua**: stylua
- **Web**: prettier (available but not configured)

#### Linters/Tools
- **Python**: flake8, mypy, pylint, autopep8
- **C++**: cppcheck

### Key Integrations
- **Tmux**: vim-tmux-navigator for seamless pane navigation
- **GitHub Copilot**: github/copilot.vim
- **Markdown Preview**: iamcco/markdown-preview.nvim

## Development Workflows

### Plugin Management
- Plugins are managed via lazy.nvim
- New plugins should be added to `lua/plugins/init.lua`
- Mason automatically installs configured LSP servers and tools

### Language-Specific Setup
- LSP configurations are in `lua/configs/lspconfig.lua`
- Formatter configurations are in `lua/configs/conform.lua`
- Treesitter parsers are auto-installed for configured languages

### Customization
- Custom keybindings: Add to `lua/mappings.lua`
- Custom options: Add to `lua/options.lua`
- Theme/UI changes: Modify `lua/chadrc.lua`

## Important Files
- `lazy-lock.json`: Locks plugin versions for reproducible installs
- `LICENSE`: Project license file
- `README.md`: Basic setup instructions and credits

## Branch Information
- Current working branch: `clang`
- This suggests active development on C/C++ language server features