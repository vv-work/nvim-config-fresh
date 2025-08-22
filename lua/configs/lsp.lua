-- LSP server configurations
local M = {}

-- List of LSP servers to enable
M.servers = { "html", "cssls", "omnisharp", "marksman", "clangd", "vtsls", "jsonls", "emmet_ls", "glsl_analyzer", "cmake", "rust_analyzer" }

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

-- GLSL Analyzer configuration
M.glsl_analyzer = {
  filetypes = { "glsl", "vert", "frag", "geom", "tesc", "tese", "comp" },
  cmd = { "glsl_analyzer" },
  settings = {
    glslAnalyzer = {
      diagnostics = true,
      hover = true,
      completion = true,
      formatting = true,
    },
  },
}

-- Enhanced clangd configuration for C++
M.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--all-scopes-completion",
    "--cross-file-rename",
    "--log=verbose",
    "--enable-config",
    "--offset-encoding=utf-16",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git"
    )(fname)
  end,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-16" },
  },
}

-- CMake LSP configuration
M.cmake = {
  filetypes = { "cmake" },
  init_options = {
    buildDirectory = "build",
  },
}

-- Enhanced Rust Analyzer configuration
M.rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      -- Core settings
      checkOnSave = {
        command = "cargo-clippy",
        extraArgs = { "--all-targets", "--all-features" },
      },
      
      -- Cargo settings
      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
        runBuildScripts = true,
        useRustcWrapperForBuildScripts = true,
      },
      
      -- Completion and imports
      completion = {
        addCallArgumentSnippets = true,
        addCallParenthesis = true,
        postfix = {
          enable = true,
        },
        privateEditable = {
          enable = true,
        },
        fullFunctionSignatures = {
          enable = true,
        },
      },
      
      -- Diagnostics
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro" },
        enableExperimental = true,
      },
      
      -- Hover and inlay hints
      hover = {
        actions = {
          enable = true,
          implementations = {
            enable = true,
          },
          references = {
            enable = true,
          },
          run = {
            enable = true,
          },
          debug = {
            enable = true,
          },
        },
        documentation = {
          enable = true,
        },
        links = {
          enable = true,
        },
      },
      
      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "never",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
      
      -- Lens and references
      lens = {
        enable = true,
        implementations = {
          enable = true,
        },
        references = {
          adt = {
            enable = true,
          },
          enumVariant = {
            enable = true,
          },
          method = {
            enable = true,
          },
          trait = {
            enable = true,
          },
        },
        run = {
          enable = true,
        },
        debug = {
          enable = true,
        },
      },
      
      -- Workspace and project discovery
      linkedProjects = {},
      procMacro = {
        enable = true,
        ignored = {},
        attributes = {
          enable = true,
        },
      },
      
      -- Assist and code actions
      assist = {
        importEnforceGranularity = true,
        importPrefix = "crate",
      },
      
      -- Call hierarchy and semantic tokens
      callInfo = {
        full = true,
      },
      
      -- Rustfmt integration
      rustfmt = {
        extraArgs = {},
        overrideCommand = nil,
        rangeFormatting = {
          enable = false,
        },
      },
      
      -- Workspace symbol search
      workspace = {
        symbol = {
          search = {
            scope = "workspace_and_dependencies",
            kind = "only_types",
          },
        },
      },
    },
  },
  
  -- File types
  filetypes = { "rust" },
  
  -- Root directory detection
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("Cargo.toml", "rust-project.json")(fname)
      or require("lspconfig.util").find_git_ancestor(fname)
  end,
  
  -- Enhanced capabilities
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
  
  -- Custom on_attach function for Rust-specific keybindings
  on_attach = function(client, bufnr)
    -- Enable hover documentation
    if client.server_capabilities.hoverProvider then
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true})
    end
    
    -- Code actions and formatting
    if client.server_capabilities.codeActionProvider then
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap=true, silent=true})
    end
    
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', {noremap=true, silent=true})
    end
    
    -- Rust-specific keybindings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<cmd>!cargo run<CR>', {noremap=true, silent=true, desc="Cargo Run"})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rt', '<cmd>!cargo test<CR>', {noremap=true, silent=true, desc="Cargo Test"})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rb', '<cmd>!cargo build<CR>', {noremap=true, silent=true, desc="Cargo Build"})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rc', '<cmd>!cargo check<CR>', {noremap=true, silent=true, desc="Cargo Check"})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rd', '<cmd>!cargo doc --open<CR>', {noremap=true, silent=true, desc="Cargo Doc"})
  end,
}

return M