local M = {}
local api = vim.api

-- Safer trigger check that avoids out-of-range indexing
local function check_triggered_chars(trigger_chars)
  if type(trigger_chars) ~= "table" or vim.tbl_isempty(trigger_chars) then
    return false
  end

  local cur_line = api.nvim_get_current_line()
  -- nvim_win_get_cursor returns 0-indexed column; convert to 1-based for Lua strings
  local pos = (api.nvim_win_get_cursor(0)[2] or 0) + 1

  local prev_char = (pos > 1) and cur_line:sub(pos - 1, pos - 1) or ""
  local cur_char = cur_line:sub(pos, pos)

  for _, char in ipairs(trigger_chars) do
    if cur_char == char or prev_char == char then
      return true
    end
  end

  return false
end

M.setup = function(client, bufnr)
  -- Validate inputs and capabilities to avoid "Invalid buffer id" errors
  if not client or type(bufnr) ~= "number" or not api.nvim_buf_is_valid(bufnr) then
    return
  end

  local caps = client.server_capabilities or {}
  local sig = caps.signatureHelpProvider or {}
  local trigger_chars = sig.triggerCharacters or {}

  -- If server doesn't support signature help, do nothing
  if vim.tbl_isempty(trigger_chars) then
    return
  end

  local group = api.nvim_create_augroup("LspSignature", { clear = false })
  -- pcall to guard against races where the buffer gets wiped
  pcall(api.nvim_clear_autocmds, { group = group, buffer = bufnr })

  api.nvim_create_autocmd("TextChangedI", {
    group = group,
    buffer = bufnr,
    callback = function()
      -- Buffer might have been deleted between events
      if not api.nvim_buf_is_valid(bufnr) then
        return
      end
      if check_triggered_chars(trigger_chars) then
        -- Use focus=false, silent=true as in NVChad default
        vim.lsp.buf.signature_help { focus = false, silent = true, max_height = 7, border = "single" }
      end
    end,
  })
end

return M

