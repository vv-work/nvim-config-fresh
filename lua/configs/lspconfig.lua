require("nvchad.configs.lspconfig").defaults()

local lsp_settings = require "configs.lsp"
local v11 = require "configs.lsp_v11"

-- Prefer ccls for Metal if available; prevent clangd from also attaching to metal
if vim.fn.executable("ccls") == 1 and lsp_settings.clangd and lsp_settings.clangd.filetypes then
  local filtered = vim.tbl_filter(function(ft)
    return ft ~= "metal"
  end, lsp_settings.clangd.filetypes)
  lsp_settings.clangd.filetypes = filtered
end

-- Configure servers using the 0.11 API (vim.lsp.start)
v11.setup("pyright", lsp_settings.pyright)
v11.setup("omnisharp", lsp_settings.omnisharp)
v11.setup("vtsls", lsp_settings.vtsls)
v11.setup("emmet_ls", lsp_settings.emmet_ls)
v11.setup("jsonls", lsp_settings.jsonls)
v11.setup("bashls", lsp_settings.bashls)
v11.setup("fish_lsp", lsp_settings.fish_lsp)
v11.setup("eslint", lsp_settings.eslint)
v11.setup("glsl_analyzer", lsp_settings.glsl_analyzer)
v11.setup("clangd", lsp_settings.clangd)
v11.setup("cmake", lsp_settings.cmake)
v11.setup("texlab", lsp_settings.texlab)
v11.setup("sourcekit", lsp_settings.sourcekit)
v11.setup("html", {})
v11.setup("cssls", {})
v11.setup("marksman", {})
v11.setup("mdx_analyzer", lsp_settings.mdx_analyzer)

-- ccls for Metal-only (as an alternative to clangd)
if vim.fn.executable("ccls") == 1 then
  v11.setup("ccls", lsp_settings.ccls)
else
  vim.schedule(function()
    vim.notify("ccls not found; using clangd for Metal", vim.log.levels.INFO)
  end)
end

-- read :h lspconfig-nvim-0.11 for details on vim.lsp.config usage
