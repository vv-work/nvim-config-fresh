local keymaps = require "configs.keymaps"

return {
  -- Catppuccin theme (Mocha flavor)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
          notify = true,
          which_key = true,
          markdown = true,
          mason = true,
          dap = true,
        },
      })
      -- To use plugin colorscheme instead of NVChad base46, uncomment:
      -- vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  -- tmux and copilot plugins
    {
      "christoomey/vim-tmux-navigator",
      cmd = keymaps.tmux_commands,
      keys = keymaps.tmux_navigator,
    },
  -- GitHub Copilot with better integration
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false, -- Disable to avoid conflicts with blink.cmp
          auto_refresh = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false, -- We'll handle Tab manually below
          dismiss = false,
          debounce = 75,
          keymap = {
            accept = "<Tab>", -- Tab to accept suggestion
            accept_word = "<C-]>", -- Ctrl+] to accept one word
            accept_line = false,
            next = "<C-n>", -- Ctrl+n for next suggestion  
            prev = "<C-p>", -- Ctrl+p for previous suggestion
            dismiss = "<C-e>", -- Ctrl+e to dismiss
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = true,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          [".."] = false,
        },
        copilot_node_command = "node", -- Use Node.js binary
        server_opts_overrides = {},
      })
    end,
  },
  
  -- Copilot integration for blink.cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
    },
    keys = {
      { "<leader>cp", function() require("CopilotChat").toggle() end, desc = "Toggle Copilot Chat" },
      { "<leader>cpo", function() require("CopilotChat").open() end, desc = "Open Copilot Chat" },
      { "<leader>cpc", function() require("CopilotChat").close() end, desc = "Close Copilot Chat" },
      { "<leader>cpr", function() require("CopilotChat").reset() end, desc = "Reset Copilot Chat" },
      { "<leader>cpe", "<cmd>CopilotChatExplain<cr>", desc = "Explain code", mode = { "n", "v" } },
      { "<leader>cpt", "<cmd>CopilotChatTests<cr>", desc = "Generate tests", mode = { "n", "v" } },
      { "<leader>cpf", "<cmd>CopilotChatFix<cr>", desc = "Fix code", mode = { "n", "v" } },
      { "<leader>cpx", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code", mode = { "n", "v" } },
      { "<leader>cpd", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs", mode = { "n", "v" } },
    },
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.formatters",
  },


  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  --
  {
  	"williamboman/mason.nvim",
  	opts = require "configs.mason",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "vtsls",
          "eslint",
          "jsonls",
          "emmet_ls",
          "jdtls",
          "clangd",
          "cmake",
          "rust_analyzer",
          "omnisharp",
          "pyright",
          "html",
          "cssls",
          "glsl_analyzer",
        },
      })
    end,
  },
  -- Java LSP via nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      -- Setup handled in lua/configs/jdtls.lua (autocmd on FileType)
      require "configs.jdtls"
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      local cfg = require "configs.mason"
      return {
        ensure_installed = cfg.ensure_installed or {},
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 12,
      }
    end,
  },
  --
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = require "configs.treesitter",
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = keymaps.markdown_commands,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown: Preview Toggle" },
    },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_open = 1
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      -- Use macOS "open" so the plugin spawns the default browser directly
      vim.g.mkdp_browser = "open"
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_page_title = "Preview: ${name}"
    end,
  },

  -- TypeScript/JavaScript handled via VTSLS (see lsp configs)

  {
    "b0o/schemastore.nvim",
    lazy = true,
    version = false,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "astro",
      "glimmer",
      "handlebars",
      "hbs"
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>S", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
    opts = {},
  },

  -- Shader language support
  {
    "tikhomirov/vim-glsl",
    ft = { "glsl", "vert", "frag", "geom", "tesc", "tese", "comp" },
  },

  -- Enhanced C++ debugging and development
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- C++/C/Rust/Swift adapter (codelldb) with robust Mason resolution
      local function resolve_codelldb()
        local ok, registry = pcall(require, "mason-registry")
        if ok then
          local ok_pkg, pkg = pcall(registry.get_package, "codelldb")
          if ok_pkg and pkg:is_installed() then
            local install = pkg:get_install_path()
            local adapter_path = install .. "/extension/adapter/codelldb"
            if vim.fn.executable(adapter_path) == 1 then
              return adapter_path
            end
          end
        end
        local fallback = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
        return vim.fn.expand(fallback)
      end

      local codelldb_cmd = resolve_codelldb()
      if vim.fn.executable(codelldb_cmd) == 0 then
        vim.schedule(function()
          vim.notify(
            "codelldb adapter not found or not executable: " .. codelldb_cmd .. "\nInstall via :Mason (codelldb)",
            vim.log.levels.WARN
          )
        end)
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_cmd,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      -- Enhanced Rust debugging configuration
      dap.configurations.rust = {
        {
          name = "Launch Rust Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Try to find the binary in target/debug/
            local cwd = vim.fn.getcwd()
            local cargo_toml = cwd .. "/Cargo.toml"
            
            if vim.fn.filereadable(cargo_toml) == 1 then
              -- Read package name from Cargo.toml
              local cargo_content = vim.fn.readfile(cargo_toml)
              local package_name = nil
              for _, line in ipairs(cargo_content) do
                local name_match = line:match('^name%s*=%s*"([^"]+)"')
                if name_match then
                  package_name = name_match
                  break
                end
              end
              
              if package_name then
                local debug_path = cwd .. "/target/debug/" .. package_name
                if vim.fn.executable(debug_path) == 1 then
                  return debug_path
                end
              end
            end
            
            -- Fallback to manual input
            return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = "Launch Rust Binary (with args)",
          type = "codelldb",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local cargo_toml = cwd .. "/Cargo.toml"
            
            if vim.fn.filereadable(cargo_toml) == 1 then
              local cargo_content = vim.fn.readfile(cargo_toml)
              local package_name = nil
              for _, line in ipairs(cargo_content) do
                local name_match = line:match('^name%s*=%s*"([^"]+)"')
                if name_match then
                  package_name = name_match
                  break
                end
              end
              
              if package_name then
                local debug_path = cwd .. "/target/debug/" .. package_name
                if vim.fn.executable(debug_path) == 1 then
                  return debug_path
                end
              end
            end
            
            return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_str = vim.fn.input("Arguments: ")
            return vim.split(args_str, " ", { trimempty = true })
          end,
          runInTerminal = false,
        },
        {
          name = "Attach to Rust Process",
          type = "codelldb",
          request = "attach",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp
      -- Swift uses the same codelldb adapter
      dap.configurations.swift = dap.configurations.cpp
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint() end, desc = "Debug: Set Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    },
  },

  -- CMake integration
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      cmake_command = "cmake",
      cmake_build_directory = "build",
      cmake_build_directory_prefix = "",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_options = {},
      cmake_console_position = "belowright",
      cmake_show_console = "always",
      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
      },
      cmake_executor = {
        name = "quickfix",
        default_opts = {
          quickfix = {
            show = "always",
            position = "belowright",
            size = 10,
          },
        },
      },
      cmake_runner = {
        name = "quickfix",
        default_opts = {
          quickfix = {
            show = "always",
            position = "belowright",
            size = 10,
          },
        },
      },
    },
  },

  -- Enhanced C++ completion and snippets
  {
    "hrsh7th/vim-vsnip-integ",
    dependencies = {
      "hrsh7th/vim-vsnip",
    },
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
  },

  -- Enhanced Rust Development Plugins
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          -- Automatically set inlay hints (type hints)
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          -- Options same as lsp hover / vim.lsp.util.open_floating_preview()
          hover_actions = {
            -- the border that is used for the hover window
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
            -- Maximal width of the hover window. Nil means no max.
            max_width = nil,
            -- Maximal height of the hover window. Nil means no max.
            max_height = nil,
            -- whether the hover action window gets automatically focused
            auto_focus = false,
          },
          -- Enable / disable certain features
          reload_workspace_from_cargo_toml = true,
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Rust-specific keybindings
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("run")
            end, { desc = "Run Rust", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>rt", function()
              vim.cmd.RustLsp("testables")
            end, { desc = "Run Rust Tests", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, { desc = "Debug Rust", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>rh", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, { desc = "Hover Actions", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp("explainError")
            end, { desc = "Explain Error", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>rc", function()
              vim.cmd.RustLsp("openCargo")
            end, { desc = "Open Cargo.toml", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>rp", function()
              vim.cmd.RustLsp("parentModule")
            end, { desc = "Parent Module", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>rj", function()
              vim.cmd.RustLsp("joinLines")
            end, { desc = "Join Lines", buffer = bufnr })
            
            vim.keymap.set("n", "<leader>ra", function()
              vim.cmd.RustLsp("codeAction")
            end, { desc = "Code Action", buffer = bufnr })
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              -- Override settings from lsp.lua if needed
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                command = "cargo-clippy",
                extraArgs = { "--all-targets", "--all-features" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  leptos_macro = {
                    -- optional: --
                    -- "component",
                    "server",
                  },
                },
              },
            },
          },
        },
        -- DAP configuration
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(
            vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb"
          ),
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        completion = {
          cmp = {
            enabled = true,
          },
        },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })
    end,
  },

  {
    "Canop/nvim-bacon",
    ft = { "rust" },
    config = function()
      require("bacon").setup()
    end,
  },

  {
    "rouge8/neotest-rust",
    dependencies = {
      "nvim-neotest/neotest",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "rust" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust") {
            args = { "--no-capture" },
            dap_adapter = "codelldb",
          },
        },
        -- Configure output window
        output = {
          enabled = true,
          open_on_run = true,
        },
        -- Configure quickfix list
        quickfix = {
          enabled = false,
        },
        -- Configure status signs
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        -- Configure icons
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✓",
          running = "⟳",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "ⓢ",
          unknown = "?"
        },
      })
      
      -- Test keymaps
      vim.keymap.set("n", "<leader>tr", function()
        require("neotest").run.run()
      end, { desc = "Run nearest test" })
      
      vim.keymap.set("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Run file tests" })
      
      vim.keymap.set("n", "<leader>ta", function()
        require("neotest").run.run(vim.fn.getcwd())
      end, { desc = "Run all tests" })
      
      vim.keymap.set("n", "<leader>ts", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle test summary" })
      
      vim.keymap.set("n", "<leader>to", function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end, { desc = "Show test output" })
      
      vim.keymap.set("n", "<leader>tO", function()
        require("neotest").output_panel.toggle()
      end, { desc = "Toggle output panel" })
      
      vim.keymap.set("n", "<leader>tt", function()
        require("neotest").run.stop()
      end, { desc = "Stop test" })
      
      vim.keymap.set("n", "<leader>td", function()
        require("neotest").run.run({strategy = "dap"})
      end, { desc = "Debug nearest test" })
    end,
  },

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = { "toml" },
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = "cargo",
      })
    end,
  },

  -- Comment plugin for better commenting support
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup({
        -- Add mapping to disable/enable comment
        toggler = {
          line = '<leader>/',
          block = '<leader>bc',
        },
        opleader = {
          line = '<leader>/',
          block = '<leader>bc',
        },
        extra = {
          above = '<leader>cO',
          below = '<leader>co',
          eol = '<leader>cA',
        },
        mappings = {
          basic = true,
          extra = true,
        },
        -- Custom filetypes and pre_hook to bypass Neovim's c# ftplugin lookup
        ft = { cs = "// %s" },
        pre_hook = function(ctx)
          local ft = vim.bo.filetype
          if ft == "cs" or ft == "c#" then
            return "// %s"
          end
        end,
      })
    end,
  },

  -- surround plugin
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      })
    end,
  },

  -- Enhanced blink.cmp with Copilot integration
  { 
    import = "nvchad.blink.lazyspec",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }
      table.insert(opts.sources.default, "copilot")
      
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.copilot = {
        name = "copilot",
        module = "copilot_cmp",
        score_offset = 100,
        async = true,
      }
      
      -- Configure keymaps to use Enter for blink.cmp, leave Tab for Copilot
      opts.keymap = opts.keymap or {}
      opts.keymap["<CR>"] = { "accept", "fallback" }
      opts.keymap["<Tab>"] = { "fallback" } -- Let Tab go to Copilot
      opts.keymap["<S-Tab>"] = { "fallback" } -- Remove Shift+Tab from blink too
      opts.keymap["<Up>"] = { "select_prev", "fallback" }
      opts.keymap["<Down>"] = { "select_next", "fallback" }
      
      return opts
    end,
  },
  
  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        -- Toggle Claude Code with this keymap
        toggle_key = "<leader>ai",
        -- Position of Claude Code window
        position = "right",
        -- Size of Claude Code window
        size = 80,
        -- Auto reload files when Claude Code modifies them
        auto_reload = true,
        -- Command line arguments to pass to claude-code
        claude_args = {},
      })
    end,
    keys = {
      { "<leader>ai", function() require("claude-code").toggle() end, desc = "Toggle Claude Code" },
      { "<leader>an", function() require("claude-code").new_conversation() end, desc = "New Claude conversation" },
    },
  },

}
