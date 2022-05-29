-- Neovim
-- =========================================
lvim.format_on_save = true
lvim.leader = "space"
lvim.colorscheme = "pablo"
lvim.debug = false
vim.lsp.set_log_level "warn"
lvim.log.level = "warn"
-- vim.o.conceallevel = 2 -- uncomment if you want to see concealed text
require("user.neovim").config()

-- Customization
-- =========================================
lvim.builtin.sell_your_soul_to_devil = { active = false, prada = false } -- if you want microsoft to abuse your soul
lvim.builtin.lastplace = { active = false } -- change to false if you are jumping to future
lvim.builtin.tabnine = { active = true } -- change to false if you don't like tabnine
lvim.builtin.persistence = { active = true } -- change to false if you don't want persistence
lvim.builtin.presence = { active = false } -- change to true if you want discord presence
lvim.builtin.orgmode = { active = false } -- change to true if you want orgmode.nvim
lvim.builtin.dap.active = false -- change this to enable/disable debugging
lvim.builtin.fancy_statusline = { active = true } -- enable/disable fancy statusline
lvim.builtin.fancy_wild_menu = { active = false } -- enable/disable cmp-cmdline
lvim.builtin.fancy_diff = { active = false } -- enable/disable fancier git diff
lvim.builtin.lua_dev = { active = true } -- change this to enable/disable folke/lua_dev
lvim.builtin.test_runner = { active = true } -- change this to enable/disable vim-test, ultest
lvim.builtin.cheat = { active = true } -- enable cheat.sh integration
lvim.builtin.sql_integration = { active = false } -- use sql integration
lvim.builtin.smooth_scroll = "cinnamon" -- for smoth scrolling, can be "cinnamon", "neoscroll" or ""
lvim.builtin.neoclip = { active = true, enable_persistent_history = false }
lvim.builtin.nonumber_unfocus = false -- diffrentiate between focused and non focused windows
lvim.builtin.custom_web_devicons = false -- install https://github.com/Nguyen-Hoang-Nam/mini-file-icons
lvim.builtin.harpoon = { active = true } -- use the harpoon plugin
lvim.builtin.remote_dev = { active = false } -- enable/disable remote development
lvim.builtin.cursorline = { active = false } -- use a bit fancier cursorline
lvim.builtin.motion_provider = "hop" -- change this to use different motion providers ( hop or lightspeed )
lvim.builtin.hlslens = { active = false } -- enable/disable hlslens
lvim.builtin.csv_support = false -- enable/disable csv support
lvim.builtin.sidebar = { active = false } -- enable/disable sidebar
lvim.builtin.async_tasks = { active = false } -- enable/disable async tasks
lvim.builtin.metals = {
  active = false, -- enable/disable nvim-metals for scala development
  fallbackScalaVersion = "2.13.7",
  serverVersion = "0.10.9+271-a8bb69f6-SNAPSHOT",
}
lvim.builtin.collaborative_editing = { active = false } -- enable/disable collaborative editing
lvim.builtin.file_browser = { active = false } -- enable/disable telescope file browser
lvim.builtin.sniprun = { active = false } -- enable/disable sniprun
lvim.builtin.tag_provider = "symbols-outline" -- change this to use different tag providers ( symbols-outline or vista )
lvim.builtin.editorconfig = { active = true } -- enable/disable editorconfig
lvim.builtin.global_statusline = false -- set true to use global statusline
lvim.builtin.dressing = { active = false } -- enable to override vim.ui.input and vim.ui.select with telescope
lvim.builtin.refactoring = { active = false } -- enable to use refactoring.nvim code_actions

lvim.lsp.diagnostics.virtual_text = false -- remove this line if you want to see inline errors
lvim.builtin.latex = {
  view_method = "skim", -- change to zathura if you are on linux
  preview_exec = "/Applications/Skim.app/Contents/SharedSupport/displayline", -- change this to zathura as well
  rtl_support = true, -- if you want to use xelatex, it's a bit slower but works very well for RTL langs
}
lvim.builtin.notify.active = true
lvim.lsp.automatic_servers_installation = false
if lvim.builtin.cursorline.active then
  lvim.lsp.document_highlight = false
end
lvim.lsp.code_lens_refresh = true

