-- vimtex configuration for LaTeX editing and compilation
-- Viewer: Skim on macOS with forward/inverse search
vim.g.vimtex_view_method = (vim.fn.has("mac") == 1) and "skim" or "zathura"

-- Compiler: latexmk with sane defaults
vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  options = {
    '-pdf',
    '-interaction=nonstopmode',
    '-synctex=1',
    '-file-line-error',
  },
}

-- Quickfix: don't auto-open on warnings
vim.g.vimtex_quickfix_mode = 0

-- Syntax and conceal settings
vim.g.vimtex_syntax_conceal = {
  accents = 1,
  ligatures = 1,
  cites = 0,
  fancy = 1,
  spacing = 0,
}

-- Enable TOC and mappings lazily
vim.g.vimtex_mappings_enabled = 1
vim.g.vimtex_toc_config = { layer_status = { content = 1, todo = 0, include = 0 } }

