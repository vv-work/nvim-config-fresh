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
    "glsl_analyzer", -- GLSL language server
    
    -- Formatters
    "stylua",
    "prettier",
    "black",
    "isort",
    "clang-format",
    "cmake-format", -- CMake formatter
    
    -- Linters and tools
    "flake8",
    "mypy",
    "pylint",
    "autopep8",
    "cppcheck",
    "clang-tidy", -- C++ static analysis
    "cmake-language-server", -- CMake support
    "codelldb", -- C++ debugger
    "gdb", -- GNU debugger
    "bear", -- Build system integration
    "cpplint", -- C++ style checker
    "eslint_d",
    "biome", -- Fast JavaScript/TypeScript linter and formatter
    "js-debug-adapter", -- JavaScript/TypeScript debugger
  }
}