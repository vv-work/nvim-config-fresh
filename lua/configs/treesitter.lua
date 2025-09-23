-- Treesitter parser and configuration settings
local ignore = {}
if vim.fn.executable("tree-sitter") == 0 then
  -- Skip languages that require generation from grammar when tree-sitter CLI is missing
  ignore = { "swift", "latex" }
end

return {
  ensure_installed = {
    "vim",
    "lua", 
    "vimdoc",
    "html",
    "css",
    "scss",
    "java",
    "c_sharp",
    "python",
    "markdown",
    "markdown_inline",
    "mdx",
    "javascript",
    "typescript",
    "tsx",
    "jsdoc",
    "json",
    "jsonc",
    "yaml",
    "toml",
    "ron", -- Rust Object Notation
    "vue",
    "svelte",
    "bash",
    "fish",
    "regex",
    "sql",
    "cpp",
    "c",
    "make", -- Makefile syntax
    "glsl", -- GLSL shader language
    "hlsl", -- HLSL shader language  
    "cmake", -- CMake build system
    "cuda", -- CUDA
    "rust", -- Rust language
    "go", -- Go language
    "swift", -- Swift language
    "dockerfile", -- Docker
    "ini", -- INI files
    "gitignore", -- Git ignore files
    "latex" -- LaTeX syntax
  },
  ignore_install = ignore,
  ensure_installed_extra = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" }
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
