-- Formatter configurations for conform.nvim
-- Note: C/C++ formatting is handled by null-ls for better integration
return {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    markdown = { "prettier" },
    java = { "google-java-format" },
    javascript = { "biome", "prettier" },
    javascriptreact = { "biome", "prettier" },
    typescript = { "biome", "prettier" },
    typescriptreact = { "biome", "prettier" },
    json = { "biome", "prettier" },
    jsonc = { "biome", "prettier" },
    vue = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    cuda = { "clang-format" },
    glsl = { "clang-format" },
    vert = { "clang-format" },
    frag = { "clang-format" },
    geom = { "clang-format" },
    tesc = { "clang-format" },
    tese = { "clang-format" },
    comp = { "clang-format" },
    cmake = { "cmake_format" },
    rust = { "rustfmt" },
    toml = { "taplo" }
  },

  formatters = {
    -- Configure biome for better performance
    biome = {
      condition = function(ctx)
        return vim.fs.find({ "biome.json", ".biomejs.json" }, { path = ctx.filename, upward = true })[1]
      end,
    },
  },

  -- Uncomment to enable format on save
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}
