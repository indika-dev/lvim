-- general
lvim.log.level = "warn"
vim.opt.relativenumber = true
-- vim.opt.termguicolors = true
lvim.format_on_save = true
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
lvim.builtin.dap.active = true
lvim.builtin.treesitter.rainbow.enable = false
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.telescope.active = true
lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git/",
  "target/",
  "docs/",
  "vendor/*",
  "%.lock",
  "__pycache__/*",
  "%.sqlite3",
  "%.ipynb",
  "node_modules/*",
  -- "%.jpg",
  -- "%.jpeg",
  -- "%.png",
  "%.svg",
  "%.otf",
  "%.ttf",
  "%.webp",
  ".dart_tool/",
  ".github/",
  ".gradle/",
  ".idea/",
  ".settings/",
  ".vscode/",
  "__pycache__/",
  "build/",
  "env/",
  "gradle/",
  "node_modules/",
  "%.pdb",
  "%.dll",
  "%.class",
  "%.exe",
  "%.cache",
  "%.ico",
  "%.pdf",
  "%.dylib",
  "%.jar",
  "%.docx",
  "%.met",
  "smalljre_*/*",
  ".vale/",
  "%.burp",
  "%.mp4",
  "%.mkv",
  "%.rar",
  "%.zip",
  "%.7z",
  "%.tar",
  "%.bz2",
  "%.epub",
  "%.flac",
  "%.tar.gz",
  ".classpath",
  ".factorypath",
  ".project",
  ".settings/",
}

local _time = os.date "*t"
if _time.hour >= 6 and _time.hour < 20 then
  lvim.colorscheme = "tokyonight-storm"
else
  lvim.colorscheme = "kanagawa"
end

lvim.builtin.which_key.mappings.b.s = { "<cmd>Telescope buffers<cr>", "Open Bufferlist" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["L"].K = { "<cmd>Telescope commands<CR>", "View commands" }
lvim.builtin.which_key.mappings["L"].a = { "<cmd>Telescope autocommands<CR>", "View autocommands" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnostics" },
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "dap")
  pcall(telescope.load_extension, "ui-select")
  pcall(telescope.load_extension, "neoclip")
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "refactoring")
  pcall(telescope.load_extension, "asynctasks")
end

-- for some reasons, this is not working as I intended
-- lvim.builtin.dap.on_config_done = function(dap)
--   local dapui_status_ok, dapui = pcall(require, "dapui")
--   if not dapui_status_ok then
--     return
--   end
--   dap.listeners.after["event_initialized"]["dapui_config"] = function(session, body)
--     dapui.open()
--   end
--   dap.listeners.before["event_terminated"]["dapui_config"] = function(session, body)
--     dapui.close()
--   end
--   dap.listeners.before["event_exited"]["dapui_config"] = function(session, body)
--     dapui.close()
--   end
-- end

-- generic LSP settings
lvim.lsp.diagnostics.virtual_text = true
require("mason-lspconfig").setup {
  highlight = {
    enabled = true,
  },
  ignore_install = { "haskell" },
  automatic_installation = true,
  ensure_installed = {
    "jdtls",
    "tsserver",
    "jsonls",
    "sumneko_lua",
    "bashls",
    "cssls",
    "dockerls",
    "eslint",
    "html",
    "zk",
    "pyright",
    "taplo",
    "vimls",
    "vuels",
    "yamlls",
    "marksman",
  },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "stylua",
    filetypes = { "lua" },
  },
  { command = "shfmt", filetypes = { "sh" } },
  {
    name = "prettier",
    filetypes = {
      "html",
      "markdown",
    },
  },
  {
    name = "eslint_d",
    args = { "--fix" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  },
  {
    command = "yamlfmt",
    filetypes = { "yaml", "yml" },
  },
  {
    name = "fixjson",
    filetypes = { "json" },
  },
  {
    name = "taplo",
    filetypes = { "toml" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
    filetypes = { "sh" },
  },
  {
    command = "luacheck",
    filetypes = { "lua" },
  },
  {
    command = "yamllint",
    filetypes = { "yaml", "yml" },
  },
  {
    command = "eslint_d",
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  },
  {
    command = "markdownlint",
    filetypes = { "markdown" },
  },
}

lvim.custom = {
  metals = {
    active = false, -- enable/disable nvim-metals for scala development
    fallbackScalaVersion = "2.13.7",
    serverVersion = "0.10.9+271-a8bb69f6-SNAPSHOT",
  },
  async_tasks = {
    active = true,
  },
}

-- Debugging
-- =========================================
if lvim.builtin.dap.active then
  require("user.dap").config()
end

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  },
}

