require("nvchad.configs.lspconfig").defaults()

local lsp_settings = require "configs.lsp"

-- Enhanced Pyright configuration
require("lspconfig").pyright.setup(lsp_settings.pyright)

-- Enhanced Omnisharp configuration with Roslyn support
require("lspconfig").omnisharp.setup(lsp_settings.omnisharp)

-- Enhanced VTSLS TypeScript/JavaScript configuration
require("lspconfig").vtsls.setup(lsp_settings.vtsls)

-- Emmet LSP configuration
require("lspconfig").emmet_ls.setup(lsp_settings.emmet_ls)

-- Enhanced JSON LSP configuration
require("lspconfig").jsonls.setup(lsp_settings.jsonls)

-- ESLint diagnostics for JS/TS
pcall(function()
  require("lspconfig").eslint.setup(lsp_settings.eslint)
end)

-- GLSL Analyzer configuration
require("lspconfig").glsl_analyzer.setup(lsp_settings.glsl_analyzer)

-- Enhanced clangd configuration for C++
require("lspconfig").clangd.setup(lsp_settings.clangd)

-- CMake LSP configuration
require("lspconfig").cmake.setup(lsp_settings.cmake)

-- Enhanced Rust Analyzer configuration
require("lspconfig").rust_analyzer.setup(lsp_settings.rust_analyzer)

-- HTML/CSS/Markdown language servers
pcall(function() require("lspconfig").html.setup({}) end)
pcall(function() require("lspconfig").cssls.setup({}) end)
pcall(function() require("lspconfig").marksman.setup({}) end)

-- read :h vim.lsp.config for changing options of lsp servers 
