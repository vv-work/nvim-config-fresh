-- Treesitter parser and configuration settings
return {
  ensure_installed = {
    "vim",
    "lua", 
    "vimdoc",
    "html",
    "css",
    "c_sharp",
    "python",
    "markdown",
    "markdown_inline",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "bash",
    "regex",
    "sql",
    "cpp",
    "c"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" }
  },
  indent = {
    enable = true
  }
}