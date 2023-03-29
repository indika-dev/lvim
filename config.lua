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
lvim.builtin.treesitter.auto_install = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.telescope.active = true
lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git/*",
  "target/*",
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
  "%.class",
  "%.jar",
}

local _time = os.date "*t"
if _time.hour >= 6 and _time.hour < 20 then
  -- lvim.colorscheme = "tokyonight-moon"
  lvim.colorscheme = "kanagawa"
else
  lvim.colorscheme = "kanagawa-dragon"
end
local user = vim.env.USER

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
  -- pcall(telescope.load_extension, "asynctasks")
  pcall(telescope.load_extension, "noice")
  -- pcall(telescope.load_extension, "project")
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
lvim.lsp.document_highlight = true
lvim.lsp.code_lens_refresh = true
lvim.lsp.installer.setup.automatic_installation = false
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
lvim.lsp.installer.setup.ensure_installed = {
  "rust_analyzer",
  "jdtls",
  "tsserver",
  "jsonls",
  "lua_ls",
  "bashls",
  "cssls",
  "dockerls",
  "eslint",
  "html",
  "pyright",
  "taplo",
  "vimls",
  "vuels",
  "yamlls",
  "marksman",
  "lemminx",
}
--
-- require("mason-lspconfig").setup {
--   automatic_installation = true,
--   ensure_installed = {
--     -- "jdtls",
--     "tsserver",
--     "jsonls",
--     "lua_ls",
--     "bashls",
--     "cssls",
--     "dockerls",
--     "eslint",
--     "html",
--     "pyright",
--     "taplo",
--     "vimls",
--     "vuels",
--     "yamlls",
--     "marksman",
--     "lemminx",
--   },
-- }
require("mason-lspconfig").setup_handlers {
  --   -- The first entry (without a key) will be the default handler
  --   -- and will be called for each installed server that doesn't have
  --   -- a dedicated handler.
  function(server_name) -- default handler (optional)
    if "jdtls" == server_name then
      require("lspconfig")[server_name].setup = function() end
    else
      require("lspconfig")[server_name].setup {}
    end
  end,
  --   -- Next, you can provide a dedicated handler for specific servers.
  --   -- For example, a handler override for the `rust_analyzer`:
  ["rust_analyzer"] = function()
    require("rust-tools").setup {}
  end,
}

-- Installer

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
  {
    name = "rustfmt",
    filetypes = { "rust" },
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
    command = "jsonlint",
    filetypes = { "json" },
  },
  {
    command = "eslint_d",
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  },
  -- {
  --   command = "markdownlint",
  --   filetypes = { "markdown" },
  -- },
}

lvim.custom = {
  metals = {
    active = false, -- enable/disable nvim-metals for scala development
    fallbackScalaVersion = "2.13.7",
    serverVersion = "0.10.9+271-a8bb69f6-SNAPSHOT",
  },
  async_tasks = {
    active = false,
  },
  jdtls = {
    initial_debug_search = false,
  },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  },
}

-- Debugging
-- =========================================
if lvim.builtin.dap.active then
  require("user.dap").config()
end

-- Additional Plugins
lvim.plugins = {
  {
    "Shatur/neovim-ayu",
    opts = {
      options = {
        theme = "ayu",
      },
    },
    config = function(_, opts)
      local status_ok, lualine = pcall(require, "lualine")
      if status_ok then
        lualine.setup(opts)
      end
    end,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   version = "*",
  --   config = function()
  --     vim.cmd [[colorscheme tokyonight-moon]]
  --   end,
  --   cond = function()
  --     local _time = os.date "*t"
  --     return (_time.hour >= 6 and _time.hour < 18)
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      overrides = function(colors)
        return {
          LspReferenceText = { fg = "NONE", bg = "NONE" },
          -- LspReferenceRead = { bg = "#49443c" },
          -- LspReferenceRead = { bg = "#A3D4D5", fg = "NONE" },
          LspReferenceWrite = { link = "LspReferenceRead" },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
    end,
    -- cond = function()
    --   local _time = os.date "*t"
    --   return ((_time.hour >= 18 and _time.hour < 24) or (_time.hour >= 0 and _time.hour < 6))
    -- end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
  },
  {
    "folke/trouble.nvim",
    version = "*",
    cmd = "TroubleToggle",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function(_, _)
      require("colorizer").setup()
    end,
  },
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function(_, _)
      vim.cmd [[
        let g:minimap_width = 10
        let g:minimap_auto_start = 0
        let g:minimap_auto_start_win_enter = 0
      ]]
    end,
    enabled = false,
  },
  {
    "skywind3000/asynctasks.vim",
    dependencies = { "skywind3000/asyncbuild.vim" },
    config = function(_, _)
      vim.cmd [[
          let g:asyncbuild_open = 8
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
        name = " build",
        f = { "<cmd>AsyncTask file-build<cr>", "File" },
        p = { "<cmd>AsyncTask project-build<cr>", "Project" },
      }
    end,
    enabled = lvim.custom.async_tasks.active,
  },
  {
    "GustavoKatel/telescope-asynctasks.nvim",
    enabled = lvim.custom.async_tasks.active,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "folke/zen-mode.nvim",
    version = "*",
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height
        width = 120, -- width of the Zen window
        height = 1, -- height of the Zen window
        -- by default, no options are changed for the Zen window
        -- uncomment any of the options below, or add other vim.wo options you want to apply
        options = {
          -- signcolumn = "no", -- disable signcolumn
          -- number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        kitty = {
          enabled = false,
          font = "+4", -- font size increment
        },
        -- this will change the font size on alacritty when in zen mode
        -- requires  Alacritty Version 0.10.0 or higher
        -- uses `alacritty msg` subcommand to change font size
        alacritty = {
          enabled = false,
          font = "14", -- font size
        },
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win) end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function() end,
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)
    end,
  },
  {
    "sidebar-nvim/sidebar.nvim",
    dependencies = { "sidebar-nvim/sections-dap" },
    config = function(_, _)
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
    opts = {},
    config = function(_, opts)
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
      require("refactoring").setup(opts)
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
    enabled = false,
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
    enabled = false,
  },
  {
    "dhruvasagar/vim-table-mode",
    commit = "9555a3e6e5bcf285ec181b7fc983eea90500feb4",
    enabled = false,
  },
  {
    "kevinhwang91/nvim-bqf",
    version = "*",
    event = { "BufRead", "BufNew" },
    opts = {
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
    },
    config = function(_, opts)
      require("bqf").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    -- event = "BufWinEnter",
    -- config = function()
    --   vim.cmd [[packadd telescope.nvim]]
    -- end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    opts = {
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = nil, -- Default easing function
      pre_hook = nil, -- Function to build before the scrolling animation starts
      post_hook = nil, -- Function to build after the scrolling animation ends
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
    end,
    cond = function()
      return not vim.g.neovide and not vim.g.nvui
    end,
  },
  {
    "folke/persistence.nvim",
    version = "*",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = true,
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = {
        "shellcheck",
        "shfmt",
        "prettier",
        "eslint_d",
        "fixjson",
      },
      automatic_installation = false,
      automatic_setup = true,
    },
    config = function(_, opts)
      require("mason-null-ls").setup(opts)
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "javadbg",
        "javatest",
      },
      automatic_installation = true,
      automatic_setup = true,
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    lazy = true,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true, -- show stop reason when stopped for exceptions
      commented = false, -- prefix virtual text with comment string
      only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
      all_references = false, -- show virtual text on all all references of the variable (not only definitions)
      --- A callback that determines how a variable is displayed or whether it should be omitted
      --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
      --- @param buf number
      --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
      --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
      --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
      display_callback = function(variable, _buf, _stackframe, _node)
        return variable.name .. " = " .. variable.value
      end,

      -- experimental features:
      virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
    },
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)
    end,
    enabled = lvim.builtin.dap.active,
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { { "tami5/sqlite.lua", module = "sqlite" } },
    opts = {
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
    },
    config = function(_, opts)
      require("neoclip").setup(opts)
    end,
  },
  -- {
  --   "~/workspace/luvcron/",
  -- },
  { "gpanders/editorconfig.nvim", version = "*" },
  {
    "stevearc/dressing.nvim",
    opts = {
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
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },
  {
    "liuchengxu/vista.vim",
    config = function(_, _)
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
        " let g:vista_cversions_executable = 'cversions'
        " let g:vista_cversions_cmd = {}
        " let g:vista_highlight_whole_line = 0
        " let g:vista_floating_delay = 100
        " let g:vista#renderer#enable_icon = exists('g:vista#renderer#icons') || exists('g:airline_powerline_fonts')
        " let g:vista#renderer#enable_kind = !g:vista#renderer#enable_icon
        " let g:vista#renderer#icons = {}
        " let g:vista#renderer#cversions = 'default'
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
    version = "*",
    event = "BufRead",
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
    enabled = false,
  },
  {
    "gennaro-tedesco/nvim-peekup",
    version = "*",
  },
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function(_, _)
      local status_ok, leap = pcall(require, "leap")
      if status_ok then
        leap.add_default_mappings()
      end
    end,
  },
  {
    "ggandor/leap-ast.nvim",
    config = function(_, _)
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
  {
    "ellisonleao/glow.nvim",
    ft = { "markdown" },
    opts = {
      border = "shadow", -- floating window border config
      style = "dark|light", -- filled automatically with your current editor background, you can override using glow json style
      pager = false,
      width = 80,
      height = 100,
      width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.7,
    },
    config = function(_, opts)
      local status_ok, glow = pcall(require, "glow")
      if status_ok then
        glow.setup(opts)
      end
    end,
  },
  {
    "fladson/vim-kitty",
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    config = function(_, _)
      local rt = require "rust-tools"
      rt.setup {
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    version = "*",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
    config = function(_, opts)
      require("chatgpt").setup(opts)
    end,
  },
  {
    "dense-analysis/neural",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "elpiloto/significant.nvim",
    },
    opts = {
      source = {
        openai = {
          api_key = vim.env.OPENAI_API_KEY,
        },
      },
    },
    config = function(_, opts)
      require("neural").setup(opts)
    end,
  },
  {
    "folke/noice.nvim",
    version = "*",
    config = function(_, _)
      require("user.noice").config()
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    cond = function()
      return not vim.g.neovide
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    },
    config = function(_, opts)
      require("nvim-lastplace").setup(opts)
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
  if "stefan" == user then
    vim.o.guifont = "FiraCode Nerd Font:h16"
  else
    vim.o.guifont = "FiraCode Nerd Font:h14"
  end
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
  if "stefan" == user then
    vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h16]]
  else
    vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h14]]
  end
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

require("user.autocommands").config()
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
