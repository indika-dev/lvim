-- general
lvim.log.level = "warn"
vim.opt.relativenumber = true
vim.opt.wrap = true -- wrap lines
if "stefan" == vim.env.USER then
  vim.opt.rtp:append "/usr/bin/fzf"
else
  vim.opt.rtp:append "/home/linuxbrew/.linuxbrew/opt/fzf"
end
vim.opt.termguicolors = true
vim.opt.wrap = true
lvim.format_on_save = true
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
lvim.builtin.dap.active = true
lvim.builtin.inlay_hints = { active = true }
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
  if "stefan" == vim.env.USER then
    lvim.colorscheme = "kanagawa-lotus"
  else
    lvim.colorscheme = "kanagawa"
  end
else
  lvim.colorscheme = "kanagawa-dragon"
end

vim.keymap.set("n", "T", function()
  vim.lsp.buf.hover()
end, { noremap = true, silent = true })
lvim.builtin.which_key.mappings.b.s = { "<cmd>Telescope buffers<cr>", "Open Bufferlist" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["L"].K = { "<cmd>Telescope commands<CR>", "View commands" }
lvim.builtin.which_key.mappings["L"].a = { "<cmd>Telescope autocommands<CR>", "View autocommands" }
lvim.builtin.which_key.mappings["R"] = { "<cmd>Telescope registers<CR>", " View registers" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnostics" },
}
if lvim.builtin.inlay_hints.active then
  lvim.builtin.which_key.mappings["I"] = { "<cmd>lua require('lsp-inlayhints').toggle()<cr>", " Toggle Inlay" }
end
lvim.builtin.which_key.mappings["R"] = { "<cmd>Telescope registers<cr>", " Show Registers" }

lvim.builtin.which_key.mappings["P"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

lvim.builtin.which_key.mappings["P"] = {
  name = " Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "dap")
  pcall(telescope.load_extension, "ui-select")
  pcall(telescope.load_extension, "neoclip")
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "refactoring")
  pcall(telescope.load_extension, "project")
end
vim.api.nvim_set_keymap("n", "g?", [[<Cmd>DiagWindowShow<CR>]], { noremap = true, silent = true })

-- generic LSP settings
vim.diagnostic.config { virtual_text = true }
lvim.lsp.document_highlight = true
lvim.lsp.code_lens_refresh = true
-- lvim.lsp.installer.setup.automatic_installation = true
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
  "clangd",
}

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  -- function(server_name) -- default handler (optional)
  --   if "jdtls" == server_name then
  --     require("lspconfig")[server_name].setup = function() end
  --     -- elseif "rust_analyzer" ~= server_name then
  --     --   require("lspconfig")[server_name].setup {}
  --   end
  -- end,
  ["jdtls"] = function() end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["rust_analyzer"] = function()
    local status_ok, rustTools = pcall(require, "rust-tools")
    if status_ok then
      local opts = {
        tools = { -- rust-tools options
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          -- on_attach = on_attach,
          settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
              inlayHints = {
                locationLinks = false,
              },
            },
          },
        },
      }
      rustTools.setup(opts)
    end
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
  --   command = "cmakelint",
  --   filetypes = { "cmake" },
  -- },
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
local dap_config = require "user.dap"
if lvim.builtin.dap.active then
  dap_config.config()
end

