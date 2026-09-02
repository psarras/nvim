-- Loaded via `--cmd` (i.e. before init.lua / any plugin runs) so it can see
-- every vim.notify call the config and its plugins make during startup.
_G.__ci_notifications = {}

local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  table.insert(_G.__ci_notifications, { msg = msg, level = level or vim.log.levels.INFO })
  return orig_notify(msg, level, opts)
end
