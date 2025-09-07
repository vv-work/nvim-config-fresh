require("nvchad.configs.lspconfig").defaults()

local lsp_settings = require "configs.lsp"

-- Prefer ccls for Metal if available; prevent clangd from also attaching to metal
if vim.fn.executable("ccls") == 1 and lsp_settings.clangd and lsp_settings.clangd.filetypes then
  local filtered = vim.tbl_filter(function(ft)
    return ft ~= "metal"
  end, lsp_settings.clangd.filetypes)
  lsp_settings.clangd.filetypes = filtered
end

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

-- ccls for Metal-only (as an alternative to clangd)
if vim.fn.executable("ccls") == 1 then
  pcall(function()
    require("lspconfig").ccls.setup(lsp_settings.ccls)
  end)
else
  vim.schedule(function()
    vim.notify("ccls not found; using clangd for Metal", vim.log.levels.INFO)
  end)
end

-- CMake LSP configuration
require("lspconfig").cmake.setup(lsp_settings.cmake)

-- Swift SourceKit-LSP configuration
pcall(function()
  require("lspconfig").sourcekit.setup(lsp_settings.sourcekit)
end)

-- Enhanced Rust Analyzer configuration
-- Rust LSP is managed by rustaceanvim to avoid double setup
-- See plugin config in lua/plugins/init.lua (mrcjkb/rustaceanvim)
-- If rustaceanvim is removed, re-enable the line below.
-- require("lspconfig").rust_analyzer.setup(lsp_settings.rust_analyzer)

-- HTML/CSS/Markdown language servers
pcall(function() require("lspconfig").html.setup({}) end)
pcall(function() require("lspconfig").cssls.setup({}) end)
pcall(function() require("lspconfig").marksman.setup({}) end)

-- read :h vim.lsp.config for changing options of lsp servers 