-- Additional Plugins
lvim.plugins = {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- Ensure it loads first
    opts = {
      -- overrides = function(colors)
      --   return {
      --     LspReferenceText = { fg = "NONE", bg = "NONE" },
      --     -- LspReferenceRead = { bg = "#49443c" },
      --     -- LspReferenceRead = { bg = "#A3D4D5", fg = "NONE" },
      --     LspReferenceWrite = { link = "LspReferenceRead" },
      --   }
      -- end,
      -- Block-like modern Telescope UI
      overrides = function(colors)
        local theme = colors.theme
        return {
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          -- More uniform colors for the popup menu.
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "MunifTanjim/nui.nvim" },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        -- Set to false to disable the vim.ui.input implementation
        enabled = true,

        -- Default prompt string
        default_prompt = "Input:",

        -- Can be 'left', 'right', or 'center'
        title_pos = "left",

        -- When true, <Esc> will close the modal
        insert_only = true,

        -- When true, input will start in insert mode.
        start_in_insert = true,

        -- These are passed to nvim_open_win
        border = "rounded",
        -- 'editor' and 'win' will default to being centered
        relative = "cursor",

        -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        prefer_width = 40,
        width = nil,
        -- min_width and max_width can be a list of mixed types.
        -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },

        buf_options = {},
        win_options = {
          -- Window transparency (0-100)
          winblend = 10,
          -- Disable line wrapping
          wrap = false,
          -- Indicator for when text exceeds window
          list = true,
          listchars = "precedes:…,extends:…",
          -- Increase this for more context when text scrolls off the window
          sidescrolloff = 0,
        },

        -- Set to `false` to disable
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<Up>"] = "HistoryPrev",
            ["<Down>"] = "HistoryNext",
          },
        },

        override = function(conf)
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          return conf
        end,

        -- see :help dressing_get_config
        get_config = nil,
      },
      select = {
        -- Set to false to disable the vim.ui.select implementation
        enabled = true,

        -- Priority list of preferred vim.select implementations
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

        -- Trim trailing `:` from prompt
        trim_prompt = true,

        -- Options for telescope selector
        -- These are passed into the telescope picker directly. Can be used like:
        -- telescope = require('telescope.themes').get_ivy({...})
        telescope = nil,

        -- Options for fzf selector
        fzf = {
          window = {
            width = 0.5,
            height = 0.4,
          },
        },

        -- Options for fzf-lua
        fzf_lua = {
          -- winopts = {
          --   height = 0.5,
          --   width = 0.5,
          -- },
        },

        -- Options for nui Menu
        nui = {
          position = "50%",
          size = nil,
          relative = "editor",
          border = {
            style = "rounded",
          },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = {
            winblend = 10,
          },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },

        -- Options for built-in selector
        builtin = {
          -- Display numbers for options and set up keymaps
          show_numbers = true,
          -- These are passed to nvim_open_win
          border = "rounded",
          -- 'editor' and 'win' will default to being centered
          relative = "editor",

          buf_options = {},
          win_options = {
            -- Window transparency (0-100)
            winblend = 10,
            cursorline = true,
            cursorlineopt = "both",
          },

          -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- the min_ and max_ options can be a list of mixed types.
          -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },

          -- Set to `false` to disable
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },

          override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
          end,
        },

        -- Used to override format_item. See :help dressing-format
        format_item_override = {},

        -- see :help dressing_get_config
        get_config = nil,
      },
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {
      { "css", "scss", "html", "javascript" },
      {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      },
    },
    config = function(_, _)
      require("colorizer").setup()
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "sidebar-nvim/sidebar.nvim",
    dependencies = { "sidebar-nvim/sections-dap" },
    opts = {
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
    },
    config = function(_, opts)
      lvim.builtin.which_key.mappings["S"] = {
        "<cmd>SidebarNvimToggle<CR>",
        require("user.lsp_kind").cmp_kind.Struct .. "Sidebar",
      }
      require("sidebar-nvim").setup(opts)
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
    event = "BufRead",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
      -- remap to open the Telescope refactoring menu in visual mode
      vim.api.nvim_set_keymap(
        "v",
        "<leader>rr",
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        { noremap = true }
      )
      -- prompt for a refactor to apply when the remap is triggered
      vim.api.nvim_set_keymap(
        "v",
        "<leader>rr",
        "<Cmd>lua require('refactoring').select_refactor()<CR>",
        { noremap = true, silent = true, expr = false }
      )
      require("refactoring").setup(opts)
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
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
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
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
    event = "VeryLazy",
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "ellisonleao/glow.nvim",
    ft = { "markdown" },
    cmd = "Glow",
    opts = {
      border = "shadow", -- floating window border config
      -- style = "dark|light", -- filled automatically with your current editor background, you can override using glow json style
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
    "niuiic/dap-utils.nvim",
    dependencies = {
      "niuiic/core.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
      require("dap-utils").setup(opts)
    end,
    opts = {
      -- filetype = function while returns dap config
      -- java = function(run)
      --   -- local core = require "core"
      --   run {
      --     {
      --       type = "java",
      --       request = "launch",
      --       name = "Debug Shoo init on special repo",
      --       cwd = "${workspaceFolder}/target/classes",
      --       runtimeArgs = "-r /home/maassens/workspace/architecture-management/test-init init",
      --       vmargs = "-Xms2G -Xmx2G",
      --       mainClass = "de.creditreform.architecture.management.shoo.ShooMain",
      --       projectName = "shoo",
      --       console = "integratedTerminal",
      --     },
      -- {
      --   name = "Launch cmd",
      --   type = "pwa-node",
      --   request = "launch",
      --   cwd = core.file.root_path(),
      --   runtimeExecutable = "pnpm",
      --   runtimeArgs = {
      --     "debug:cmd",
      --   },
      -- },
      -- {
      --   name = "Launch file",
      --   type = "pwa-node",
      --   request = "launch",
      --   program = "${file}",
      --   cwd = "${workspaceFolder}",
      -- },
      -- {
      --   name = "Attach",
      --   type = "pwa-node",
      --   request = "attach",
      --   processId = require("dap.utils").pick_process,
      --   cwd = "${workspaceFolder}",
      -- },
      -- }
      -- end,
      -- rust = function(run)
      --   -- nvim-dap start to work after call `run`
      --   -- the arguments of `run` is same to `dap.run`, see :h dap-api.
      --   local config = {
      --     -- `name` is required for config
      --     name = "Launch",
      --     type = "lldb",
      --     request = "launch",
      --     program = nil,
      --     cwd = "${workspaceFolder}",
      --     stopOnEntry = false,
      --     args = {},
      --   }
      --   local core = require "core"
      --   vim.cmd "!cargo build"
      --   local root_path = core.file.root_path()
      --   local target_dir = root_path .. "/target/debug/"
      --   if core.file.file_or_dir_exists(target_dir) then
      --     local executable = {}
      --     for path, path_type in vim.fs.dir(target_dir) do
      --       if path_type == "file" then
      --         local perm = vim.fn.getfperm(target_dir .. path)
      --         if string.match(perm, "x", 3) then
      --           table.insert(executable, path)
      --         end
      --       end
      --     end
      --     if #executable == 1 then
      --       config.program = target_dir .. executable[1]
      --       run(config)
      --     else
      --       vim.ui.select(executable, { prompt = "Select executable" }, function(choice)
      --         if not choice then
      --           return
      --         end
      --         config.program = target_dir .. choice
      --         run(config)
      --       end)
      --     end
      --   else
      --     vim.ui.input({ prompt = "Path to executable: ", default = root_path .. "/target/debug/" }, function(input)
      --       config.program = input
      --       run(config)
      --     end)
      --   end
      -- end,
      -- javascript = function(run)
      --   local core = require "core"
      --   run {
      --     {
      --       name = "Launch project",
      --       type = "pwa-node",
      --       request = "launch",
      --       cwd = "${workspaceFolder}",
      --       runtimeExecutable = "pnpm",
      --       runtimeArgs = {
      --         "debug",
      --       },
      --     },
      --     {
      --       name = "Launch cmd",
      --       type = "pwa-node",
      --       request = "launch",
      --       cwd = core.file.root_path(),
      --       runtimeExecutable = "pnpm",
      --       runtimeArgs = {
      --         "debug:cmd",
      --       },
      --     },
      --     {
      --       name = "Launch file",
      --       type = "pwa-node",
      --       request = "launch",
      --       program = "${file}",
      --       cwd = "${workspaceFolder}",
      --     },
      --     {
      --       name = "Attach",
      --       type = "pwa-node",
      --       request = "attach",
      --       processId = require("dap.utils").pick_process,
      --       cwd = "${workspaceFolder}",
      --     },
      --   }
      -- end,
    },
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    after = { "williamboman/mason.nvim" },
    opts = {
      tools = { -- rust-tools options

        -- how to execute terminal commands
        -- options right now: termopen / quickfix / toggleterm / vimux
        executor = pcall(function()
          local status_ok, executors = pcall(require, "rust-tools.executors")
          if not status_ok then
            return nil
          else
            return executors.termopen
          end
        end),
        -- callback to execute once rust-analyzer is done initializing the workspace
        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
        on_initialized = nil,

        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = true,
        runnables = {
          use_telescope = true,
        },

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
          -- automatically set inlay hints (type hints)
          -- default: true
          auto = false,

          -- Only show inlay hints for the current line
          only_current_line = false,

          -- whether to show parameter hints with the inlay hints or not
          -- default: true
          show_parameter_hints = true,

          -- prefix for parameter hints
          -- default: "<-"
          parameter_hints_prefix = "<- ",

          -- prefix for all the other hints (type, chaining)
          -- default: "=>"
          other_hints_prefix = "=> ",

          -- whether to align to the length of the longest line in the file
          max_len_align = false,

          -- padding from the left if max_len_align is true
          max_len_align_padding = 1,

          -- whether to align to the extreme right or not
          right_align = false,

          -- padding from the right if right_align is true
          right_align_padding = 7,

          -- The color of the hints
          highlight = "Comment",
        },

        -- options same as lsp hover / vim.lsp.util.open_floating_preview()
        hover_actions = {

          -- the border that is used for the hover window
          -- see vim.api.nvim_open_win()
          border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
          },

          -- Maximal width of the hover window. Nil means no max.
          max_width = nil,

          -- Maximal height of the hover window. Nil means no max.
          max_height = nil,

          -- whether the hover action window gets automatically focused
          -- default: false
          auto_focus = false,
        },

        -- settings for showing the crate graph based on graphviz and the dot
        -- command
        crate_graph = {
          -- Backend used for displaying the graph
          -- see: https://graphviz.org/docs/outputs/
          -- default: x11
          backend = "x11",
          -- where to store the output, nil for no output stored (relative
          -- path from pwd)
          -- default: nil
          output = nil,
          -- true for all crates.io and external crates, false only the local
          -- crates
          -- default: true
          full = true,

          -- List of backends found on: https://graphviz.org/docs/outputs/
          -- Is used for input validation and autocompletion
          -- Last updated: 2021-08-26
          enabled_graphviz_backends = {
            "bmp",
            "cgimage",
            "canon",
            "dot",
            "gv",
            "xdot",
            "xdot1.2",
            "xdot1.4",
            "eps",
            "exr",
            "fig",
            "gd",
            "gd2",
            "gif",
            "gtk",
            "ico",
            "cmap",
            "ismap",
            "imap",
            "cmapx",
            "imap_np",
            "cmapx_np",
            "jpg",
            "jpeg",
            "jpe",
            "jp2",
            "json",
            "json0",
            "dot_json",
            "xdot_json",
            "pdf",
            "pic",
            "pct",
            "pict",
            "plain",
            "plain-ext",
            "png",
            "pov",
            "ps",
            "ps2",
            "psd",
            "sgi",
            "svg",
            "svgz",
            "tga",
            "tiff",
            "tif",
            "tk",
            "vml",
            "vmlz",
            "wbmp",
            "webp",
            "xlib",
            "x11",
          },
        },
      },

      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
      server = {
        -- standalone file support
        -- setting it to false may improve startup time
        standalone = true,
        capabilities = require("lvim.lsp").common_capabilities(),
        settings = {
          ["rust-analyzer"] = {
            inlayHints = { locationLinks = false },
            lens = {
              enable = true,
            },
          },
        },
        on_init = require("lvim.lsp").common_on_init,
        on_attach = function(client, bufnr)
          require("lvim.lsp").common_on_attach(client, bufnr)
          local rt = require "rust-tools"
          -- Hover actions
          vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
          -- Code action groups
          vim.keymap.set("n", "<leader>lA", rt.code_action_group.code_action_group, { buffer = bufnr })
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

            -- local vopts = {
            --   mode = "v",
            --   prefix = "<leader>",
            --   buffer = vim.fn.bufnr(),
            --   silent = true,
            --   noremap = true,
            --   nowait = true,
            -- }

            local mappings = {
              r = {
                name = " Rust",
                a = { "<Cmd>lua require'rust-tools'.hover_actions.hover_actions(bufnr)<CR>", "Hover actions" },
                A = { "<Cmd>lua require'rust-tools'.code_action_group.code_action_group(bufnr)<CR>", "Code actions" },
                c = { "<Cmd>lua require'rust-tools'.open_cargo_toml.open_cargo_toml()<CR>", "Open Cargo.toml" },
                t = { "<Cmd>lua require'rust-tools'.hover_range.hover_range()<CR>", "Show type" },
                g = {
                  "<Cmd>lua require'rust-tools'.crate_graph.view_crate_graph('x11', nil)()<CR>",
                  "Show Crate graph",
                },
                S = {
                  "<Cmd>lua require'rust-tools'.crate_graph.view_crate_graph('svg', 'crategraph.svg')()<CR>",
                  "Save Crate graph",
                },
                u = { "<Cmd>lua require'rust-tools'.move_item.move_item(true)<CR>", "Move Item up" },
                d = { "<Cmd>lua require'rust-tools'.move_item.move_item(false)<CR>", "Move Item down" },
                p = { "<Cmd>lua require'rust-tools'.parent_module.parent_module()<CR>", "Go to Parent Module" },
                f = { "<Cmd>lua require'rust-tools'.join_lines.join_lines()<CR>", "Join lines" },
                r = { "<Cmd>lua require'rust-tools'.expand_macro.expand_macro()<CR>", "Expand Macro recursivly" },
                D = { "<Cmd>RustDebuggables<CR>", "Start Debug" },
                s = { "<Cmd>require'rust-tools'.ssr.ssr()<CR>", "Structural Search Replace" },
              },
            }

            -- local vmappings = {
            --   r = {
            --     name = " Rust",
            --     v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
            --     c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
            --     m = { "<Esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>", "Extract Method" },
            --   },
            -- }

            which_key.register(mappings, nopts)
            -- which_key.register(vmappings, vopts)
          end
        end,
      }, -- rust-analyzer options
      -- debugging stuff
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
          vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/codelldb",
          vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
        ),
      },
    },
    config = function(_, opts)
      require("rust-tools").setup(opts)
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
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      -- "preservim/vim-markdown",
      -- "godlygeek/tabular",
    },
    opts = function()
      local options = {
        completion = {
          nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
        },
        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,
        templates = {
          date_format = "%Y-%m-%d-%a",
          time_format = "%H:%M",
        },
        note_frontmatter_func = function(note)
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
        use_advanced_uri = false,
      }
      if "stefan" == vim.env.USER then
        options.dir = vim.env.HOME .. "/Dokumente/obsidian/my-vault"
        options.templates.subdir = "my-templates-folder"
      else
        options.dir = vim.env.HOME .. "/Dokumente/obsidian-vault/Makroarchitektur"
        options.templates.subdir = "Templates"
      end
      return options
    end,
    config = function(_, opts)
      require("obsidian").setup(opts)
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "markdown", "markdown_inline" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
        },
      }
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = {},
    build = "./kitty/install-kittens.bash",
    enabled = not vim.g.neovide,
    opts = {
      -- Ignored filetypes (only while resizing)
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
      },
      -- Ignored buffer types (only while resizing)
      ignored_buftypes = { "NvimTree" },
      -- the default number of lines/columns to resize by at a time
      default_amount = 3,
      -- whether to wrap to opposite side when cursor is at an edge
      -- e.g. by default, moving left at the left edge will jump
      -- to the rightmost window, and vice versa, same for up/down.
      at_edge = "wrap",
      -- when moving cursor between splits left or right,
      -- place the cursor on the same row of the *screen*
      -- regardless of line numbers. False by default.
      -- Can be overridden via function parameter, see Usage.
      move_cursor_same_row = false,
      -- whether the cursor should follow the buffer when swapping
      -- buffers by default; it can also be controlled by passing
      -- `{ move_cursor = true }` or `{ move_cursor = false }`
      -- when calling the Lua function.
      cursor_follows_swapped_bufs = false,
      -- resize mode options
      resize_mode = {
        -- key to exit persistent resize mode
        quit_key = "<ESC>",
        -- keys to use for moving in resize mode
        -- in order of left, down, up' right
        resize_keys = { "h", "j", "k", "l" },
        -- set to true to silence the notifications
        -- when entering/exiting persistent resize mode
        silent = false,
        -- must be functions, they will be executed when
        -- entering or exiting the resize mode
        hooks = {
          on_enter = nil,
          on_leave = nil,
        },
      },
      -- ignore these autocmd events (via :h eventignore) while processing
      -- smart-splits.nvim computations, which involve visiting different
      -- buffers and windows. These events will be ignored during processing,
      -- and un-ignored on completed. This only applies to resize events,
      -- not cursor movement events.
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
      -- enable or disable a multiplexer integration;
      -- automatically determined, unless explicitly disabled or set,
      -- by checking the $TERM_PROGRAM environment variable,
      -- and the $KITTY_LISTEN_ON environment variable for Kitty
      multiplexer_integration = nil,
      -- disable multiplexer navigation if current multiplexer pane is zoomed
      -- this functionality is only supported on tmux and Wezterm due to kitty
      -- not having a way to check if a pane is zoomed
      disable_multiplexer_nav_when_zoomed = true,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
      -- swapping buffers between windows
      vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
      vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
      vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
      vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    ft = { "java", "javascript", "javascriptreact", "typescript", "typescriptreact", "rust" },
    config = function()
      require("lsp-inlayhints").setup()
    end,
    -- enabled = lvim.builtin.inlay_hints.active,
  },
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- This keeps it pinned to semantic releases
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      -- This would be an optional dependency eventually
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      -- Configuration for SSH connections made using this plugin
      ssh_config = {
        -- Binary with this name would be searched on your runtime path and would be
        -- used to run SSH commands. Rename this if your SSH binary is something else
        ssh_binary = "ssh",
        -- Similar to `ssh_binary`, but for copying over files onto remote server
        scp_binary = "scp",
        -- All your SSH config file paths.
        ssh_config_file_paths = { "$HOME/.ssh/config" },
        -- This helps the plugin to understand when the underlying binary expects
        -- input from user. This is useful for password-based authentication and
        -- key-based authentication.
        -- Explanation for each prompt:
        -- match - string - This would be matched with the SSH output to decide if
        -- SSH is waiting for input. This is a plain match (not a regex one)
        -- type - string - Takes two values "secret" or "plain". "secret" indicates
        -- that the value you would enter is a secret and should not be logged into
        -- your input history
        -- input_prompt - string - What is the input prompt that should be shown to
        -- user when this match happens
        -- value_type - string - Takes two values "static" and "dynamic". "static"
        -- means that the value can be cached for the same prompt for future commands
        -- (e.g. your password) so that you do not have to keep typing it again and
        -- again. This is retained in-memory and is not logged anywhere. When you
        -- close the editor, it is cleared from memory. "dynamic" is for something
        -- like MFA codes which change every time.
        ssh_prompts = {
          {
            match = "password:",
            type = "secret",
            input_prompt = "Enter password: ",
            value_type = "static",
            value = "",
          },
          {
            match = "continue connecting (yes/no/[fingerprint])?",
            type = "plain",
            input_prompt = "Do you want to continue connection (yes/no)? ",
            value_type = "static",
            value = "",
          },
        },
      },
      -- Installation script location on local machine (If you have your own custom
      -- installation script and you do not want to use the packaged install script.
      -- It should accept the same inputs as the packaged install script though)
      neovim_install_script_path = vim.fn.stdpath "config"
        .. package.config:sub(1, 1)
        .. "scripts"
        .. package.config:sub(1, 1)
        .. "neovim_install.sh",
      -- Where is your personal Neovim config stored?
      neovim_user_config_path = vim.fn.stdpath "config",
      local_client_config = {
        -- modify this function to override how your client launches
        -- function should accept two arguments function(local_port, workspace_config)
        -- local_port is the port on which the remote server is available locally
        -- workspace_config contains the workspace config. For all attributes present
        -- in it, see WorkspaceConfig in ./lua/remote-nvim/config.lua.
        -- See examples of callback in https://github.com/amitds1997/remote-nvim.nvim/wiki/Configuration-recipes
        callback = nil,
        -- [Subject to change]: These values may be subject to change, so there
        -- might be a breaking change. Right now, it uses the [plenary.nvim#win_float.percentage_range_window](https://github.com/nvim-lua/plenary.nvim/blob/267282a9ce242bbb0c5dc31445b6d353bed978bb/lua/plenary/window/float.lua#L138C25-L138C25)
        default_client_config = {
          col_percent = 0.9,
          row_percent = 0.9,
          win_opts = {
            winblend = 0,
          },
          border_opts = {
            topleft = "╭",
            topright = "╮",
            top = "─",
            left = "│",
            right = "│",
            botleft = "╰",
            botright = "╯",
            bot = "─",
          },
        },
      },
    },
    config = true, -- This calls the default setup(); make sure to call it
  },
  {
    "cseickel/diagnostic-window.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
  },
}

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_cursor_trail_size = 0.05
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_unfocused_outline_width = 0.125
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_fullscreen = false
  vim.g.neovide_profiler = false
  -- vim.g.neovide_cursor_vfx_mode = ''
  -- command -nargs=0 NeovideToggleFullscreen :let g:neovide_fullscreen = !g:neovide_fullscreen
  -- nnoremap <a-cr> :NeovideToggleFullscreen<cr>
  -- vim.o.guifont = "JetBrainsMono Nerd Font:h12"
  -- vim.o.guifont = "CaskaydiaCove Nerd Font:h14"
  if "stefan" == vim.env.USER then
    vim.o.guifont = "FiraCode Nerd Font Mono:h16"
  else
    vim.o.guifont = "FiraCode Nerd Font Mono:h14"
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
  if "stefan" == vim.env.USER then
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
  if "stefan" == vim.env.USER then
    vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h18]]
  else
    vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h14]]
  end

  -- Toggle between normal and fullscreen
  -- vim.cmd [[FVimToggleFullScreen]]

  -- Cursor tweaks
  vim.cmd [[FVimCursorSmoothMove v:true]]
  vim.cmd [[FVimCursorSmoothBlink v:true]]
  -- Background composition
  -- vim.cmd [[FVimBackgroundComposition 'acrylic']]   -- 'none', 'transparent', 'blur' or 'acrylic'
  -- vim.cmd [[FVimBackgroundOpacity 0.85]]            -- value between 0 and 1, default bg opacity.
  -- vim.cmd [[FVimBackgroundAltOpacity 0.85]]         -- value between 0 and 1, non-default bg opacity.
  -- vim.cmd [[FVimBackgroundImage 'C:/foobar.png']]   -- background image
  -- vim.cmd [[FVimBackgroundImageVAlign 'center']]    -- vertial position, 'top', 'center' or 'bottom'
  -- vim.cmd [[FVimBackgroundImageHAlign 'center']]    -- horizontal position, 'left', 'center' or 'right'
  -- vim.cmd [[FVimBackgroundImageStretch 'fill']]     -- 'none', 'fill', 'uniform', 'uniformfill'
  -- vim.cmd [[FVimBackgroundImageOpacity 0.85]]       -- value between 0 and 1, bg image opacity
  -- Title bar tweaks
  -- vim.cmd [[FVimCustomTitleBar v:true ]]
  -- Debug UI overlay
  -- vim.cmd [[FVimDrawFPS v:true]]

  -- Font weight tuning, possible valuaes are 100..900
  vim.cmd [[FVimFontNormalWeight 400]]
  vim.cmd [[FVimFontBoldWeight 700]]
  -- UI options (all default to v:false)
  vim.cmd [[FVimUIPopupMenu v:true]]
  vim.cmd [[FVimUIWildMenu v:false]]
  -- Font tweaks
  vim.cmd [[FVimFontAntialias v:true]]
  vim.cmd [[FVimFontAutohint v:true]]
  vim.cmd [[FVimFontHintLevel 'full']]
  vim.cmd [[FVimFontLigature v:true]]
  vim.cmd [[FVimFontLineHeight '+1.0']]
  vim.cmd [[FVimFontSubpixel v:true]]
  vim.cmd [[FVimFontNoBuiltinSymbols v:true]]
  -- Try to snap the fonts to the pixels, reduces blur
  -- in some situations (e.g. 100% DPI).
  vim.cmd [[FVimFontAutoSnap v:true]]

  -- Keyboard mapping options
  vim.cmd [[FVimKeyDisableShiftSpace v:true]] -- disable unsupported sequence <S-Space>
  vim.cmd [[FVimKeyAutoIme v:true]] -- Automatic input method engagement in Insert mode
  vim.cmd [[FVimKeyAltGr v:true]] -- Recognize AltGr. Side effect is that <C-A-Key> is then impossible

  --   Default options (workspace-agnostic)
  vim.cmd [[FVimDefaultWindowWidth 1600]] -- Default window size in a new workspace
  vim.cmd [[FVimDefaultWindowHeight 900]]

  -- Detach from a remote session without killing the server
  -- If this command is executed on a standalone instance,
  -- the embedded process will be terminated anyway.
  -- vim.cmd [[FVimDetach]]

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
