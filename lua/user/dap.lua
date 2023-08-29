local M = {}

M.config = function()
  local function sep_os_replacer(str)
    local result = str
    local path_sep = package.config:sub(1, 1)
    result = result:gsub("/", path_sep)
    return result
  end

  local join_path = require("lvim.utils").join_paths

  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end

  dap.configurations.java = {
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo init on special repo",
      args = "-r /home/maassens/workspace/architecture-management/test-init init",
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo pull 'SSO User Management' on special repo",
      args = '-r /home/maassens/workspace/architecture-management/test-init pull "SSO User Management"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo sync with init",
      args = '-r /home/maassens/workspace/architecture-management/test-repo -t sync \
      --init \
      -c /home/maassens/workspace/architecture-management/ts01_single.toml \
      -c /home/maassens/workspace/architecture-management/listeItSysteme.html \
      "TestSystem 01"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo sync Business Adapter CTA",
      args = '-r /home/maassens/workspace/architecture-management/test-repo -t sync \
      "Business Adapter CTA"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo pull TestSystem 01",
      args = '-r /home/maassens/workspace/architecture-management/test-repo -t pull "TestSystem 01"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo merge TestSystem 01",
      args = '-r /home/maassens/workspace/architecture-management/test-repo -t merge "TestSystem 01"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo add TestSystem 01",
      args = '-r /home/maassens/workspace/architecture-management/test-repo -t add "TestSystem 01"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo commit",
      args = '-r /home/maassens/workspace/architecture-management/test-repo -t commit "TestSystem 01"',
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo push",
      args = "-r /home/maassens/workspace/architecture-management/test-repo -t push",
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    {
      type = "java",
      request = "launch",
      name = "Debug Shoo status",
      args = "-r /home/maassens/workspace/architecture-management/test-repo -t status",
      vmargs = "-Xms2G -Xmx2G",
      mainClass = "de.creditreform.architecture.management.shoo.Shoo",
      projectName = "shoo",
      console = "integratedTerminal",
    },
    -- {
    --   type = "java",
    --   request = "attach",
    --   name = "Attach to CrateDB",
    --   hostName = "127.0.0.1",
    --   port = 5005,
    --   projectName = "app",
    -- },
    --   host = function()
    --     local value = vim.fn.input "Host [127.0.0.1]: "
    --     if value ~= "" then
    --       return value
    --     end
    --     return "127.0.0.1"
    --   end,
    --   port = function()
    --     local val = tonumber(vim.fn.input "Port: ")
    --     assert(val, "Please provide a port number")
    --     return val
    --   end,
    -- },
  }

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Neovim attach",
      host = function()
        local value = vim.fn.input "Host [127.0.0.1]: "
        if value ~= "" then
          return value
        end
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input "Port: ")
        assert(val, "Please provide a port number")
        return val
      end,
    },
  }

  dap.adapters.go = function(callback, _)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = { nil, stdout },
      args = { "dap", "-l", "127.0.0.1:" .. port },
      detached = true,
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end)
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
      callback { type = "server", host = "127.0.0.1", port = port }
    end, 100)
  end
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }

  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch flutter",
      dartSdkPath = sep_os_replacer(join_path(vim.fn.expand "~/", "/flutter/bin/cache/dart-sdk/")),
      flutterSdkPath = sep_os_replacer(join_path(vim.fn.expand "~/", "/flutter")),
      program = sep_os_replacer "${workspaceFolder}/lib/main.dart",
      cwd = "${workspaceFolder}",
    },
  }

  dap.adapters.firefox = {
    type = "executable",
    command = "node",
    args = {
      join_path(
        vim.fn.expand "~/",
        "/.vscode/extensions/firefox-devtools.vscode-firefox-debug-2.9.6/dist/adapter.bundle.js"
      ),
    },
  }

  local firefoxExecutable = "/usr/bin/firefox"
  if vim.fn.has "mac" == 1 then
    firefoxExecutable = "/Applications/Firefox.app/Contents/MacOS/firefox"
  end

  dap.configurations.typescript = {
    {
      type = "node2",
      name = "node attach",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
    },
    {
      type = "chrome",
      name = "chrome",
      request = "attach",
      program = "${file}",
      -- cwd = "${workspaceFolder}",
      -- protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}",
      -- sourceMaps = true,
      sourceMapPathOverrides = {
        -- Sourcemap override for nextjs
        ["webpack://_N_E/./*"] = "${webRoot}/*",
        ["webpack:///./*"] = "${webRoot}/*",
      },
    },
    {
      name = "Debug with Firefox",
      type = "firefox",
      request = "launch",
      reAttach = true,
      sourceMaps = true,
      url = "http://localhost:6969",
      webRoot = "${workspaceFolder}",
      firefoxExecutable = firefoxExecutable,
    },
  }

  dap.configurations.typescriptreact = dap.configurations.typescript
  dap.configurations.javascript = dap.configurations.typescript
  dap.configurations.javascriptreact = dap.configurations.typescript

  -- dap.adapters.codelldb = function(on_adapter)
  --   local stdout = vim.loop.new_pipe(false)
  --   local stderr = vim.loop.new_pipe(false)

  --   local cmd = vim.fn.expand "~/" .. ".local/lib/codelldb/extension/adapter/codelldb"

  --   local handle, pid_or_err
  --   local opts = {
  --     stdio = { nil, stdout, stderr },
  --     detached = true,
  --   }
  --   handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
  --     stdout:close()
  --     stderr:close()
  --     handle:close()
  --     if code ~= 0 then
  --       print("codelldb exited with code", code)
  --     end
  --   end)
  --   assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
  --   stdout:read_start(function(err, chunk)
  --     assert(not err, err)
  --     if chunk then
  --       local port = chunk:match "Listening on port (%d+)"
  --       if port then
  --         vim.schedule(function()
  --           on_adapter {
  --             type = "server",
  --             host = "127.0.0.1",
  --             port = port,
  --           }
  --         end)
  --       else
  --         vim.schedule(function()
  --           require("dap.repl").append(chunk)
  --         end)
  --       end
  --     end
  --   end)
  --   stderr:read_start(function(err, chunk)
  --     assert(not err, err)
  --     if chunk then
  --       vim.schedule(function()
  --         require("dap.repl").append(chunk)
  --       end)
  --     end
  --   end)
  -- end

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "rt_lldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = true,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = {
    {
      name = "Launch",
      type = "rt_lldb",
      request = "launch",
      cwd = "${workspaceFolder}",
      program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
      stopAtEntry = true,
    },
  }

  if lvim.custom.metals.active then
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "Run or Test Target",
        metals = {
          runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }
  end
  dap.configurations.python = dap.configurations.python or {}
  table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "launch with options",
    program = "${file}",
    python = function() end,
    pythonPath = function()
      local path
      for _, server in pairs(vim.lsp.get_active_clients()) do
        if server.name == "pyright" or server.name == "pylance" then
          path = vim.tbl_get(server, "config", "settings", "python", "pythonPath")
          break
        end
      end
      path = vim.fn.input("Python path: ", path or "", "file")
      return path ~= "" and vim.fn.expand(path) or nil
    end,
    args = function()
      local args = {}
      local i = 1
      while true do
        local arg = vim.fn.input("Argument [" .. i .. "]: ")
        if arg == "" then
          break
        end
        args[i] = arg
        i = i + 1
      end
      return args
    end,
    justMyCode = function()
      local yn = vim.fn.input "justMyCode? [y/n]: "
      if yn == "y" then
        return true
      end
      return false
    end,
    stopOnEntry = function()
      local yn = vim.fn.input "stopOnEntry? [y/n]: "
      if yn == "y" then
        return true
      end
      return false
    end,
    console = "integratedTerminal",
  })
  lvim.builtin.dap.on_config_done = function(_)
    lvim.builtin.which_key.mappings["d"].name = " Debug"
  end
end

return M
