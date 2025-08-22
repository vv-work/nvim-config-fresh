# Repository Guidelines

## Project Structure & Module Organization
- Root `init.lua`: entry point that loads modules under `lua/`.
- `lua/options.lua`, `lua/mappings.lua`, `lua/autocmds.lua`: core editor settings, keymaps, and events.
- `lua/plugins/` and `lua/custom/plugins.lua`: plugin specs (lazy.nvim) and local overrides.
- `lua/configs/`: plugin configuration (e.g., LSP, Treesitter, formatter).
- `chadrc.lua`: NVChad user config; adjust theme, UI, and defaults.
- `.stylua.toml`: Lua formatter config. `lazy-lock.json`: pinned plugin versions.
- `test_pyright.py`: sample file for LSP sanity checks.

## Build, Test, and Development Commands
- Install/sync plugins: inside Neovim run `:Lazy sync` (or headless `nvim --headless -u init.lua "+Lazy! sync" +qall`).
- Health check: `:checkhealth` (headless: `nvim --headless -u init.lua "+checkhealth" +qall`).
- LSP tools: `:Mason`, `:LspInfo` to manage/inspect servers.
- Reload Lua module you’re editing: `:luafile %` (or restart Neovim for broader changes).
- Treesitter: `:TSUpdate` to keep parsers current.

## Coding Style & Naming Conventions
- Lua: 2-space indentation, no tabs; prefer `snake_case` for files and functions.
- Keep plugin config in `lua/configs/<plugin>.lua`; keep plugin specs in `lua/plugins/*.lua` or `lua/custom/plugins.lua`.
- Run `stylua lua/` before committing to ensure consistent formatting.

## Testing Guidelines
- Smoke test: `nvim --headless -u init.lua "+checkhealth" +qall` should report OK.
- LSP check: open `test_pyright.py`, run `:LspInfo`, confirm `pyright` attached; verify diagnostics and hover.
- Manual verification: open a project file and confirm Treesitter highlighting, formatter, and keymaps work as expected.

## Commit & Pull Request Guidelines
- Commits: short imperative subject (<= 72 chars), scoped messages (e.g., "configs(lsp): adjust pyright"), reference issues when relevant.
- Keep changes focused (options, mappings, a single plugin, or a single config file).
- PRs: include summary, environment (`nvim --version`), screenshots/logs for errors, and steps to reproduce.
- Do not update `lazy-lock.json` unless intentionally changing plugin versions.

## Security & Configuration Tips
- Never commit API keys or secrets; prefer environment variables or OS keychain.
- This config lives at `~/.config/nvim` (`:echo stdpath('config')`). Backup before major changes.
