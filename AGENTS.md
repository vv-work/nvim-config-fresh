# Repository Guidelines

## Project Structure & Module Organization
- Entry: `init.lua` loads modules under `lua/`.
- Core: `lua/options.lua`, `lua/mappings.lua`, `lua/autocmds.lua`.
- Plugins: specs in `lua/plugins/` and local overrides in `lua/custom/plugins.lua`.
- Configs: plugin setup in `lua/configs/<plugin>.lua` (LSP, Treesitter, formatter).
- UI: `chadrc.lua` for NVChad theme, UI, and defaults.
- Tooling: `.stylua.toml` (formatter), `lazy-lock.json` (pinned plugin versions).
- Samples: `test_pyright.py` for LSP sanity checks. Config lives at `~/.config/nvim`.

## Build, Test, and Development Commands
- Install/sync plugins: `:Lazy sync` or headless `nvim --headless -u init.lua "+Lazy! sync" +qall`.
- Health check: `:checkhealth` or headless `nvim --headless -u init.lua "+checkhealth" +qall`.
- LSP tooling: `:Mason` (manage servers), `:LspInfo` (inspect attachments).
- Dev loop: edit a Lua module and `:luafile %` to reload; update parsers with `:TSUpdate`.

## Coding Style & Naming Conventions
- Lua: 2-space indentation, no tabs; prefer `snake_case` for files/functions.
- Keep plugin configs in `lua/configs/<plugin>.lua`; keep specs in `lua/plugins/*.lua` or `lua/custom/plugins.lua`.
- Run `stylua lua/` before committing to keep formatting consistent.

## Testing Guidelines
- Smoke: run the health check (see above) and ensure OK.
- LSP: open `test_pyright.py`, run `:LspInfo`, confirm `pyright` attached; verify diagnostics/hover.
- Manual: open project files to confirm Treesitter highlighting, formatter, and keymaps.

## Commit & Pull Request Guidelines
- Commits: short imperative subject (≤72 chars) with scope, e.g., `configs(lsp): adjust pyright`.
- Keep changes focused (options, mappings, a single plugin, or a single config).
- Do not update `lazy-lock.json` unless intentionally changing plugin versions.
- PRs: include summary, `nvim --version`, logs/screenshots for errors, and steps to reproduce.

## Security & Configuration Tips
- Never commit API keys or secrets; prefer environment variables or OS keychain.
- Path: `~/.config/nvim` (`:echo stdpath('config')`). Back up before major changes.

