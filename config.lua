--[[
lvim is the global options object
]]

-- general
lvim.log.level = "warn"
vim.opt.relativenumber = true
lvim.format_on_save = true
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
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
if _time.hour >= 6 and _time.hour < 21 then
  lvim.colorscheme = "github_dark"
else
  lvim.colorscheme = "kanagawa"
end

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
lvim.builtin.dap.on_config_done = function(dap)
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
end

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
    -- currently not working...see later again when a higher mason version arrives
    -- "java-test",
    -- "java-debug-adapter",
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
  { "folke/tokyonight.nvim" },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup {
        overrides = {
          LspReferenceText = { fg = "NONE", bg = "NONE" },
          LspReferenceRead = { bg = "#49443c" },
          -- LspReferenceRead = { bg = "#A3D4D5", fg = "NONE" },
          LspReferenceWrite = { link = "LspReferenceRead" },
        },
      }
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup {
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
    end,
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
  },
  {
    "rcarriga/nvim-dap-ui",
    ft = { "python", "rust", "go", "java" },
    after = "nvim-dap",
    config = function()
      local dapui = require "dapui"
      dapui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has "nvim-0.7",
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        },
      }
      local dap = require "dap"
      dap.listeners.after["event_initialized"]["dapui_config"] = function(session, body)
        dapui.open()
      end
      dap.listeners.before["event_terminated"]["dapui_config"] = function(session, body)
        dapui.close()
      end
      dap.listeners.before["event_exited"]["dapui_config"] = function(session, body)
        dapui.close()
      end
    end,
    event = "BufReadPost",
    disable = not lvim.builtin.dap.active,
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
    "matbme/JABS.nvim",
    config = function()
      require("jabs").setup {
        position = "center",
        width = 50,
        height = 10,
        border = "rounded",
        preview_position = "top",
        preview = {
          width = 70,
          height = 20,
          border = "rounded",
        },
      }
      lvim.builtin.which_key.mappings.b.s = { "<cmd>JABSOpen<cr>", "Open Bufferlist" }
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      lvim.builtin.which_key.mappings.l.o = {
        "<cmd>SymbolsOutline<CR>",
        require("user.lsp_kind").symbols_outline.Module .. "Outline Symbols",
      }
      lvim.builtin.which_key.mappings.l.o = { "<cmd>SymbolsOutline<CR>", "Outline Symbols" }
    end,
  },
  {
    "jayp0521/mason-null-ls.nvim",
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
        },
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

-- fallback configuration, if JABS is not working
local status_ok, _ = pcall(require, "jabs")
if not status_ok then
  lvim.builtin.which_key.mappings.b.s = { "<cmd>Telescope buffers<cr>", "Open Bufferlist" }
end

require("user.autocommands").config()
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
