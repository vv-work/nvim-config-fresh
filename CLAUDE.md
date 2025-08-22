# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on top of NvChad v2.5, a Neovim configuration framework. The setup is designed for multi-language development with a focus on Python, C++, C#, JavaScript/TypeScript, HTML/CSS, Rust, Markdown, and shader languages (GLSL).

## Architecture

### Core Structure
- `init.lua`: Main entry point that bootstraps lazy.nvim package manager and loads all configurations
- `lua/chadrc.lua`: NvChad-specific configuration (theme: catppuccin)
- `lua/configs/lsp.lua`: Detailed LSP server configurations
- `lua/configs/keymaps.lua`: Keymap definitions for plugins
- `lua/configs/markdown-highlight.lua`: Markdown syntax highlighting setup
- `lua/configs/treesitter.lua`: Treesitter parser configurations
- `lua/configs/filetype.lua`: Custom filetype definitions
- `lua/configs/`: Contains configuration files for various tools (LSP, formatters, lazy.nvim)
- `lua/plugins/init.lua`: Plugin definitions and configurations
- `lua/mappings.lua`: Custom keybindings (inherits from NvChad defaults)
- `lua/options.lua`: Vim options (inherits from NvChad defaults)

### Plugin Management
Uses lazy.nvim as the package manager. NvChad itself is loaded as a plugin with the base configuration, and custom plugins are added through the `plugins` directory.

### Language Support Configuration

#### LSP Servers (via Mason)
- **Python**: pyright (enhanced configuration with workspace diagnostics)
- **C/C++**: clangd (enhanced with background indexing, clang-tidy, header insertion)
- **C#**: omnisharp (with Roslyn analyzers and modern .NET support)
- **TypeScript/JavaScript**: vtsls (enhanced TypeScript language server with inlay hints)
- **Rust**: rust-analyzer
- **HTML/CSS**: html-lsp, css-lsp, emmet-ls
- **JSON**: jsonls (with schema validation)
- **Markdown**: marksman
- **GLSL**: glsl_analyzer (for shader development)
- **CMake**: cmake-language-server
- **Lua**: lua-language-server

#### Formatters
- **Python**: black, isort
- **C/C++/CUDA/GLSL**: clang-format
- **Lua**: stylua
- **JavaScript/TypeScript**: biome (preferred), prettier (fallback)
- **Web/Markup**: prettier (HTML, CSS, SCSS, YAML, Vue, Svelte)
- **CMake**: cmake-format

#### Linters/Tools
- **Python**: flake8, mypy, pylint, autopep8
- **C++**: cppcheck, clang-tidy, cpplint
- **JavaScript/TypeScript**: eslint_d, biome
- **Debugging**: codelldb (C++/Rust), gdb, js-debug-adapter
- **Build Tools**: bear (for compile_commands.json generation)

### Key Integrations
- **Tmux**: vim-tmux-navigator for seamless pane navigation
- **GitHub Copilot**: github/copilot.vim
- **Markdown Preview**: iamcco/markdown-preview.nvim
- **TypeScript Tools**: pmizio/typescript-tools.nvim with enhanced inlay hints
- **C++ Development**: cmake-tools.nvim for CMake integration
- **Debugging**: nvim-dap with DAP UI and virtual text support
- **Auto-tagging**: nvim-ts-autotag for HTML/JSX tag completion
- **Global Search/Replace**: nvim-spectre
- **Shader Support**: vim-glsl for GLSL syntax highlighting
- **Completion**: Integrated with blink.cmp for enhanced autocompletion

## Development Workflows

### Plugin Management
- Plugins are managed via lazy.nvim
- New plugins should be added to `lua/plugins/init.lua`
- Mason automatically installs configured LSP servers and tools

### Language-Specific Setup
- LSP configurations are in `lua/configs/lspconfig.lua` (imports from `lua/configs/lsp.lua`)
- Individual LSP server settings are defined in `lua/configs/lsp.lua`
- Formatter configurations are in `lua/configs/formatters.lua` (used by conform.nvim)
- Mason tool installation is configured in `lua/configs/mason.lua`
- Treesitter parsers are auto-installed for configured languages
- Debugging configurations are set up in the DAP plugin section of `lua/plugins/init.lua`

### Customization
- Custom keybindings: Add to `lua/mappings.lua`
- Custom options: Add to `lua/options.lua`
- Theme/UI changes: Modify `lua/chadrc.lua`

## Development Commands

### Neovim Configuration Management
- **Install/Update Tools**: Open Neovim, tools are auto-installed via Mason
- **Plugin Management**: `:Lazy` (install/update/remove plugins)
- **Mason UI**: `:Mason` (manage LSP servers, formatters, linters)
- **Health Check**: `:checkhealth` (verify configuration)

### Language-Specific Commands
- **C++ CMake**: `<leader>cc` (CMake configure), `<leader>cb` (build), `<leader>cr` (run)
- **Debugging**: `<F5>` (start/continue), `<F10>` (step over), `<F11>` (step into)
- **Markdown Preview**: `:MarkdownPreview` (start preview in browser)
- **Global Search/Replace**: `<leader>S` (open Spectre for project-wide find/replace)
- **Format Code**: `<leader>fm` (format current buffer with conform.nvim)

### Key File Locations
- **Plugin Specs**: `lua/plugins/init.lua` (add new plugins here)
- **LSP Settings**: `lua/configs/lsp.lua` (server-specific configurations)
- **Keymaps**: `lua/mappings.lua` and `lua/configs/keymaps.lua`
- **Tool Installation**: `lua/configs/mason.lua` (ensure_installed list)
- **Lock File**: `lazy-lock.json` (plugin version locks)

## Configuration Architecture

### Plugin Loading Order
1. `init.lua` bootstraps lazy.nvim and loads NvChad
2. NvChad base configuration is imported
3. Custom plugins from `lua/plugins/init.lua` are loaded
4. LSP configurations are applied via Mason and lspconfig
5. Custom mappings and options are loaded last

### LSP Configuration Flow
- Mason installs tools listed in `lua/configs/mason.lua`
- `lua/configs/lspconfig.lua` imports settings from `lua/configs/lsp.lua`
- Individual server configurations are applied with enhanced settings
- Formatters are configured separately via conform.nvim

### Debugging Setup
- DAP (Debug Adapter Protocol) is configured for C++, Rust, and JavaScript
- Uses codelldb for native debugging (C++/Rust)
- Debugging UI opens automatically when debugging starts
- Breakpoints and watch expressions are supported