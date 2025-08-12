-- Custom configuration for markdown code block highlighting
-- Maps additional aliases to existing treesitter parsers

local M = {}

-- Function to set up markdown code block language aliases
M.setup = function()
  -- Map csharp and c# aliases to c_sharp parser
  vim.treesitter.language.register("c_sharp", {"csharp", "c#"})
  
  -- Additional common aliases that might be useful
  vim.treesitter.language.register("javascript", {"js"})
  vim.treesitter.language.register("typescript", {"ts"})
  vim.treesitter.language.register("python", {"py"})
  vim.treesitter.language.register("bash", {"sh", "shell"})
end

return M