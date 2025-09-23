-- LSP server configurations
local M = {}

-- List of LSP servers to enable
M.servers = { "html", "cssls", "omnisharp", "marksman", "clangd", "ccls", "vtsls", "jsonls", "emmet_ls", "glsl_analyzer", "cmake", "rust_analyzer", "texlab", "mdx_analyzer" }
-- Note: Swift (sourcekit) is configured below via lspconfig but not listed here

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
  -- Resolve vtsls from Mason bin to avoid PATH issues
  cmd = (function()
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/vtsls"
    if vim.fn.executable(mason_bin) == 1 then
      return { mason_bin, "--stdio" }
    else
      return { "vtsls", "--stdio" }
    end
  end)(),
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git")(fname)
  end,
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

-- ESLint LSP for JS/TS diagnostics and code actions
M.eslint = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "mdx",
  },
  settings = {
    workingDirectory = { mode = "auto" },
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
    format = false,
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    validate = "on",
  },
}

-- MDX language server (mdx-analyzer)
M.mdx_analyzer = {
  filetypes = { "mdx" },
  -- Default settings are fine; mdx-analyzer primarily offers diagnostics
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("package.json", ".git")(fname)
  end,
}

-- Texlab LSP for LaTeX
M.texlab = {
  filetypes = { "tex", "plaintex", "latex" },
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-file-line-error", "%f" },
        onSave = true,
        forwardSearchAfter = true,
      },
      forwardSearch = (function()
        -- Use Skim on macOS for forward search if available
        if vim.fn.has("mac") == 1 then
          return {
            executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
            args = { "-r", "-b", "%l", "%p", "%f" },
          }
        end
        -- Fallback: generic PDF viewer (no forward search)
        return { executable = "", args = {} }
      end)(),
      chktex = { onOpenAndSave = true, onEdit = false },
      latex = {
        bibtexFormatter = "texlab",
      },
    },
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

-- Bash language server (bash-language-server)
M.bashls = {
  filetypes = { "sh", "bash" },
  cmd = { "bash-language-server", "start" },
}

-- Fish shell language server (fish-lsp)
M.fish_lsp = {
  filetypes = { "fish" },
  -- Mason installs fish-lsp as 'fish-lsp'; fallback to PATH
  cmd = (function()
    local bin = vim.fn.stdpath("data") .. "/mason/bin/fish-lsp"
    if vim.fn.executable(bin) == 1 then
      return { bin, "start" }
    end
    return { "fish-lsp", "start" }
  end)(),
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
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "metal" },
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
  on_attach = function(client, bufnr)
    -- Basic LSP keymaps
    if client.server_capabilities.hoverProvider then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true })
    end
    if client.server_capabilities.codeActionProvider then
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, silent = true, desc = 'Code Action' })
    end
    if client.server_capabilities.documentFormattingProvider then
      vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end,
        { buffer = bufnr, silent = true, desc = 'Format' })
    end

    -- Helper: detect if CMake project
    local function is_cmake()
      local cwd = vim.fn.getcwd()
      return (vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1)
    end

    -- Build current project or file
    vim.keymap.set('n', '<leader>cb', function()
      if is_cmake() and pcall(require, 'cmake-tools') then
        require('cmake-tools').build()
      else
        local cc = (vim.fn.executable('clang') == 1) and 'clang' or 'cc'
        local cmd = string.format('%s %s -g -O0 -Wall -Wextra -o %s', cc, vim.fn.shellescape(vim.fn.expand('%')),
          vim.fn.shellescape(vim.fn.expand('%:r')))
        vim.cmd('!' .. cmd)
      end
    end, { buffer = bufnr, silent = true, desc = 'C: Build' })

    -- Run current target or file output
    vim.keymap.set('n', '<leader>cr', function()
      if is_cmake() and pcall(require, 'cmake-tools') then
        require('cmake-tools').run()
      else
        local bin = vim.fn.expand('%:r')
        if vim.fn.executable(bin) == 1 then
          vim.cmd('!' .. vim.fn.shellescape(bin))
        else
          vim.notify('No built binary: ' .. bin .. ' (build first with <leader>cb)', vim.log.levels.WARN)
        end
      end
    end, { buffer = bufnr, silent = true, desc = 'C: Run' })

    -- Optional: quick tidy for current file (requires compile_commands.json for best results)
    vim.keymap.set('n', '<leader>ct', function()
      if vim.fn.executable('clang-tidy') == 0 then
        vim.notify('clang-tidy not found (install via Mason)', vim.log.levels.WARN)
        return
      end
      local cmd = string.format('clang-tidy %s --', vim.fn.shellescape(vim.fn.expand('%')))
      vim.cmd('!' .. cmd)
    end, { buffer = bufnr, silent = true, desc = 'C: clang-tidy current file' })
  end,
}

-- ccls as an alternative LSP for Metal (limited C++-like support)
M.ccls = {
  filetypes = { "metal" },
  init_options = {
    cache = { directory = ".ccls-cache" },
  },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(
      "compile_commands.json",
      ".ccls",
      ".git"
    )(fname)
  end,
}

-- CMake LSP configuration
M.cmake = {
  filetypes = { "cmake" },
  init_options = {
    buildDirectory = "build",
  },
}

-- Swift (SourceKit-LSP) configuration
M.sourcekit = {
  cmd = (function()
    -- Prefer Xcode's sourcekit-lsp if available on PATH
    return { "sourcekit-lsp" }
  end)(),
  filetypes = { "swift" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("Package.swift", ".swiftpm")(fname)
      or util.find_git_ancestor(fname)
      or util.path.dirname(fname)
  end,
  settings = {
    -- SourceKit uses sensible defaults; keep minimal to avoid crashes
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.hoverProvider then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true })
    end
    if client.server_capabilities.codeActionProvider then
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, silent = true, desc = 'Code Action' })
    end
    if client.server_capabilities.documentFormattingProvider then
      vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end,
        { buffer = bufnr, silent = true, desc = 'Format' })
    end
  end,
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
