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
local handlers = require "vim.lsp.handlers"

-- TextDocument version is reported as 0, override with nil so that
-- the client doesn't think the document is newer and refuses to update
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end
handlers["language/status"] = vim.schedule_wrap(function(_, s)
  local command = vim.api.nvim_command
  command "echohl ModeMsg"
  command(string.format('echo "%s"', s.message))
  command "echohl None"
  if "ServiceReady" == s.type and lvim.custom.jdtls and lvim.custom.jdtls.initial_debug_search == false then
    require("jdtls.dap").setup_dap_main_class_configs { verbose = true }
    lvim.custom.jdtls.initial_debug_search = true
  end
end)
handlers["textDocument/codeAction"] = function(err, actions, ctx)
  for _, action in ipairs(actions) do
    -- TODO: (steelsojka) Handle more than one edit?
    if action.command == "java.apply.workspaceEdit" then -- 'action' is Command in java format
      action.edit = fix_zero_version(action.edit or action.arguments[1])
    elseif type(action.command) == "table" and action.command.command == "java.apply.workspaceEdit" then -- 'action' is CodeAction in java format
      action.edit = fix_zero_version(action.edit or action.command.arguments[1])
    end
  end

  handlers[ctx.method](err, actions, ctx)
end
handlers["textDocument/rename"] = function(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end
handlers["workspace/applyEdit"] = function(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end
handlers["$/progress"] = vim.schedule_wrap(function(_, result)
  local command = vim.api.nvim_command
  command "echohl ModeMsg"
  command(string.format('echo "%s"', result.message))
  command "echohl None"
end)

local home = vim.env.HOME
local MASON_BASEPATH = vim.fn.glob(vim.fn.stdpath "data" .. "/mason")
local launcher_path = vim.fn.glob(MASON_BASEPATH .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
if #launcher_path == 0 then
  launcher_path =
    vim.fn.glob(MASON_BASEPATH .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]
end
local WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
-- Determine OS
local CONFIG = ""
if vim.fn.has "mac" == 1 then
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  CONFIG = "linux"
else
  vim.notify("Unsupported system", vim.log.levels.ERROR)
  return
end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local project_name = vim.fs.basename(root_dir)
-- alternative from abzcoding: local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name
os.execute("rm -rf " .. workspace_dir)
os.execute("mkdir -p " .. workspace_dir)

-- Test bundle
-- Run :MasonInstall java-test
local bundles = { vim.fn.glob(MASON_BASEPATH .. "/packages/java-test/extension/server/*.jar", true) }
if #bundles == 0 then
  bundles = { vim.fn.glob(MASON_BASEPATH .. "/packages/java-test/extension/server/*.jar", true) }
end
-- Debug bundle
-- Run :MasonInstall java-debug-adapter
local extra_bundles = {
  vim.fn.glob(
    MASON_BASEPATH .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true
  ),
}
if #extra_bundles == 0 then
  extra_bundles = {
    vim.fn.glob(
      MASON_BASEPATH .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
      true
    ),
  }
end
vim.list_extend(bundles, extra_bundles)

-- local javaHome = home .. "/.local/lib/vscode-jdtls/jre"
local javaHome = home .. "/.local/lib/jvm-17"
-- local javaHome = "/home/stefan/.sdkman/candidates/java/17.0.4-tem"
-- "-Dosgi.checkConfiguration=true",
-- "-Dosgi.sharedConfiguration.area=" .. MASON_BASEPATH .. "/packages/jdtls/config_" .. CONFIG,
-- "-Dosgi.sharedConfiguration.area.readOnly=true",
-- "-Dosgi.configuration.cascaded=true",
-- .. home .. "/.local/lib/lombok-1.18.26.jar"

local config = {
  cmd = {
    javaHome .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. MASON_BASEPATH .. "/packages/jdtls/config_" .. CONFIG,
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    "-Dsun.zip.disableMemoryMapping=true",
    "-Xmx1G",
    "-Xms100m",
    "-Xlog:disable",
    "-javaagent:" .. home .. "/.local/lib/lombok-1.18.26.jar",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher_path,
    "-data",
    workspace_dir,
  },
  on_attach = function(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    if lvim.builtin.dap.active then
      require("jdtls").setup_dap { hotcodereplace = "auto" }
      require("jdtls.setup").add_commands()
      require("lvim.lsp").on_attach(client, bufnr)
    end
  end,
  root_dir = root_dir,
  -- @see https://github.com/eclipse/eclipse.jdt.ls/wiki/running-the-java-ls-server-from-the-command-line#initialize-request
  settings = {
    java = {
      jdt = {
        ls = {
          lombokSupport = { enabled = false },
          protobufSupport = { enabled = true },
        },
      },
      eclipse = {
        downloadSources = true,
      },
      templates = {
        fileHeader = {
          "/**",
          " * ${type_name}",
          " * @author ${user}",
          " */",
        },
        typeComment = {
          "/**",
          " * ${type_name}",
          " * @author ${user}",
          " */",
        },
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-17",
            path = home .. "/.local/lib/jvm-17/",
            default = true,
          },
        },
      },
      quickfix = {
        showAt = "line",
      },
      rename = {
        enabled = true,
      },
      import = {
        enabled = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = true,
        },
      },
      format = {
        enabled = true,
        settings = {
          profile = "GoogleStyle",
          url = home .. "/.config/lvim/.java-google-formatter.xml",
        },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.mockito.ArgumentMatchers.*",
          "org.mockito.Mockito.*",
          "org.mockito.Answers.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          listArrayContents = true,
          skipNullValues = true,
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useInstanceof = true,
          useJava7Objects = true,
        },
        useBlocks = true,
        generateComments = true,
        insertLocation = true,
      },
      saveActions = {
        organizeImports = false,
      },
      autobuild = {
        enabled = true,
      },
      progressReports = {
        enabled = false,
      },
    },
  },
  flags = {
    allow_incremental_sync = true,
    server_side_fuzzy_completion = true,
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = vim.tbl_deep_extend("keep", {
      progressReportProvider = false,
      resolveAdditionalTextEditsSupport = true,
      classFileContentsSupport = false,
      overrideMethodsPromptSupport = true,
      advancedGenerateAccessorsSupport = true,
      clientHoverProvider = true,
      clientDocumentSymbolProvider = true,
      gradleChecksumWrapperPromptSupport = true,
      advancedIntroduceParameterRefactoringSupport = true,
      actionableRuntimeNotificationSupport = true,
      -- onCompletionItemSelectedCommand = "editor.action.triggerParameterHints",
      extractInterfaceSupport = true,
    }, jdtls.extendedClientCapabilities),
  },
  handlers = handlers,
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
    buffer = vim.fn.bufnr(),
    silent = true,
    noremap = true,
    nowait = true,
  }

  local vopts = {
    mode = "v",
    prefix = "<leader>",
    buffer = vim.fn.bufnr(),
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
      r = { "<Cmd>JdtSetRuntime<CR>", "Set runtime" },
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
