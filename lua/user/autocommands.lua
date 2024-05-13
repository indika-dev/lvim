local M = {}

local create_aucmd = vim.api.nvim_create_autocmd

M.config = function()
  pcall(function()
    vim.api.nvim_del_augroup_by_name "_last_status"
  end)
  vim.api.nvim_clear_autocmds { pattern = "lir", group = "_filetype_settings" }
  -- Autocommands
  if lvim.builtin.nonumber_unfocus then
    create_aucmd("WinEnter", { pattern = "*", command = "set relativenumber number cursorline" })
    create_aucmd("WinLeave", { pattern = "*", command = "set norelativenumber nonumber nocursorline" })
  end

  -- TODO: change this to lua
  vim.cmd [[
" disable syntax highlighting in big files
function! DisableSyntaxTreesitter()
    echo("Big file, disabling syntax, treesitter and folding")
    if exists(':TSBufDisable')
        exec 'TSBufDisable autotag'
        exec 'TSBufDisable highlight'
    endif

    set foldmethod=manual
    syntax clear
    syntax off
    filetype off
    set noundofile
    set noswapfile
    set noloadplugins
    set lazyredraw
endfunction

augroup BigFileDisable
    autocmd!
    autocmd BufReadPre,FileReadPre * if getfsize(expand("%")) > 1024 * 1024 | exec DisableSyntaxTreesitter() | endif
augroup END
  ]]
  create_aucmd("BufReadPost", {
    pattern = "*.md",
    command = "set syntax=markdown",
  })

  create_aucmd("TermOpen", {
    pattern = "term://*",
    command = "lua require('user.keybindings').set_terminal_keymaps()",
  })

  create_aucmd("CursorHold", {
    pattern = { "*.rs", "*.go", "*.ts", "*.tsx", "*.js", "*.lua" }, -- "*.java",
    command = "lua require('user.codelens').show_line_sign()",
  })

  create_aucmd({ "FileType" }, {
    pattern = {
      "Jaq",
      "qf",
      "help",
      "man",
      "lspinfo",
      "spectre_panel",
      "lir",
      "DressingSelect",
      "tsplayground",
      "Markdown",
    },
    callback = function()
      vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      nnoremap <silent> <buffer> <esc> :close<CR>
      set nobuflisted
    ]]
    end,
  })

  create_aucmd({ "FileType" }, {
    pattern = { "Jaq" },
    callback = function()
      vim.cmd [[
      nnoremap <silent> <buffer> <m-r> :close<CR>
      " nnoremap <silent> <buffer> <m-r> <NOP>
      set nobuflisted
    ]]
    end,
  })

  create_aucmd({ "BufEnter" }, {
    pattern = { "" },
    callback = function()
      local buf_ft = vim.bo.filetype
      if buf_ft == "" or buf_ft == nil then
        vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      nnoremap <silent> <buffer> <c-j> j<CR>
      nnoremap <silent> <buffer> <c-k> k<CR>
      set nobuflisted
    ]]
      end
    end,
  })

  create_aucmd({ "BufEnter" }, {
    pattern = { "" },
    callback = function()
      local get_project_dir = function()
        local cwd = vim.fn.getcwd()
        local project_dir = vim.split(cwd, "/")
        local project_name = project_dir[#project_dir]
        return project_name
      end

      vim.opt.titlestring = get_project_dir() .. " - nvim"
    end,
  })

  create_aucmd({ "BufEnter" }, {
    pattern = { "term://*" },
    callback = function()
      vim.cmd "startinsert!"
      -- TODO: if java = 2
      vim.cmd "set cmdheight=1"
    end,
  })

  create_aucmd({ "FileType" }, {
    pattern = { "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
      vim.cmd "set spelllang=de_20,en_us"
    end,
  })

  create_aucmd({ "VimResized" }, {
    callback = function()
      vim.cmd "tabdo wincmd ="
    end,
  })

  create_aucmd({ "CmdWinEnter" }, {
    callback = function()
      vim.cmd "quit"
    end,
  })

  create_aucmd({ "BufWinEnter" }, {
    callback = function()
      vim.cmd "set formatoptions-=cro"
    end,
  })

  create_aucmd({ "TextYankPost" }, {
    callback = function()
      vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
    end,
  })

  -- create_aucmd({ "BufWritePost" }, {
  --   pattern = { "*.java" },
  --   callback = function()
  --     vim.lsp.codelens.refresh()
  --   end,
  -- })

  create_aucmd({ "VimEnter" }, {
    callback = function()
      vim.cmd "hi link illuminatedWord LspReferenceText"
    end,
  })

  create_aucmd({ "BufWinEnter" }, {
    pattern = { "*" },
    callback = function()
      vim.cmd "checktime"
    end,
  })

  create_aucmd({ "CursorHold" }, {
    callback = function()
      local status_ok, luasnip = pcall(require, "luasnip")
      if not status_ok then
        return
      end
      if luasnip.expand_or_jumpable() then
        -- ask maintainer for option to make this silent
        -- luasnip.unlink_current()
        vim.cmd [[silent! lua require("luasnip").unlink_current()]]
      end
    end,
  })

  -- create_aucmd({ "BufWritePre" }, {
  --   pattern = { "*.java" },
  --   callback = function()
  --     require("jdtls").organize_imports()
  --   end,
  -- })

  -- create_aucmd({ "ModeChanged" }, {
  --   callback = function()
  --     local luasnip = require "luasnip"
  --     if luasnip.expand_or_jumpable() then
  --       -- ask maintainer for option to make this silent
  --       -- luasnip.unlink_current()
  --       vim.cmd [[silent! lua require("luasnip").unlink_current()]]
  --     end
  --   end,
  -- })

  create_aucmd({ "BufWritePre" }, {
    pattern = { "*.ts" },
    callback = function()
      vim.lsp.buf.format { async = false }
    end,
  })

  if lvim.builtin.inlay_hints.active then
    vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = { "*.java", "*.rs", "*.js", "*.ts" },
      group = "LspAttach_inlayhints",
      callback = function(args)
        if not (args.data and args.data.client_id) then
          return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
      end,
    })
  end
end

return M
