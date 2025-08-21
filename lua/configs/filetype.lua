-- Enhanced filetype detection for shaders and other languages
vim.filetype.add({
  extension = {
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