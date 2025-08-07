require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "omnisharp", "marksman" }
vim.lsp.enable(servers)

-- Enhanced Pyright configuration
require("lspconfig").pyright.setup {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic"
      }
    }
  }
}

-- read :h vim.lsp.config for changing options of lsp servers 
