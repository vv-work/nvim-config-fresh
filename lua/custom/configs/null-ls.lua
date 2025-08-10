local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local opts = {
  sources = {
    -- C/C++ formatting
    formatting.clang_format.with({
      filetypes = { "c", "cpp", "objc", "objcpp" },
      args = {
        "--style=file", -- Use .clang-format file if present
        "--fallback-style=Google", -- Fallback to Google style
      },
    }),

    -- Python formatting
    formatting.black.with({
      extra_args = { "--fast" },
    }),
    formatting.isort,

    -- Lua formatting
    formatting.stylua,

    -- Python diagnostics
    diagnostics.flake8,
    diagnostics.mypy.with({
      extra_args = { "--ignore-missing-imports" },
    }),

    -- C/C++ diagnostics
    diagnostics.cppcheck.with({
      args = { "--enable=warning,style,performance,portability", "--template=gcc", "$FILENAME" },
    }),
  },
}

return opts
