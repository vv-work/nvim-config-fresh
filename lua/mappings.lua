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
