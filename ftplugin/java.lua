vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.cc = ""

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

local function on_textdocument_codeaction(err, actions, ctx)
  for _, action in ipairs(actions) do
    -- TODO: (steelsojka) Handle more than one edit?
    if action.command == "java.apply.workspaceEdit" then -- 'action' is Command in java format
      action.edit = fix_zero_version(action.edit or action.arguments[1])
    elseif type(action.command) == "table" and action.command.command == "java.apply.workspaceEdit" then -- 'action' is CodeAction in java format
      action.edit = fix_zero_version(action.edit or action.command.arguments[1])
    end
  end
end

local function on_textdocument_rename(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

-- -- Non-standard notification that can be used to display progress
local function on_language_status(_, result)
  local command = vim.api.nvim_command
  command "echohl ModeMsg"
  command(string.format('echo "%s"', result.message))
  command "echohl None"
end

local function on_workspace_applyedit(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
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

local workspace_dir = WORKSPACE_PATH .. project_name
os.execute("mkdir -p " .. workspace_dir)

local bundles = vim.split(
  vim.fn.glob(MASON_BASEPATH .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  "\n"
)

local extra_bundles = vim.split(vim.fn.glob(MASON_BASEPATH .. "/java-test/extension/server/*.jar"), "\n")
vim.list_extend(bundles, extra_bundles)

local javaHome = home .. "/.local/lib/vscode-jdtls/jre"
-- local javaHome = home .. "/.local/lib/jvm-17"

local config = {
  cmd = {
    javaHome .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. MASON_BASEPATH .. "/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher_path,
    "-configuration",
    MASON_BASEPATH .. "/jdtls/config_" .. CONFIG,
    "-data",
    workspace_dir,
  },
  on_attach = function(client, bufnr)
    -- require("jdtls.dap").setup_dap_main_class_configs()
    require("jdtls.setup").add_commands()
    require("lvim.lsp").common_on_attach(client, bufnr)
  end,
  on_init = require("lvim.lsp").common_on_init,
  on_exit = require("lvim.lsp").common_on_exit,
  root_dir = root_dir,
  settings = {
    java = {
      -- jdt = {
      --   ls = {
      --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m",
      --   },
      -- },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/home/stefan/.local/lib/jvm-8/",
          },
          {
            name = "JavaSE-11",
            path = "/home/stefan/.local/lib/jvm-11/",
          },
          {
            name = "JavaSE-17",
            path = "/home/stefan/.local/lib/jvm-17/",
          },
        },
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
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = true,
        settings = {
          profile = "GoogleStyle",
          url = home .. "/.config/lvim/.java-google-formatter.xml",
        },
      },
    },
    signatureHelp = { enabled = true, description = { enabled = true } },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
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
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      hashCodeEquals = {
        useJava7Objects = true,
      },
      useBlocks = true,
    },
  },
  flags = {
    allow_incremental_sync = true,
    server_side_fuzzy_completion = true,
  },
  handlers = {
    -- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
    -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
    ["textDocument/codeAction"] = on_textdocument_codeaction,
    ["textDocument/rename"] = on_textdocument_rename,
    ["workspace/applyEdit"] = on_workspace_applyedit,
    ["language/status"] = vim.schedule_wrap(on_language_status),
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = vim.tbl_deep_extend(
      "keep",
      { resolveAdditionalTextEditsSupport = true, classFileContentsSupport = false },
      require("jdtls.setup").extendedClientCapabilities
    ),
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
jdtls.setup_dap { hotcodereplace = "auto" }

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
