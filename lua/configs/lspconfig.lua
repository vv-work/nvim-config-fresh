require("nvchad.configs.lspconfig").defaults()

local lsp_settings = require "custom.lsp"

-- Enable configured LSP servers
vim.lsp.enable(lsp_settings.servers)

-- Enhanced Pyright configuration
require("lspconfig").pyright.setup(lsp_settings.pyright)

-- read :h vim.lsp.config for changing options of lsp servers 
