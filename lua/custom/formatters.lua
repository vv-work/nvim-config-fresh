-- Formatter configurations for conform.nvim
return {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- Uncomment to enable format on save
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}