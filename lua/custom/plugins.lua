return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

}  
