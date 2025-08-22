local keymaps = require "configs.keymaps"

return {
  -- tmux and copilot plugins
    {
      "christoomey/vim-tmux-navigator",
      cmd = keymaps.tmux_commands,
      keys = keymaps.tmux_navigator,
    },
    {
      "github/copilot.vim",
      lazy = false,
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
      vim.g.mkdp_browser = "/usr/bin/open"
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_page_title = "Preview: ${name}"
    end,
  },

  -- TypeScript/JavaScript specific plugins
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_locale = "en",
      },
    },
  },

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

      -- C++ configuration for codelldb
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        }
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
        -- Custom filetypes
        ft = {
          cs = "// %s",
        },
      })
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

}
