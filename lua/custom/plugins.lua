return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require(".configs.null-ls")
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    -- Removed to avoid conflicts with copilot.lua + copilot-cmp
    -- "github/copilot.vim",
  },

  -- Catppuccin theme (Mocha flavor)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
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
      -- NVChad base46 applies its own colorscheme; we only configure flavour.
      -- If you prefer the plugin colorscheme directly, uncomment:
      -- vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },


}
