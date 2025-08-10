-- Mason tool installation settings
return {
  ensure_installed = {
    -- Language servers
    "rust-analyzer",
    "pyright",
    "omnisharp",
    "clangd",
    "lua-language-server",
    "html-lsp",
    "css-lsp",
    "marksman",
    
    -- Formatters
    "stylua",
    "prettier",
    "black",
    "isort",
    "clang-format",
    
    -- Linters and tools
    "flake8",
    "mypy",
    "pylint",
    "autopep8",
    "cppcheck"
  }
}