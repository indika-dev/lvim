--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- set fonts for GUIs
-- vim.o.guifont = "JetBrainsMono NF:h14"
-- vim.o.guifont = "CaskaydiaCove NF:h12"

-- configure auto-session plugin
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
local _time = os.date "*t"
if (_time.hour >= 1 and _time.hour < 9) then
  lvim.colorscheme = "rose-pine"
elseif (_time.hour >= 9 and _time.hour < 21) then
  lvim.colorscheme = "ayu-mirage"
else
  lvim.colorscheme = "kanagawa"
end
vim.opt.relativenumber = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
-- end

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- lvim.builtin.dashboard.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.treesitter.rainbow.enable = false

-- if you don't want all the parsers change this to a table of the ones you want
-- lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- set a formatter if you want to override the default lsp one (if it exists)
-- lvim.lang.python.formatters = {
--   {
--     exe = "black",
--   }
-- }
-- set an additional linter
-- lvim.lang.python.linters = {
--   {
--     exe = "flake8",
--   }
-- }
lvim.format_on_save = true
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    command = "stylua",
    filetypes = { "lua" },
  },
  {
    command = "uncrustify",
    filetypes = { "java" },
  },
  { command = "shfmt", filetypes = { "sh" } },
  -- { command = "yamlfmt", args = { "/dev/stdin" }, filetypes = { "yaml", "yml" } },
  {
    command = "prettier",
    filetypes = {
      "html",
      "json",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "yaml",
      "yml",
    },
  },
  -- {
  -- 	command = "eslint",
  -- 	args = { "--fix" },
  -- 	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  -- },
  -- {
  -- 	name = "standardjs",
  -- 	args = { "--fix" },
  -- filetypes = { "javascript", "javascriptreact" },
  -- , "typescript", "typescriptreact" },
  -- },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
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
    command = "eslint",
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    name = "semgrep",
    args = {
      "--config",
      "/home/stefan/workspace/semgrep-rules/java/lang/correctness/",
      "--config",
      "/home/stefan/workspace/semgrep-rules/java/lang/security/",
      "--config",
      "/home/stefan/workspace/semgrep-rules/java/log4j/security/",
    },
    filetypes = { "java" },
  },
})

-- Debugging
-- =========================================
if lvim.builtin.dap.active then
  lvim.custom = {
    metals = {
      active = false, -- enable/disable nvim-metals for scala development
      fallbackScalaVersion = "2.13.7",
      serverVersion = "0.10.9+271-a8bb69f6-SNAPSHOT",
    }
  }
  require("user.dap").config()
end

local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
  {
    name = "proselint",
  },
})

-- Additional Plugins
lvim.plugins = {
  {
    "rose-pine/neovim",
    as = "rose-pine",
    tag = "v1.*",
  },
  {
    "Shatur/neovim-ayu",
    config = function()
      require("ayu").setup {
        mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
      }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup {
        undercurl = true, -- enable undercurls
        commentStyle = "NONE",
        functionStyle = "NONE",
        keywordStyle = "italic",
        statementStyle = "italic",
        typeStyle = "NONE",
        variablebuiltinStyle = "italic",
        specialReturn = true, -- special highlight for the return keyword
        specialException = true, -- special highlight for exception handling keywords
        dimInactive = lvim.builtin.global_statusline, -- dim inactive window `:h hl-NormalNC`
        globalStatus = lvim.builtin.global_statusline, -- adjust window separators highlight for laststatus=3
        transparent = lvim.transparent_window,
        colors = { sumiInk1b = "#1b1b23" },
        overrides = {
          diffRemoved = { fg = "#E46876" },
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "ChristianChiarulli/nvcode-color-schemes.vim",
    opt = true,
    config = function()
      vim.g.nvcode_termcolors = 256
    end,
  },
  {
    "kaicataldo/material.vim",
    opt = true,
    config = function()
      vim.g.material_branch = "main"
      vim.g.material_theme_style = "default-community" -- deafualt,palenight, ocean, lighter, darker, default-community
    end,
  },
  {
    "wfxr/minimap.vim",
    run = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 0")
      vim.cmd("let g:minimap_auto_start_win_enter = 0")
    end,
  },
  -- {
  -- 	"sindrets/diffview.nvim",
  -- 	event = "BufRead",
  -- },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
  },
  {
    "dhruvasagar/vim-table-mode",
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
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
      })
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    setup = function()
      vim.cmd([[packadd telescope.nvim]])
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup({
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
      })
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })
    end,
  },
  { "sindrets/diffview.nvim", event = "BufRead", },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
    ft = { "python", "rust", "go" },
    event = "BufReadPost",
    requires = { "mfussenegger/nvim-dap" },
    disable = not lvim.builtin.dap.active,
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
  vim.o.guifont = "FiraCode NF:h12"
  -- vim.o.guifont ="GoMono NF:h16"
  -- vim.o.guifont ="FuraCode NF:h16"
  -- vim.o.guifont ="Hack Nerd Font:h16"
  -- vim.o.guifont ="NotoSansMono Nerd Font:h16"
  -- vim.o.guifont ="SaucecodePro Nerd Font:h16"
  -- vim.o.guifont ="UbuntuMonoDerivativePowerline Nerd Font:h16"
  -- vim.cmd [[set guifont=FiraCode\ Nerd\ Font:h14]]
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


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

-- vim.cmd("source ~/.vimrc")
