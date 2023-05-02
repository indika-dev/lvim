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
local sha1 = require "sha1"
local home = vim.env.HOME
local command = vim.api.nvim_command
local jdtls_install_path = require("mason-registry").get_package("jdtls"):get_install_path()
-- Determine OS
local CONFIG = ""
if vim.fn.has "mac" == 1 then
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  CONFIG = "linux"
elseif vim.fn.has "win32" == 1 then
  CONFIG = "win"
else
  vim.notify("Unsupported system", vim.log.levels.ERROR)
  return
end

local launcher_path = vim.fn.glob(jdtls_install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
-- local binary_path = vim.fn.glob(jdtls_install_path .. "/bin/jdtls")
if #launcher_path == 0 then
  command "echohl ErrorMsg"
  command 'echo "jdtls launcher not found"'
  command "echohl None"
  return
end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  command "echohl ErrorMsg"
  command 'echo "couldn\'t determine root directory of project"'
  command "echohl None"
  return
end
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "cache" .. "/jdtls/workspace/" .. project_name
-- if not lvim.custom.jdtls.first_start or lvim.custom.jdtls.first_start == false then
--   os.execute("rm -rf " .. workspace_dir)
--   os.execute("mkdir -p " .. workspace_dir)
-- end

-- Test bundle
-- Run :MasonInstall java-test
local bundles = {
  vim.fn.glob(
    require("mason-registry").get_package("java-debug-adapter"):get_install_path()
      .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
  ),
}
if #bundles == 0 then
  command "echohl WarningMsg"
  command 'echo "java-debug-adapter not found. Install it via mason"'
  command "echohl None"
end
-- Debug bundle
-- Run :MasonInstall java-debug-adapter
local extra_bundles = vim.split(
  vim.fn.glob(require("mason-registry").get_package("java-test"):get_install_path() .. "/extension/server/*.jar"),
  "\n",
  {}
)

if #extra_bundles == 0 then
  command "echohl WarningMsg"
  command 'echo "java-test adapter not found. Install it via mason"'
  command "echohl None"
end
vim.list_extend(bundles, extra_bundles)

-- local javaHome = home .. "/.local/lib/jvm-17"
local javaHome = home .. "/.sdkman/candidates/java/17.0.6-tem"

local config = {
  -- cmd = {
  --   binary_path,
  --   "-javaagent:" .. home .. "/.local/lib/lombok-1.18.26.jar",
  --   "-data",
  --   workspace_dir,
  --   "-configuration",
  --   jdtls_install_path .. "/config_" .. CONFIG,
  -- },
  cmd = {
    javaHome .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. jdtls_install_path .. "/config_" .. CONFIG,
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    "-Dsun.zip.disableMemoryMapping=true",
    "-Xmx1G",
    "-Xms100m",
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
    "-configuration",
    jdtls_install_path .. "/config_" .. CONFIG,
  },
  on_attach = function(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    jdtls.setup_dap { hotcodereplace = "auto" }
    require("jdtls.setup").add_commands()
    require("lvim.lsp").common_on_attach(client, bufnr)
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
            name = "JavaSE-1.8",
            path = home .. "/.local/lib/jvm-8",
          },
          {
            name = "JavaSE-17",
            path = home .. "/.local/lib/jvm-17",
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
          enabled = "none",
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
        organizeImports = true,
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
      resolveAdditionalTextEditsSupport = true,
      classFileContentsSupport = false,
      overrideMethodsPromptSupport = true,
      advancedGenerateAccessorsSupport = true,
      -- gradleChecksumWrapperPromptSupport = true,
      advancedIntroduceParameterRefactoringSupport = true,
      -- actionableRuntimeNotificationSupport = true,
      extractInterfaceSupport = true,
      onCompletionItemSelectedCommand = "editor.action.triggerParameterHints",
    }, jdtls.extendedClientCapabilities),
  },
  handlers = {
    ["language/status"] = vim.schedule_wrap(function(_, s)
      if "ServiceReady" == s.type then
        require("jdtls.dap").setup_dap_main_class_configs {
          verbose = true,
          on_ready = function()
            command "echohl ModeMsg"
            command(string.format('echo "jdt.ls %s"', s.message))
            command "echohl None"
          end,
        }
      end
    end),
    ["$/progress"] = vim.schedule_wrap(function(_, result)
      -- command "echohl ModeMsg"
      -- command(string.format('echo "%s"', result.message))
      -- command "echohl None"
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
  local nopts = {
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

  which_key.register(mappings, nopts)
  which_key.register(vmappings, vopts)
end
