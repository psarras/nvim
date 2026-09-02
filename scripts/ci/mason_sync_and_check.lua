-- Run against a normal, fully-sourced init.lua (`nvim --headless --cmd
-- "luafile scripts/ci/pre_hook.lua" -c "luafile scripts/ci/mason_sync_and_check.lua"`).
--
-- 1. Makes sure every mason-managed LSP server / tool used by
--    after/plugin/lsp.lua is installed and up to date.
-- 2. Fails the build if starting nvim produced any error or warning
--    (via :messages or vim.notify).
--
-- Keep this list in sync with the `ensure_installed` tables in
-- after/plugin/lsp.lua.
local MASON_PACKAGES = {
  "omnisharp",
  "ols",
  "pyright",
  "pylsp",
  "powershell_es",
  "ltex_plus",
  "isort",
  "black",
}

local function fail(msg)
  io.stderr:write("[ci] " .. msg .. "\n")
  vim.cmd("cquit 1")
end

local function report_and_exit()
  local ok, exec = pcall(vim.api.nvim_exec2, "messages", { output = true })
  local messages = ok and (exec.output or "") or ""

  local problems = {}

  for _, entry in ipairs(_G.__ci_notifications or {}) do
    if entry.level and entry.level >= vim.log.levels.WARN then
      table.insert(problems, string.format("notify(%s): %s", vim.log.levels[entry.level] or entry.level, entry.msg))
    end
  end

  for line in messages:gmatch("[^\r\n]+") do
    if line:match("^E%d+:") or line:match("^Error") or line:match("Error executing") or line:match("Error detected while") then
      table.insert(problems, "message: " .. line)
    end
  end

  if #problems > 0 then
    io.stderr:write("[ci] nvim reported " .. #problems .. " problem(s) on startup:\n")
    for _, p in ipairs(problems) do
      io.stderr:write("  - " .. p .. "\n")
    end
    vim.cmd("cquit 1")
    return
  end

  print("[ci] nvim started cleanly with no errors or warnings")
  vim.cmd("quitall")
end

local function install_mason_packages()
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    fail("mason-registry is not available: " .. tostring(registry))
    return
  end

  registry.refresh(function()
    local pending = 0
    local had_error = false

    local function maybe_finish()
      if pending == 0 then
        if had_error then
          fail("one or more mason packages failed to install")
        else
          -- give VimEnter-triggered async setup (mason-tool-installer,
          -- lspconfig, etc.) a beat to finish emitting any notifications.
          vim.defer_fn(report_and_exit, 500)
        end
      end
    end

    for _, name in ipairs(MASON_PACKAGES) do
      if not registry.has_package(name) then
        had_error = true
        io.stderr:write("[ci] unknown mason package: " .. name .. "\n")
      else
        local pkg = registry.get_package(name)
        pending = pending + 1
        local handle = pkg:install()
        handle:once("closed", function()
          if not pkg:is_installed() then
            had_error = true
            io.stderr:write("[ci] failed to install/update " .. name .. "\n")
          else
            print("[ci] " .. name .. " is installed and up to date")
          end
          pending = pending - 1
          maybe_finish()
        end)
      end
    end

    maybe_finish()
  end)
end

local timed_out = false
vim.defer_fn(function()
  timed_out = true
  fail("mason sync / health check timed out")
end, 15 * 60 * 1000)

vim.defer_fn(function()
  if not timed_out then
    install_mason_packages()
  end
end, 200)