-- Additional Plugins
lvim.plugins = {
  {
    "Shatur/neovim-ayu",
    config = function()
      local status_ok, lualine = pcall(require, "lualine")
      if status_ok then
        lualine.setup {
          options = {
            theme = "ayu",
          },
        }
      end
    end,
  },
  -- { "folke/tokyonight.nvim" },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup {
        overrides = {
          LspReferenceText = { fg = "NONE", bg = "NONE" },
          -- LspReferenceRead = { bg = "#49443c" },
          -- LspReferenceRead = { bg = "#A3D4D5", fg = "NONE" },
          LspReferenceWrite = { link = "LspReferenceRead" },
        },
      }
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    config = function()
      local ok, githubTheme = pcall(require, "github-theme")
      if ok then
        githubTheme.setup {
          theme_style = "dark",
          sidebars = { "qf", "vista_kind", "terminal", "packer" },

          -- Change the "hint" color to the "orange" color, and make the "error" color bright red
          colors = { hint = "orange", error = "#ff0000" },

          -- Overwrite the highlight groups
          overrides = function(c)
            return {
              htmlTag = { fg = c.red, bg = "#282c34", sp = c.hint, style = "underline" },
              DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
              -- this will remove the highlight groups
              TSField = {},
            }
          end,
        }
      end
    end,
    disable = true,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "wfxr/minimap.vim",
    run = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd [[
        let g:minimap_width = 10
        let g:minimap_auto_start = 0
        let g:minimap_auto_start_win_enter = 0
      ]]
    end,
    disable = true,
  },
  {
    "skywind3000/asynctasks.vim",
    requires = { "skywind3000/asyncrun.vim" },
    config = function()
      vim.cmd [[
          let g:asyncrun_open = 8
          let g:asynctask_template = '~/.config/lvim/task_template.ini'
          let g:asynctasks_extra_config = ['~/.config/lvim/tasks.ini']
        ]]
      lvim.builtin.which_key.mappings["m"] = {
        name = " Make",
        f = { "<cmd>AsyncTask file-build<cr>", "File" },
        p = { "<cmd>AsyncTask project-build<cr>", "Project" },
        e = { "<cmd>AsyncTaskEdit<cr>", "Edit" },
        l = { "<cmd>AsyncTaskList<cr>", "List" },
      }
      lvim.builtin.which_key.mappings["r"] = {
        name = " Run",
        f = { "<cmd>AsyncTask file-run<cr>", "File" },
        p = { "<cmd>AsyncTask project-run<cr>", "Project" },
      }
    end,
    disable = not lvim.custom.async_tasks.active,
  },
  {
    "GustavoKatel/telescope-asynctasks.nvim",
    disable = not lvim.custom.async_tasks.active,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
  {
    "sidebar-nvim/sidebar.nvim",
    requires = { "sidebar-nvim/sections-dap" },
    config = function()
      lvim.builtin.which_key.mappings["S"] = {
        "<cmd>SidebarNvimToggle<CR>",
        require("user.lsp_kind").cmp_kind.Struct .. "Sidebar",
      }
      require("sidebar-nvim").setup {
        disable_default_keybindings = 0,
        bindings = {
          ["q"] = function()
            require("sidebar-nvim").close()
          end,
        },
        open = false,
        side = "right",
        initial_width = 35,
        hide_statusline = true,
        update_interval = 1000,
        sections = { "todos", "git", "diagnostics", "containers", require "dap-sidebar-nvim.breakpoints" },
        section_separator = { "", "-----", "" },
        containers = {
          icon = "",
          attach_shell = "/usr/bin/sh",
          use_podman = true,
          show_all = true,
          interval = 5000,
        },
        datetime = { icon = "", format = "%a %b %d, %H:%M", clocks = { { name = "local" } } },
        todos = { icon = "", ignored_paths = { "~" } },
        dap = {
          breakpoints = {
            icon = require("user.lsp_kind").icons.exit,
          },
        },
      }
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
    event = "BufRead",
    config = function()
      -- -- remap to open the Telescope refactoring menu in visual mode
      -- vim.api.nvim_set_keymap(
      --   "v",
      --   "<leader>rr",
      --   "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      --   { noremap = true }
      -- )
      -- prompt for a refactor to apply when the remap is triggered
      -- vim.api.nvim_set_keymap(
      --   "v",
      --   "<leader>rr",
      --   "<Cmd>lua require('refactoring').select_refactor()<CR>",
      --   { noremap = true, silent = true, expr = false }
      -- )
      require("refactoring").setup {}
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
    disable = true,
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
    disable = true,
  },
  {
    "dhruvasagar/vim-table-mode",
    disable = true,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup {
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    config = function()
      vim.cmd [[packadd telescope.nvim]]
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      }
    end,
    cond = function()
      return not vim.g.neovide and not vim.g.nvui
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    -- setup = function()
    --   require("lspconfig").jdtls.setup = function() end
    -- end,
    setup = function()
      -- Find root of project
      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == "" then
        return
      end

      local home = "/home/stefan/"
      local WORKSPACE_PATH = home .. ".cache/jdtls/workspace/"
      local JDTLS_BASEPATH = home .. ".local/share/nvim/mason/packages/jdtls/"

      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

      local workspace_dir = WORKSPACE_PATH .. project_name
      os.execute("mkdir -p " .. workspace_dir)

      local bundles = vim.split(
        vim.fn.glob(
          home
            .. ".local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
        ),
        "\n"
      )
      local extra_bundles =
        vim.split(vim.fn.glob(home .. ".local/share/nvim/mason/packages/java-test/extension/server/*.jar"), "\n")
      vim.list_extend(bundles, extra_bundles)

      local javaHome = home .. ".local/lib/vscode-jdtls/jre"

      require("lspconfig").jdtls.setup {
        cmd = {
          "jdtls",
          "-data",
          workspace_dir,
          "--data",
          workspace_dir,
          "--jvm-arg --add-modules jdk.incubator.vector=ALL-SYSTEM",
          "--jvm-arg --add-modules jdk.incubator.foreign=ALL-SYSTEM",
          "--jvm-arg -javaagent:" .. JDTLS_BASEPATH .. "lombok.jar",
        },
        on_attach = function(client, bufnr)
          require("jdtls.dap").setup_dap_main_class_configs()
          require("jdtls").setup_dap { hotcodereplace = "auto" }
          require("jdtls.setup").add_commands()
          require("lvim.lsp").common_on_attach(client, bufnr)
        end,
        init_options = {
          bundles = bundles,
          extendedClientCapabilities = {
            progressReportProvider = true,
            resolveAdditionalTextEditsSupport = true,
          },
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
        -- for a complete list of jdt configuration options:
        -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        settings = {
          java = {
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
            inlayhints = {
              parameterNames = {
                enabled = true, -- literals, all, none
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
          quickfix = {
            showAt = "line",
          },
          signatureHelp = { enabled = true },
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
        },
      }
    end,
    config = function()
      vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
      vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
      vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
      -- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
      vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
      -- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

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
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    after = "nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
    disable = not lvim.builtin.dap.active,
  },
  {
    "AckslD/nvim-neoclip.lua",
    requires = { { "tami5/sqlite.lua", module = "sqlite" } },
    config = function()
      require("neoclip").setup {
        history = 1000,
        enable_persistent_history = false,
        length_limit = 1048576,
        continuous_sync = false,
        db_path = vim.fn.stdpath "data" .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        default_register = '"',
        default_register_macros = "q",
        enable_macro_history = true,
        content_spec_column = false,
        on_paste = {
          set_reg = false,
        },
        on_replay = {
          set_reg = false,
        },
        keys = {
          telescope = {
            i = {
              select = "<cr>",
              paste = "<c-p>",
              paste_behind = "<c-k>",
              replay = "<c-q>", -- replay a macro
              delete = "<c-d>", -- delete an entry
              custom = {},
            },
            n = {
              select = "<cr>",
              paste = "p",
              paste_behind = "P",
              replay = "q",
              delete = "d",
              custom = {},
            },
          },
          fzf = {
            select = "default",
            paste = "ctrl-p",
            paste_behind = "ctrl-k",
            custom = {},
          },
        },
      }
    end,
  },
  {
    "~/workspace/luvcron/",
  },
  {
    "jayp0521/mason-null-ls.nvim",
    after = "mason.nvim",
    config = function()
      require("mason-null-ls").setup {
        ensure_installed = {
          "stylua",
          "yamllint",
          "eslint_d",
          "shellcheck",
          "luacheck",
          "prettier",
          "shfmt",
          "stylua",
          "yamlfmt",
          "fixjson",
          "markdownlint",
        },
      }
    end,
  },
  {
    "jayp0521/mason-nvim-dap.nvim",
    after = { "mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = {
          "java-debug-adapter",
          "java-test",
        },
        automatic_installation = true,
        automatic_setup = false,
      }
    end,
  },
  { "gpanders/editorconfig.nvim" },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup {
        input = {
          get_config = function()
            if vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree" then
              return { enabled = false }
            end
          end,
        },
        select = {
          format_item_override = {
            codeaction = function(action_tuple)
              local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
              local client = vim.lsp.get_client_by_id(action_tuple[1])
              return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
            end,
          },
        },
      }
    end,
  },
  {
    "liuchengxu/vista.vim",
    config = function()
      vim.g.vista_default_executive = "nvim_lsp"
      vim.g.vista_echo_cursor_strategy = "floating_win"
      vim.g.vista_floating_delay = 100
      vim.g.vista_cursor_delay = 200
      vim.g.vista_update_on_text_changed = 1
      vim.g.vista_update_on_text_changed_delay = 200
      vim.g.vista_sort = true
      vim.cmd [[
        " let g:vista_sidebar_width = 'vertical botright'
        " let g:vista_sidebar_position = 30
        " let g:vista_blink = [2, 100]
        " let g:vista_top_level_blink = [2, 100]
        " let g:vista_icon_indent = ['└ ', '│ ']
        " let g:vista_fold_toggle_icons = ['▼', '▶']
        " let g:vista_update_on_text_changed = 1
        " let g:vista_update_on_text_changed_delay = 200
        " let g:vista_echo_cursor = 0
        " let g:vista_echo_cursor_strategy = 'floating_win'
        " let g:vista_no_mappings = 0
        " let g:vista_stay_on_open = 1
        " let g:vista_close_on_jump = 0
        " let g:vista_close_on_fzf_select = 0
        " let g:vista_disable_statusline = exists('g:loaded_airline') || exists('g:loaded_lightline')
        " let g:vista_cursor_delay = 200
        " let g:vista_ignore_kinds = []
        " let g:vista_executive_for = {}
        " let g:vista_default_executive = 'nvim_lsp'
        " let g:vista_enable_centering_jump = 1
        " let g:vista_find_nearest_method_or_function_delay = 200
        " let g:vista_finder_alternative_executives = ['coc']
        " " Select the absolute nearest function when using binary search.
        " let g:vista_find_absolute_nearest_method_or_function = 0
        " let g:vista_fzf_preview = ['right:50%']
        " let g:vista_fzf_opt = []
        " let g:vista_keep_fzf_colors = 0
        " let g:vista_ctags_executable = 'ctags'
        " let g:vista_ctags_cmd = {}
        " let g:vista_highlight_whole_line = 0
        " let g:vista_floating_delay = 100
        " let g:vista#renderer#enable_icon = exists('g:vista#renderer#icons') || exists('g:airline_powerline_fonts')
        " let g:vista#renderer#enable_kind = !g:vista#renderer#enable_icon
        " let g:vista#renderer#icons = {}
        " let g:vista#renderer#ctags = 'default'
      ]]
      lvim.builtin.which_key.mappings.l.o = {
        "<cmd>SymbolsOutline<CR>",
        require("user.lsp_kind").symbols_outline.Module .. "Outline Symbols",
      }
      lvim.builtin.which_key.mappings.l.o = { "<cmd>Vista!!<CR>", "Outline Symbols" }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").on_attach()
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      local ok, notify = pcall(require, "nvim-notify")
      if ok then
        notify.setup {
          stages = "fade_in_slide_out",
          timeout = 3000,
          background_colour = "NormalFloat",
          render = function(...)
            local notif = select(2, ...)
            local style = notif.title[1] == "" and "minimal" or "default"
            require("notify.render")[style](...)
          end,
          min_width = function()
            return math.floor(vim.o.columns * 0.4)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.4)
          end,
          max_height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
        }
      end
    end,
  },
  {
    "gennaro-tedesco/nvim-peekup",
  },
  {
    "ggandor/leap.nvim",
    config = function()
      local status_ok, leap = pcall(require, "leap")
      if status_ok then
        leap.add_default_mappings()
      end
    end,
  },
  {
    "ggandor/leap-ast.nvim",
    config = function()
      lvim.builtin.which_key.mappings.s.l = {
        function()
          require("leap-ast").leap()
        end,
        "Leap w AST",
      }
      -- vim.keymap.set({ "n", "x", "o" }, "<leader>s",
      -- end, {})
    end,
  },
}

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_cursor_trail_length = 0.05
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_remember_window_size = true
  -- vim.g.neovide_cursor_vfx_mode = ''
  -- command -nargs=0 NeovideToggleFullscreen :let g:neovide_fullscreen = !g:neovide_fullscreen
  -- nnoremap <a-cr> :NeovideToggleFullscreen<cr>
  -- vim.o.guifont = "JetBrainsMono Nerd Font:h12"
  -- vim.o.guifont = "CaskaydiaCove Nerd Font:h14"
  vim.o.guifont = "FiraCode Nerd Font:h12"
  -- vim.o.guifont ="GoMono NF:h16"
  -- vim.o.guifont ="FuraCode NF:h16"
  -- vim.o.guifont ="Hack Nerd Font:h16"
  -- vim.o.guifont ="NotoSansMono Nerd Font:h16"
  -- vim.o.guifont ="SaucecodePro Nerd Font:h16"
  -- vim.o.guifont ="UbuntuMonoDerivativePowerline Nerd Font:h16"
  -- vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h12]]
  -- vim.api.nvim_set_keymap("n", "p", "<cmd>:put +<cr>Jk", { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "p", "<cmd>:set paste | put + | set nopaste<cr>Jk", { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "<s-p>", "<cmd>:put! +<cr>Jk", { noremap = true, silent = true })
  -- Ctrl-ScrollWheel for zooming in/out
  vim.api.nvim_set_keymap("n", "<C-ScrollWheelUp>", "<cmd>:set guifont=+<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-ScrollWheelDown>", "<cmd>:set guifont=-<CR>", { noremap = true, silent = true })
end

if vim.g.nvui then
  -- Configure nvui here
  vim.cmd [[NvuiCmdFontFamily FiraCode Nerd Font]]
  vim.cmd [[set linespace=1]]
  vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h14]]
  vim.cmd [[NvuiPopupMenuDefaultIconFg white]]
  vim.cmd [[NvuiCmdBg #1e2125]]
  vim.cmd [[NvuiCmdFg #abb2bf]]
  vim.cmd [[NvuiCmdBigFontScaleFactor 1.0]]
  vim.cmd [[NvuiCmdPadding 10]]
  vim.cmd [[NvuiCmdCenterXPos 0.5]]
  vim.cmd [[NvuiCmdTopPos 0.0]]
  vim.cmd [[NvuiCmdFontSize 20.0]]
  vim.cmd [[NvuiCmdBorderWidth 5]]
  vim.cmd [[NvuiPopupMenuIconFg variable #56b6c2]]
  vim.cmd [[NvuiPopupMenuIconFg function #c678dd]]
  vim.cmd [[NvuiPopupMenuIconFg method #c678dd]]
  vim.cmd [[NvuiPopupMenuIconFg field #d19a66]]
  vim.cmd [[NvuiPopupMenuIconFg property #d19a66]]
  vim.cmd [[NvuiPopupMenuIconFg module white]]
  vim.cmd [[NvuiPopupMenuIconFg struct #e5c07b]]
  vim.cmd [[NvuiCaretExtendTop 15]]
  vim.cmd [[NvuiCaretExtendBottom 8]]
  vim.cmd [[NvuiTitlebarFontSize 12]]
  vim.cmd [[NvuiTitlebarFontFamily Arial]]
  vim.cmd [[NvuiCursorAnimationDuration 0.1]]
  -- vim.cmd [[NvuiToggleFrameless]]
  vim.cmd [[NvuiOpacity 0.99]]
end

if vim.g.fvim_loaded then
  vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h14]]
  vim.cmd [[FVimCursorSmoothMove v:true]]
  vim.cmd [[FVimCursorSmoothBlink v:true]]
  vim.cmd [[FVimCustomTitleBar v:true ]]
  vim.cmd [[FVimFontAutoSnap v:true]]
  vim.cmd [[FVimUIPopupMenu v:true]]
  vim.cmd [[FVimUIWildMenu v:false]]
  vim.cmd [[FVimFontAntialias v:true]]
  vim.cmd [[FVimFontAutohint v:true]]
  vim.cmd [[FVimFontHintLevel 'full']]
  vim.cmd [[FVimFontLigature v:true]]
  vim.cmd [[FVimFontLineHeight '+1.0']]
  vim.cmd [[FVimFontSubpixel v:true]]
  vim.cmd [[FVimFontNoBuiltinSymbols v:true]]
  vim.cmd [[FVimKeyAltGr v:true]]
  -- Ctrl-ScrollWheel for zooming in/out
  -- nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  -- nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
  -- nnoremap <A-CR> :FVimToggleFullScreen<CR>
end

if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = {
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
end

require("user.autocommands").config()
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
