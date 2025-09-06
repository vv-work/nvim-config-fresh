-- Java LSP setup using nvim-jdtls
local M = {}

local function get_os_config_dir(jdtls_base)
  local sys = vim.loop.os_uname().sysname
  if sys == "Darwin" then
    return jdtls_base .. "/config_mac"
  elseif sys == "Linux" then
    return jdtls_base .. "/config_linux"
  else
    return jdtls_base .. "/config_win"
  end
end

local function get_jdtls_paths()
  local mason = vim.fn.stdpath("data") .. "/mason"
  local jdtls_base = mason .. "/packages/jdtls"
  local launcher = vim.fn.glob(jdtls_base .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local config_dir = get_os_config_dir(jdtls_base)

  -- Optional: Java DAP and test bundles if installed
  local java_dbg = mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
  local java_test = mason .. "/packages/java-test/extension/server/*.jar"

  local bundles = {}
  local dbg_bundle = vim.fn.glob(java_dbg, 1)
  if dbg_bundle ~= nil and dbg_bundle ~= "" then
    table.insert(bundles, dbg_bundle)
  end
  local test_bundles = vim.fn.glob(java_test, 1)
  if test_bundles ~= nil and test_bundles ~= "" then
    local parts = vim.split(test_bundles, "\n", { trimempty = true })
    vim.list_extend(bundles, parts)
  end

  return launcher, config_dir, bundles
end

local function get_root_dir()
  local util = require("lspconfig.util")
  return util.root_pattern("gradlew", "mvnw", ".git")(vim.fn.getcwd()) or vim.fn.getcwd()
end

local function get_workspace_dir(root_dir)
  local home = vim.fn.expand("~")
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace = home .. "/.local/share/eclipse/" .. project_name
  return workspace
end

function M.setup()
  local jdtls_ok, jdtls = pcall(require, "jdtls")
  if not jdtls_ok then
    vim.schedule(function()
      vim.notify("nvim-jdtls not found", vim.log.levels.WARN)
    end)
    return
  end

  local launcher, config_dir, bundles = get_jdtls_paths()
  if launcher == nil or launcher == "" then
    vim.schedule(function()
      vim.notify("jdtls launcher not found. Install via :Mason (jdtls)", vim.log.levels.WARN)
    end)
    return
  end

  if vim.fn.executable("java") ~= 1 then
    vim.schedule(function()
      vim.notify("Java runtime not found on PATH. Install JDK (e.g., temurin) and ensure `java` is available.", vim.log.levels.WARN)
    end)
    return
  end

  local root_dir = get_root_dir()
  local workspace_dir = get_workspace_dir(root_dir)

  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace_dir,
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  pcall(function()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  end)

  local on_attach = function(client, bufnr)
    -- Let conform.nvim handle formatting if desired
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true

    -- DAP integration
    pcall(function()
      jdtls.setup_dap({ hotcodereplace = "auto" })
      jdtls.setup.add_commands()
    end)

    -- Basic keymaps (use your global LSP maps as well)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end

  local settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      completion = {
        favoriteStaticMembers = {},
        importOrder = { "java", "javax", "com", "org" },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
    },
  }

  jdtls.start_or_attach({
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    init_options = { bundles = bundles },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- Start/attach when opening Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("configs.jdtls").setup()
  end,
})

return M
