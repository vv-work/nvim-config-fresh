-- Formatter configurations for conform.nvim
-- Note: C/C++ formatting is handled by null-ls for better integration
return {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    markdown = { "prettier" },
    -- cpp = { "clang-format" }, -- Handled by null-ls
    -- c = { "clang-format" }, -- Handled by null-ls
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- Uncomment to enable format on save
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}