require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- nvim-surround keymaps (already configured in plugin setup, this is for reference)
-- Normal mode:
-- ys<motion><char> - Add surroundings (e.g., ysiw" adds quotes around word)
-- yss<char> - Add surroundings around entire line
-- yS<motion><char> - Add surroundings on new lines
-- ySS<char> - Add surroundings around entire line on new lines
-- ds<char> - Delete surroundings (e.g., ds" removes quotes)
-- cs<old><new> - Change surroundings (e.g., cs"' changes quotes to single quotes)
-- cS<old><new> - Change surroundings on new lines

-- Visual mode:
-- S<char> - Add surroundings around selection
-- gS<char> - Add surroundings around selection on new lines

-- Insert mode:
-- <C-g>s<char> - Add surroundings
-- <C-g>S<char> - Add surroundings on new lines

-- AI Assistant Keymaps
-- OpenAI CLI (Aider) in terminal split:
map("n", "<leader>ai", function() require("configs.openai_cli").toggle() end, { desc = "OpenAI CLI (Aider): Toggle" })
map("n", "<leader>an", function() require("configs.openai_cli").new_session() end, { desc = "OpenAI CLI (Aider): New Session" })

-- Completion Keymaps:
-- BLINK.CMP (completion menu):
-- Enter - Accept completion from menu
-- Up/Down arrows - Navigate completions
--
-- GITHUB COPILOT (inline suggestions):
-- Tab - Accept full Copilot suggestion
-- Ctrl+] - Accept one word from suggestion
-- Ctrl+n - Next suggestion, Ctrl+p - Previous suggestion
-- Ctrl+e - Dismiss suggestion
-- Copilot suggestions also appear in blink.cmp completion menu
-- Use :Copilot to manage authentication and settings
-- Use :Copilot status to check connection status
--
-- COPILOT CHAT:
-- <leader>cp - Toggle Copilot Chat
-- <leader>cpe - Explain code (normal/visual mode)
-- <leader>cpt - Generate tests (normal/visual mode)
-- <leader>cpf - Fix code (normal/visual mode)
-- <leader>cpx - Optimize code (normal/visual mode)
-- <leader>cpd - Generate docs (normal/visual mode)
-- <leader>cpo - Open chat, <leader>cpc - Close chat
-- <leader>cpr - Reset chat history
