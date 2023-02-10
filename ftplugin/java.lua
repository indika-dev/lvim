vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.cc = ""
vim.opt_local.foldcolumn = "1"
vim.opt_local.foldenable = true
vim.opt_local.signcolumn = "yes"

-- credit: https://github.com/ChristianChiarulli/nvim
local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
  return
end

local function has_value(table, value)
  for _, val in ipairs(table) do
    if value == val then
      return true
    end
  end
  return false
end

local home = os.getenv "HOME"
local MASON_BASEPATH = home .. "/.local/share/nvim/mason/packages"

-- Determine OS
local launcher_path = vim.fn.glob(MASON_BASEPATH .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
if #launcher_path == 0 then
  launcher_path = vim.fn.glob(MASON_BASEPATH .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]
end
local CONFIG = ""
local WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
if vim.fn.has "mac" == 1 then
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  CONFIG = "linux"
else
  print "Unsupported system"
end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local project_name = vim.fs.basename(root_dir)

local non_workspace_markers = { vim.fs.basename(home), "workspace" }
local workspace_dir = ""

-- if not (has_value(non_workspace_markers, vim.fs.basename(vim.fn.fnamemodify(root_dir, ":h")))) then
--   workspace_dir = vim.fn.fnamemodify(root_dir, ":h")
-- else
workspace_dir = WORKSPACE_PATH .. project_name
os.execute("mkdir -p " .. workspace_dir)
-- end

local bundles = vim.split(
  vim.fn.glob(MASON_BASEPATH .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  "\n"
)

local extra_bundles = vim.split(vim.fn.glob(MASON_BASEPATH .. "/java-test/extension/server/*.jar"), "\n")
vim.list_extend(bundles, extra_bundles)

local javaHome = home .. "/.local/lib/vscode-jdtls/jre"
-- local javaHome = home .. "/.local/lib/jvm-17"
-- local javaHome = "/home/stefan/.sdkman/candidates/java/17.0.4-tem"

local config = {
  cmd = {
    javaHome .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. MASON_BASEPATH .. "/jdtls/lombok.jar",
    "-jar",
    launcher_path,
    "-configuration",
    MASON_BASEPATH .. "/jdtls/config_" .. CONFIG,
    "-data",
    workspace_dir,
  },
  on_attach = function(client, bufnr)
    vim.lsp.codelens.refresh()
    jdtls.setup_dap { hotcodereplace = "auto" }
    require("jdtls.setup").add_commands()
    require("lvim.lsp").common_on_attach(client, bufnr)
  end,
  root_dir = root_dir,
  -- @see https://github.com/eclipse/eclipse.jdt.ls/wiki/running-the-java-ls-server-from-the-command-line#initialize-request
  -- settings = {
  --   java = {
  --     jdt = {
  --       ls = {
  --         lombokSupport = { enabled = false },
  --       },
  --     },
  --     eclipse = {
  --       downloadSources = true,
  --     },
  --     templates = {
  --       fileHeader = {
  --         "/**",
  --         " * ${type_name}",
  --         " * @author ${user}",
  --         " */",
  --       },
  --       typeComment = {
  --         "/**",
  --         " * ${type_name}",
  --         " * @author ${user}",
  --         " */",
  --       },
  --     },
  --     configuration = {
  --       updateBuildConfiguration = "interactive",
  --       runtimes = {
  --         {
  --           name = "JavaSE-1.8",
  --           path = "/home/stefan/.local/lib/jvm-8/",
  --         },
  --         {
  --           name = "JavaSE-11",
  --           path = "/home/stefan/.local/lib/jvm-11/",
  --         },
  --         {
  --           name = "JavaSE-17",
  --           path = "/home/stefan/.local/lib/jvm-17/",
  --           default = true,
  --         },
  --       },
  --     },
  --     rename = {
  --       enabled = true,
  --     },
  --     import = {
  --       enabled = true,
  --     },
  --     maven = {
  --       downloadSources = true,
  --     },
  --     implementationsCodeLens = {
  --       enabled = true,
  --     },
  --     referencesCodeLens = {
  --       enabled = true,
  --     },
  --     references = {
  --       includeDecompiledSources = true,
  --     },
  --     inlayHints = {
  --       parameterNames = {
  --         enabled = true,
  --       },
  --     },
  --     format = {
  --       enabled = true,
  --       settings = {
  --         profile = "GoogleStyle",
  --         url = home .. "/.config/lvim/.java-google-formatter.xml",
  --       },
  --     },
  --     signatureHelp = { enabled = true },
  --     completion = {
  --       favoriteStaticMembers = {
  --         "java.util.Objects.requireNonNull",
  --         "java.util.Objects.requireNonNullElse",
  --         "org.mockito.Mockito.*",
  --         "org.junit.jupiter.api.DynamicTest.*",
  --         "org.junit.jupiter.api.Assertions.*",
  --         "org.junit.jupiter.api.Assumptions.*",
  --         "org.junit.jupiter.api.DynamicContainer.*",
  --         "org.junit.Assert.*",
  --         "org.junit.Assume.*",
  --         "org.mockito.ArgumentMatchers.*",
  --         "org.mockito.Mockito.*",
  --         "org.mockito.Answers.*",
  --       },
  --       filteredTypes = {
  --         "com.sun.*",
  --         "io.micrometer.shaded.*",
  --         "java.awt.*",
  --         "jdk.*",
  --         "sun.*",
  --       },
  --     },
  --     contentProvider = { preferred = "fernflower" },
  --     sources = {
  --       organizeImports = {
  --         starThreshold = 9999,
  --         staticStarThreshold = 9999,
  --       },
  --     },
  --     codeGeneration = {
  --       toString = {
  --         listArrayContents = true,
  --         skipNullValues = true,
  --         template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
  --       },
  --       hashCodeEquals = {
  --         useInstanceof = true,
  --         useJava7Objects = true,
  --       },
  --       useBlocks = true,
  --       generateComments = true,
  --       insertLocation = true,
  --     },
  --     saveActions = {
  --       organizeImports = false,
  --     },
  --     autobuild = {
  --       enabled = true,
  --     },
  --     progressReports = {
  --       enabled = false,
  --     },
  --   },
  -- },
  flags = {
    allow_incremental_sync = true,
    server_side_fuzzy_completion = true,
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = vim.tbl_deep_extend(
      "keep",
      { progressReportProvider = false, resolveAdditionalTextEditsSupport = true, classFileContentsSupport = false },
      jdtls.extendedClientCapabilities
    ),
  },
  handlers = {
    ["language/status"] = vim.schedule_wrap(function(_, s)
      local command = vim.api.nvim_command
      command "echohl ModeMsg"
      command(string.format('echo "%s"', s.message))
      command "echohl None"
      if "ServiceReady" == s.type and lvim.custom.jdtls and lvim.custom.jdtls.initial_debug_search == false then
        require("jdtls.dap").setup_dap_main_class_configs { verbose = true }
        lvim.custom.jdtls.initial_debug_search = true
      end
    end),
  },
  capabilities = {
    workspace = {
      configuration = true,
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
}
jdtls.start_or_attach(config)

local wkstatus_ok, which_key = pcall(require, "which-key")
if wkstatus_ok then
  local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  }

  local vopts = {
    mode = "v",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  }

  local mappings = {
    j = {
      name = " Java",
      o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
      v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
      c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
      t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
      T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
      u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
      i = { "<Cmd>JdtCompile incremental<CR>", "Compile incrementaly" },
      f = { "<Cmd>JdtCompile full<CR>", "Compile fully" },
      s = { "<Cmd>lua require'jdtls'.super_implementation()<CR>", "Go to super implementation" },
    },
  }

  local vmappings = {
    j = {
      name = " Java",
      v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
      c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
      m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
    },
  }

  which_key.register(mappings, opts)
  which_key.register(vmappings, vopts)
end
