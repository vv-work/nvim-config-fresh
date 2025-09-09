-- Minimal CLI-style OpenAI integration using a terminal split.
-- Defaults to the Aider CLI (https://aider.chat). Requires OPENAI_API_KEY.

local M = {}

local state = {
  win = nil,
  buf = nil,
  job = nil,
  size = 80, -- right split width
  position = "right", -- only right supported for now
  cmd = { "aider", "--model", "gpt-4o-mini" },
}

local function is_running()
  return state.buf and vim.api.nvim_buf_is_valid(state.buf) and state.win and vim.api.nvim_win_is_valid(state.win)
end

local function start_terminal()
  if vim.fn.executable(state.cmd[1]) ~= 1 then
    vim.schedule(function()
      vim.notify(
        (state.cmd[1] .. " CLI not found. Install Aider: `pipx install aider-chat` or `pip install -U aider-chat`\n"
          .. "Set OPENAI_API_KEY in your shell. You can change the command in lua/configs/openai_cli.lua."),
        vim.log.levels.ERROR
      )
    end)
    return
  end

  -- Create/right split and terminal buffer
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(state.win, state.size)

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(state.win, state.buf)

  -- Start terminal job
  state.job = vim.fn.termopen(state.cmd, {
    on_exit = function()
      -- Clear state when process exits
      if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
      end
      state.job = nil
      state.win = nil
      state.buf = nil
    end,
  })

  vim.bo[state.buf].filetype = "aider"
  vim.bo[state.buf].buflisted = false
  vim.bo[state.buf].buftype = "terminal"
  vim.api.nvim_set_current_win(cur_win)
end

function M.toggle()
  if is_running() then
    -- Close the window; keep job running? Terminal job ends if buffer wiped.
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
    return
  end
  start_terminal()
end

function M.new_session()
  -- Kill existing job/buffer, then start fresh
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    -- Try to terminate the job nicely
    if state.job and state.job > 0 then
      pcall(vim.fn.jobstop, state.job)
    end
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end
  state.win = nil
  state.buf = nil
  state.job = nil
  start_terminal()
end

-- Optional: allow users to override defaults
function M.setup(opts)
  opts = opts or {}
  if opts.size then state.size = opts.size end
  if opts.position then state.position = opts.position end
  if opts.cmd then state.cmd = opts.cmd end
end

return M

