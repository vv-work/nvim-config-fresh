-- LSP server configurations
local M = {}

-- List of LSP servers to enable
M.servers = { "html", "cssls", "omnisharp", "marksman", "clangd" }

-- Enhanced Pyright configuration
M.pyright = {
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

-- Omnisharp configuration with Roslyn support
M.omnisharp = {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  settings = {
    omnisharp = {
      useGlobalMono = "never",
      useModernNet = true,
      enableRoslynAnalyzers = true,
      enableEditorConfigSupport = true,
      enableMsBuildLoadProjectsOnDemand = false,
      organizeImportsOnFormat = true,
      enableImportCompletion = true,
      sdkIncludePrereleases = true,
      analyzeOpenDocumentsOnly = false,
    }
  },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json")(fname)
      or require("lspconfig.util").find_git_ancestor(fname)
  end,
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Enable Roslyn-specific features
    if client.server_capabilities.codeActionProvider then
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap=true, silent=true})
    end
    
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', {noremap=true, silent=true})
    end
  end,
}

return M