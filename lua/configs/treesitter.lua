-- Treesitter parser and configuration settings
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
    "gitignore" -- Git ignore files
  },
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
