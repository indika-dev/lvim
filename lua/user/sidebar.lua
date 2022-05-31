local M = {}

M.config = function()
  local status_ok, sidebar = pcall(require, "sidebar-nvim")
  if not status_ok then
    return
  end

  sidebar.setup {
    open = false,
    initial_width = 30,
    enable_profile = false,
    sections = { "todos", "git", "diagnostics", "containers" },
    datetime = {
      icon = "",
      format = "%a %b %d, %H:%M",
      clocks = {
        { name = "local" },
      },
    },
    todos = {
      icon = "",
      ignored_paths = { "~" }, -- ignore certain paths, this will prevent huge folders like $HOME to hog Neovim with TODO searching
      initially_closed = false, -- whether the groups should be initially closed on start. You can manually open/close groups later.
    },
    containers = {
      icon = "",
      use_podman = true,
      attach_shell = "/usr/bin/sh",
      show_all = true, -- whether to run `docker ps` or `docker ps -a`
      interval = 5000, -- the debouncer time frame to limit requests to the docker daemon
    },
  }
end

return M
