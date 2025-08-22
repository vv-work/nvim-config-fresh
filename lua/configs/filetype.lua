-- Enhanced filetype detection for shaders and other languages
-- Override built-in C# detection to avoid '#' character issues

-- First, completely disable the built-in c# filetype detection
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c#",
  callback = function()
    -- Immediately change from c# to cs to prevent any issues
    vim.bo.filetype = "cs"
    vim.bo.syntax = "cs"
    vim.bo.commentstring = "// %s"
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