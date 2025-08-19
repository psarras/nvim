oil = require("oil")



local oil = require("oil")
local actions = require("oil.actions")

-- optional: vsplits open to the right
vim.opt.splitright = true

local function select_vsplit_and_close()
  -- remember the Oil window, then vsplit, then close that window
  local oil_win = vim.api.nvim_get_current_win()
  actions.select_vsplit.callback()
  if vim.api.nvim_win_is_valid(oil_win) then
    vim.api.nvim_win_close(oil_win, true)
  end
end

oil.setup({
  default_file_explorer = false,
  keymaps = {
    ["<CR>"] = "actions.select",          -- open in current buffer
    ["<C-v>"] = select_vsplit_and_close,  -- vsplit + close Oil
    ["<C-t>"] = "actions.select_tab",
  },
  view_options = { show_hidden = true },
})

-- local function select_vsplit_and_close()
--     oil.actions.select_vsplit.callback()   -- run the builtin vsplit open
--     toggle_oil_sidebar(30)                 -- close the oil sidebar
-- end
--
local function toggle_oil_sidebar(width)
  width = width or 30
  -- If an Oil window exists, close it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft == "oil" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  -- Otherwise open a left sidebar with given width
  vim.cmd("topleft vsplit")
  vim.cmd("vertical resize " .. width)
  require("oil").open()
end


vim.keymap.set("n", "<leader>x", function() toggle_oil_sidebar(30) end, { noremap = true, silent = true })

