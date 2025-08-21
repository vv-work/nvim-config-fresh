-- LSP server configurations
local M = {}

-- List of LSP servers to enable
M.servers = { "html", "cssls", "omnisharp", "marksman", "clangd", "vtsls", "jsonls", "emmet_ls" }

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

-- Enhanced VTSLS (TypeScript/JavaScript) configuration
M.vtsls = {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
}

-- Emmet LSP for HTML/CSS autocompletion
M.emmet_ls = {
  filetypes = { 
    "html", 
    "css", 
    "scss", 
    "javascriptreact", 
    "typescriptreact", 
    "vue", 
    "svelte" 
  },
}

-- Enhanced JSON LSP configuration
M.jsonls = {
  settings = {
    json = {
      validate = { enable = true },
    },
  },
}

return M