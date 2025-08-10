-- Custom keybinding configurations
local M = {}

-- Tmux navigator keymaps
M.tmux_navigator = {
  { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
  { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
  { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
  { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
  { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" }
}

-- Tmux navigator commands
M.tmux_commands = {
  "TmuxNavigateLeft",
  "TmuxNavigateDown",
  "TmuxNavigateUp",
  "TmuxNavigateRight",
  "TmuxNavigatePrevious",
  "TmuxNavigatorProcessList"
}

-- Markdown preview commands
M.markdown_commands = { 
  "MarkdownPreviewToggle", 
  "MarkdownPreview", 
  "MarkdownPreviewStop" 
}

return M