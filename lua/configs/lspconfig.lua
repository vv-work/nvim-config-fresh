require("nvchad.configs.lspconfig").defaults()

local lsp_settings = require "configs.lsp"

-- Enable configured LSP servers
vim.lsp.enable(lsp_settings.servers)

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

-- GLSL Analyzer configuration
require("lspconfig").glsl_analyzer.setup(lsp_settings.glsl_analyzer)

-- Enhanced clangd configuration for C++
require("lspconfig").clangd.setup(lsp_settings.clangd)

-- CMake LSP configuration
require("lspconfig").cmake.setup(lsp_settings.cmake)

-- read :h vim.lsp.config for changing options of lsp servers 
