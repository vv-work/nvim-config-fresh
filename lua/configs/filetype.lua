-- Enhanced filetype detection for shaders and other languages
-- Override built-in C# detection to avoid '#' character issues

-- CRITICAL: Override the core filetype system to prevent 'c#' from ever being used
-- This prevents the runtime ftplugin loading issues with the '#' character

-- Hook into the filetype detection system at the lowest level
do
  local original_detect = vim.filetype.detect
  vim.filetype.detect = function(opts)
    local result = original_detect(opts)
    -- If the detected filetype is 'c#', change it to 'cs' immediately
    if result == "c#" then
      return "cs"
    end
    return result
  end
end

-- Override vim.bo.filetype setter to prevent 'c#' from being set
do
  local bo_mt = getmetatable(vim.bo)
  local original_newindex = bo_mt.__newindex
  bo_mt.__newindex = function(t, key, value)
    if key == "filetype" and value == "c#" then
      value = "cs"
    end
    return original_newindex(t, key, value)
  end
end

-- Prevent the built-in c# filetype from ever being set via autocmd
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c#",
  callback = function(ev)
    vim.schedule(function()
      -- Force change from c# to cs
      vim.bo[ev.buf].filetype = "cs"
      vim.bo[ev.buf].syntax = "cs" 
      vim.bo[ev.buf].commentstring = "// %s"
    end)
  end,
})

vim.filetype.add({
  extension = {
    -- C# files (use 'cs' instead of 'c#' to avoid vim special character issues)
    cs = "cs",
    
    -- GLSL shader files
    glsl = "glsl",
    vert = "glsl",
    frag = "glsl",
    geom = "glsl",
    tesc = "glsl",
    tese = "glsl",
    comp = "glsl",
    
    -- HLSL shader files
    hlsl = "hlsl",
    fx = "hlsl",
    fxh = "hlsl",
    vsh = "hlsl",
    psh = "hlsl",
    
    -- Additional C++ extensions
    cxx = "cpp",
    cc = "cpp",
    hxx = "cpp",
    hpp = "cpp",
    h = "cpp", -- Prefer C++ for .h files in mixed projects
    
    -- CUDA files
    cu = "cuda",
    cuh = "cuda",
    
    -- Metal shading language
    metal = "metal",

    -- Fish shell scripts
    fish = "fish",
    
    -- CMake files
    cmake = "cmake",
  },
  
  filename = {
    -- CMake files
    ["CMakeLists.txt"] = "cmake",
    ["CMakeCache.txt"] = "cmake",
    
    -- Docker files
    ["Dockerfile"] = "dockerfile",
    ["dockerfile"] = "dockerfile",
    
    -- Git files
    [".gitignore"] = "gitignore",
    [".gitmodules"] = "gitconfig",
    [".gitconfig"] = "gitconfig",
  },
  
  pattern = {
    -- CMake patterns
    [".*%.cmake$"] = "cmake",
    ["CMakeLists%.txt$"] = "cmake",
    
    -- Shader patterns (for files without clear extensions)
    [".*%.shader$"] = "glsl",
    [".*%.material$"] = "glsl",
    
    -- Make files
    ["[Mm]akefile.*"] = "make",
    [".*%.mk$"] = "make",
  },
})

-- Explicit override for C# files to prevent '#' character issues
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.cs",
  callback = function()
    -- Set filetype first
    vim.bo.filetype = "cs"
    -- Ensure syntax is also cs, not c#
    vim.bo.syntax = "cs"
    -- Set commentstring explicitly
    vim.bo.commentstring = "// %s"
  end,
})

-- Treesitter: reuse C++ parser for Metal
pcall(function()
  if vim.treesitter and vim.treesitter.language and vim.treesitter.language.register then
    vim.treesitter.language.register("cpp", "metal")
  end
end)

-- Additional safety: override any FileType autocmd that might interfere
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    -- Use vim.schedule to run after other FileType autocmds
    vim.schedule(function()
      -- Double-check syntax setting
      if vim.bo.syntax ~= "cs" then
        vim.bo.syntax = "cs"
      end
      -- Ensure commentstring is correct
      vim.bo.commentstring = "// %s"
    end)
  end,
})

-- Comprehensive override of all filetype option functions
-- Some runtime helpers try to load ftplugin files using the raw filetype string,
-- which breaks when a '#' character is present. Normalize to 'cs'.
do
  -- Override vim.filetype.get_option
  local ftmod = require "vim.filetype"
  local orig_get_option = ftmod.get_option
  ftmod.get_option = function(name, ft)
    local t = ft or vim.bo.filetype
    if t == "c#" then
      t = "cs"
    end
    return orig_get_option(name, t)
  end
  
  -- Also override the internal options module used by vim._comment
  local options_mod = require "vim.filetype.options"
  if options_mod and options_mod.get_option then
    local orig_options_get = options_mod.get_option
    options_mod.get_option = function(name, ft)
      local t = ft or vim.bo.filetype
      if t == "c#" then
        t = "cs"
      end
      return orig_options_get(name, t)
    end
  end
  
  -- Override nvim_get_option_value calls that use filetype context
  local orig_get_option_value = vim.api.nvim_get_option_value
  vim.api.nvim_get_option_value = function(name, opts)
    if opts and opts.filetype and opts.filetype == "c#" then
      opts = vim.tbl_extend("force", opts, { filetype = "cs" })
    end
    return orig_get_option_value(name, opts)
  end
end

-- Buffer-local C# comment toggles to avoid runtime ftplugin issues
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    local api = vim.api

    local function is_commented(line)
      return line:find("^%s*//%s?") ~= nil
    end

    local function toggle_line()
      local line = api.nvim_get_current_line()
      local indent = line:match("^%s*") or ""
      if is_commented(line) then
        local s, e = line:find("^%s*//%s?")
        api.nvim_set_current_line(line:sub(1, s - 1) .. line:sub(e + 1))
      else
        api.nvim_set_current_line(indent .. "// " .. line:sub(#indent + 1))
      end
    end

    local function toggle_visual()
      local buf = 0
      local srow = api.nvim_buf_get_mark(buf, "<")[1] - 1
      local erow = api.nvim_buf_get_mark(buf, ">")[1] - 1

      -- Determine if all non-empty lines are commented
      local all_commented = true
      for i = srow, erow do
        local l = api.nvim_buf_get_lines(buf, i, i + 1, false)[1] or ""
        if l:match("%S") and not is_commented(l) then
          all_commented = false
          break
        end
      end

      for i = srow, erow do
        local l = api.nvim_buf_get_lines(buf, i, i + 1, false)[1] or ""
        local indent = l:match("^%s*") or ""
        if l:match("%S") then
          if all_commented then
            local s, e = l:find("^%s*//%s?")
            if s then
              l = l:sub(1, s - 1) .. l:sub(e + 1)
            end
          else
            if not is_commented(l) then
              l = indent .. "// " .. l:sub(#indent + 1)
            end
          end
          api.nvim_buf_set_lines(buf, i, i + 1, false, { l })
        end
      end
    end

    -- Buffer-local mappings overriding Comment.nvim for C#
    vim.keymap.set("n", "<leader>/", toggle_line, { buffer = true, desc = "Toggle comment (C#)" })
    vim.keymap.set("v", "<leader>/", toggle_visual, { buffer = true, desc = "Toggle comment (C# selection)" })
  end,
})
