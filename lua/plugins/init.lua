local keymaps = require "custom.keymaps"

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
    opts = require "custom.formatters",
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require "configs.lspconfig"
  --   end,
  -- },

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
  	opts = require "custom.mason",
  },
  --
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = require "custom.treesitter",
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = keymaps.markdown_commands,
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
