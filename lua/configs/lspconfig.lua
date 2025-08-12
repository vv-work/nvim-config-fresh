require("nvchad.configs.lspconfig").defaults()

local lsp_settings = require "configs.lsp"

-- Enable configured LSP servers
vim.lsp.enable(lsp_settings.servers)

-- Enhanced Pyright configuration
require("lspconfig").pyright.setup(lsp_settings.pyright)

-- Enhanced Omnisharp configuration with Roslyn support
require("lspconfig").omnisharp.setup(lsp_settings.omnisharp)

-- read :h vim.lsp.config for changing options of lsp servers 