local user = os.getenv "USER"
if user and user == "stefan" then
  lvim.lsp.document_highlight = false
  lvim.builtin.csv_support = true
  lvim.builtin.async_tasks = { active = true } -- enable/disable async tasks
  lvim.builtin.dap.active = true
  lvim.builtin.sql_integration.active = true
  vim.g.instant_username = user
  lvim.builtin.file_browser.active = true
  lvim.builtin.global_statusline = true
  lvim.builtin.dressing.active = true
  lvim.builtin.refactoring.active = true
  lvim.builtin.fancy_statusline = { active = true } -- enable/disable fancy statusline
  lvim.lsp.diagnostics.virtual_text = true -- remove this line if you want to see inline errors
  -- require("lvim.lsp.manager").setup("prosemd_lsp", {})
  require("user.builtin").config()
end

-- Dashboard
-- =========================================i^
lvim.builtin.alpha.mode = "dashboard" -- "custom"
if lvim.builtin.alpha.mode == "custom" then
  local alpha_opts = require("user.dashboard").config()
  lvim.builtin.alpha["custom"] = { config = alpha_opts }
end

-- StatusLine
-- =========================================
-- if lvim.builtin.fancy_statusline.active then
local components = require "lvim.core.lualine.components"
-- lvim.builtin.lualine.style = "lvim"

local mode = function()
  local mod = vim.fn.mode()
  local _time = os.date "*t"
  local selector = math.floor(_time.hour / 8) + 1
  local normal_icons = {
    "  ",
    "  ",
    "  ",
  }
  if mod == "n" or mod == "no" or mod == "nov" then
    return normal_icons[selector]
  elseif mod == "i" or mod == "ic" or mod == "ix" then
    local insert_icons = {
      "  ",
      "  ",
      "  ",
    }
    return insert_icons[selector]
  elseif mod == "V" or mod == "v" or mod == "vs" or mod == "Vs" or mod == "cv" then
    local verbose_icons = {
      " 勇",
      "  ",
      "  ",
    }
    return verbose_icons[selector]
  elseif mod == "c" or mod == "ce" then
    local command_icons = {
      "  ",
      "  ",
      "  ",
    }

    return command_icons[selector]
  elseif mod == "r" or mod == "rm" or mod == "r?" or mod == "R" or mod == "Rc" or mod == "Rv" or mod == "Rv" then
    local replace_icons = {
      "  ",
      "  ",
      "  ",
    }
    return replace_icons[selector]
  end
  return normal_icons[selector]
end

local mode_map = {
  ["n"] = "NORMAL",
  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no�"] = "O-PENDING",
  ["niI"] = "NORMAL",
  ["niR"] = "NORMAL",
  ["niV"] = "NORMAL",
  ["nt"] = "NORMAL",
  ["v"] = "VISUAL",
  ["vs"] = "VISUAL",
  ["V"] = "V-LINE",
  ["Vs"] = "V-LINE",
  ["�"] = "V-BLOCK",
  ["�s"] = "V-BLOCK",
  ["s"] = "SELECT",
  ["S"] = "S-LINE",
  ["�"] = "S-BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rx"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rvc"] = "V-REPLACE",
  ["Rvx"] = "V-REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "EX",
  ["ce"] = "EX",
  ["r"] = "REPLACE",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}
lvim.builtin.lualine.sections.lualine_a = {
  function()
    return mode()
    -- return mode_map[vim.fn.mode()] or "__"
  end,
}
lvim.builtin.lualine.sections.lualine_y = {
  -- components.location,
  function()
    return require("user.lsp_kind").icons.clock .. os.date "%H:%M"
  end,
}
-- end

-- Debugging
-- =========================================
if lvim.builtin.dap.active then
  require("user.dap").config()
end

-- Language Specific
-- =========================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "clangd",
  "dockerls",
  "gopls",
  "jdtls",
  "pyright",
  "r_language_server",
  "rust_analyzer",
  "sumneko_lua",
  "taplo",
  "texlab",
  "tsserver",
  "yamlls",
})
require("user.null_ls").config()

-- Additional Plugins
-- =========================================
require("user.plugins").config()

-- Autocommands
-- =========================================
-- require("user.autocommands").config()

-- Additional keybindings
-- =========================================
-- require("user.keybindings").config()
