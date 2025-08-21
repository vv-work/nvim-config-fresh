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
    "typescript-language-server",
    "vtsls", -- Enhanced TypeScript/JavaScript LSP
    "jsonls",
    "emmet-ls",
    
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
    "cppcheck",
    "eslint_d",
    "biome", -- Fast JavaScript/TypeScript linter and formatter
    "js-debug-adapter", -- JavaScript/TypeScript debugger
  }
}