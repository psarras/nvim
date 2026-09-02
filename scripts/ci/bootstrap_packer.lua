-- Installs/updates every plugin declared in lua/stam/packer.lua without
-- going through init.lua (which requires plugins that don't exist yet on a
-- clean checkout). Run with `nvim --headless -u NONE`.

vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim")

-- Some plugin `config` callbacks (colorizer, catppuccin's colorscheme
-- apply, ...) run as part of packer's compile step and assume this is
-- already set, the way it normally would be by lua/stam/set.lua in a real
-- launch.
vim.opt.termguicolors = true

local ok, err = pcall(function()
  require("stam.packer")
end)

if not ok then
  io.stderr:write("[ci] failed to load packer spec: " .. tostring(err) .. "\n")
  vim.cmd("cquit 1")
  return
end

local timed_out = false
vim.defer_fn(function()
  timed_out = true
  io.stderr:write("[ci] PackerSync timed out\n")
  vim.cmd("cquit 1")
end, 10 * 60 * 1000)

vim.api.nvim_create_autocmd("User", {
  pattern = "PackerComplete",
  once = true,
  callback = function()
    if timed_out then
      return
    end
    print("[ci] PackerSync complete")
    vim.cmd("quitall")
  end,
})

vim.cmd("PackerSync")
