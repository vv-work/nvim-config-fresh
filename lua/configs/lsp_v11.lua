local M = {}

-- Try to fetch default server config from nvim-lspconfig without using the deprecated framework
local function get_default_server_config(server)
  local ok, mod = pcall(require, "lspconfig.server_configurations." .. server)
  if ok and type(mod) == "table" and type(mod.default_config) == "table" then
    return vim.deepcopy(mod.default_config)
  end
  return {}
end

-- Compute root_dir: prefer cfg.root_dir, else fallback to git ancestor or current dir
local function resolve_root_dir(cfg, bufname)
  local root_dir = cfg.root_dir
  if type(root_dir) == "function" then
    local ok, dir = pcall(root_dir, bufname)
    if ok and dir and dir ~= "" then
      return dir
    end
  end
  -- Fallback to git ancestor or file's directory
  local util_ok, util = pcall(require, "lspconfig.util")
  if util_ok then
    local dir = util.find_git_ancestor(bufname)
      or util.root_pattern(".git")(bufname)
    if dir and dir ~= "" then return dir end
  end
  local fdir = vim.fn.fnamemodify(bufname, ":p:h")
  return fdir ~= "" and fdir or vim.loop.cwd()
end

-- Merge defaults with user config and start server on relevant filetypes using the 0.11 API
function M.setup(server, user_cfg)
  local defaults = get_default_server_config(server)
  local cfg = vim.tbl_deep_extend("force", defaults, user_cfg or {})

  -- Determine filetypes to trigger on
  local fts = cfg.filetypes or {}
  if type(fts) ~= "table" or vim.tbl_isempty(fts) then
    -- If no filetypes, start on any buffer that matches root_dir – but better to bail
    return
  end

  -- Autostart on FileType and avoid duplicate clients per buffer
  local group = vim.api.nvim_create_augroup("LspStart_" .. server, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = fts,
    callback = function(args)
      local bufnr = args.buf
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      -- Skip if a client with this name already attached
      for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if client.name == server then
          return
        end
      end

      local start_cfg = vim.tbl_deep_extend("force", cfg, {
        name = server,
        root_dir = resolve_root_dir(cfg, bufname),
      })

      -- 0.11 API: wrap with vim.lsp.config if available
      local final_cfg = (type(vim.lsp.config) == "function") and vim.lsp.config(start_cfg) or start_cfg
      vim.lsp.start(final_cfg)
    end,
  })
end

return M

