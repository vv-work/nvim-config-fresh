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

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

}
