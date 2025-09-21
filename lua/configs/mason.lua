-- Mason tool installation settings
return {
  ensure_installed = {
    -- Language servers
    "rust-analyzer",
    "pyright",
    "omnisharp",
    "jdtls",
    "clangd",
    "lua-language-server",
    "html-lsp",
    "css-lsp",
    "marksman",
    "typescript-language-server",
    "vtsls", -- Enhanced TypeScript/JavaScript LSP
    "eslint-lsp", -- ESLint language server
    "jsonls",
    "emmet-ls",
    "glsl_analyzer", -- GLSL language server
    "bash-language-server", -- Bash LSP
    "fish-lsp", -- Fish shell LSP
    "taplo", -- TOML language server
    "java-debug-adapter", -- Java DAP
    "java-test", -- Java test runner

    -- Formatters
    "stylua",
    "prettier",
    "black",
    "isort",
    "clang-format",
    "shfmt", -- Shell formatter (sh/bash)
    "google-java-format",
    "cmake-format", -- CMake formatter
    "rustfmt", -- Rust formatter
    "taplo", -- TOML formatter
    
    -- Rust-specific tools
    "bacon", -- Rust background code checker
    "cargo-expand", -- Rust macro expansion
    "cargo-edit", -- Cargo dependency management
    "cargo-watch", -- Cargo file watcher
    "cargo-outdated", -- Check for outdated dependencies
    "cargo-audit", -- Security vulnerability scanner
    "cargo-machete", -- Find unused dependencies
    "cargo-nextest", -- Next-generation test runner
    "cargo-llvm-cov", -- Code coverage with LLVM
    "cargo-tarpaulin", -- Code coverage tool
    
    -- Linters and tools
    "flake8",
    "mypy",
    "pylint",
    "autopep8",
    "cppcheck",
    "clang-tidy", -- C++ static analysis
    "shellcheck", -- Shell diagnostics
    "cmake-language-server", -- CMake support
    "codelldb", -- C++ and Rust debugger
    "gdb", -- GNU debugger
    "bear", -- Build system integration
    "cpplint", -- C++ style checker
    "eslint_d",
    "biome", -- Fast JavaScript/TypeScript linter and formatter
    "js-debug-adapter", -- JavaScript/TypeScript debugger
    
    -- Swift tooling (formatting/linting). sourcekit-lsp provided by Xcode.
    "swiftformat",
    "swiftlint",
    
    -- LaTeX tooling
    "texlab", -- LaTeX LSP
    "chktex", -- LaTeX linter
  }
}
