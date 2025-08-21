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

-- read :h vim.lsp.config for changing options of lsp servers 
