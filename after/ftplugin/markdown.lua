local md_float = nil
local md_bg = nil


vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.md",
  callback = function()
    print("Markdown buffer entered")

    vim.opt_local.colorcolumn = ""
    
    -- Navigate by visual lines instead of actual lines
    vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
    vim.keymap.set("v", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("v", "k", "gk", { buffer = true, silent = true })
  end,
})

local function close_md_float()
  if md_float and vim.api.nvim_win_is_valid(md_float) then
    vim.api.nvim_win_close(md_float, true)
  end
  if md_bg and vim.api.nvim_win_is_valid(md_bg) then
    vim.api.nvim_win_close(md_bg, true)
  end
  md_float = nil
  md_bg = nil
end

vim.keymap.set("n", "<leader>mw", function()

  -- toggle off
  if md_float and vim.api.nvim_win_is_valid(md_float) then
    close_md_float()
    return
  end

  if vim.bo.filetype ~= "markdown" then
    vim.notify("Not a markdown buffer")
    return
  end

  local buf = vim.api.nvim_get_current_buf()

  -------------------------------------------------
  -- DIM BACKGROUND
  -------------------------------------------------
  local bg_buf = vim.api.nvim_create_buf(false, true)

  md_bg = vim.api.nvim_open_win(bg_buf, false, {
    relative = "editor",
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    style = "minimal",
  })

  vim.api.nvim_set_hl(0, "MarkdownDim", { bg = "#11111b" })
  vim.wo[md_bg].winhighlight = "Normal:MarkdownDim"

  -------------------------------------------------
  -- FLOAT WINDOW
  -------------------------------------------------
  local width = 90
  local height = math.floor(vim.o.lines * 0.95)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  md_float = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  })

  -- window options
  vim.wo[md_float].wrap = true
  vim.wo[md_float].linebreak = true
  vim.wo[md_float].breakindent = true
  vim.wo[md_float].number = true
  vim.wo[md_float].relativenumber = true

  -------------------------------------------------
  -- ESC closes float
  -------------------------------------------------
  -- vim.keymap.set("n", "<Esc>", close_md_float, {
  --   buffer = buf,
  --   nowait = true,
  --   silent = true,
  --   buffer = 0, -- current buffer in THIS window
  -- })
  --
  -------------------------------------------------
  -- If user :q closes window → cleanup
  -------------------------------------------------
  vim.api.nvim_create_autocmd("WinClosed", {
    once = true,
    callback = function()
      close_md_float()
    end,
  })

end, { desc = "Toggle Markdown Float" })

