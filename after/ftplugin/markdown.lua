local md_float = nil
local md_bg = nil

-- Set up darker background for winbar
vim.api.nvim_set_hl(0, "WinBar", { bg = "#11111b" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#11111b" })

-- Function to abbreviate text if needed
local function abbreviate_text(text, max_length)
  if #text <= max_length then
    return text
  end
  return text:sub(1, max_length - 3) .. "..."
end

-- Function to get hierarchical markdown heading context with colors
local function get_markdown_breadcrumb()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, current_line, false)
  
  -- Build hierarchy of headings
  local heading_stack = {}
  
  for i = 1, #lines do
    local line = lines[i]
    local hashes, text = line:match("^(#+)%s+(.+)$")
    
    if hashes then
      local level = #hashes
      local heading_info = {
        level = level,
        text = text,
        line = i
      }
      
      -- Pop headings at same or deeper level
      while #heading_stack > 0 and heading_stack[#heading_stack].level >= level do
        table.remove(heading_stack)
      end
      
      -- Push current heading
      table.insert(heading_stack, heading_info)
    end
  end
  
  if #heading_stack == 0 then
    return "No heading"
  end
  
  -- Calculate available space - use current window width
  local win = vim.api.nvim_get_current_win()
  local win_width = vim.api.nvim_win_get_width(win)
  local num_headings = #heading_stack
  local separator_space = (#heading_stack - 1) * 3 -- " > " between items
  local prefix_space = 3 -- "📍 "
  local hash_space = 0
  for _, h in ipairs(heading_stack) do
    hash_space = hash_space + h.level + 1 -- # symbols + space
  end
  
  local available_for_text = win_width - prefix_space - separator_space - hash_space - 5 -- 5 for safety margin
  local max_text_per_heading = math.floor(available_for_text / num_headings)
  
  -- Build breadcrumb with colored headings
  local breadcrumb_parts = {}
  for idx, heading in ipairs(heading_stack) do
    local text = heading.text
    -- Abbreviate if needed based on available space
    if max_text_per_heading > 0 and max_text_per_heading < 30 then
      text = abbreviate_text(text, math.max(10, max_text_per_heading))
    elseif max_text_per_heading > 30 then
      -- Still abbreviate very long headers
      text = abbreviate_text(text, 50)
    end
    
    -- Use treesitter highlight groups for markdown headings
    local hl_group = string.format("@markup.heading.%d.markdown", heading.level)
    local colored_text = string.format("%%#%s#%s %s%%*", hl_group, string.rep("#", heading.level), text)
    table.insert(breadcrumb_parts, colored_text)
  end
  
  -- Join with separator
  return "📍 " .. table.concat(breadcrumb_parts, " %#Comment#>%* ")
end

-- Function to update winbar with breadcrumb
local function update_markdown_winbar()
  local breadcrumb = get_markdown_breadcrumb()
  vim.wo.winbar = breadcrumb
end

vim.api.nvim_create_autocmd({"BufWinEnter", "BufEnter", "BufReadPost"}, {
  pattern = "*.md",
  callback = function()
    vim.opt_local.colorcolumn = ""

    -- enable proper word wrapping
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    
    -- Set initial winbar
    vim.defer_fn(update_markdown_winbar, 10)
    
    -- Update breadcrumb on cursor movement and window resize
    vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI", "VimResized", "WinResized"}, {
      buffer = 0,
      callback = update_markdown_winbar,
    })
    
    -- Navigate by visual lines instead of actual lines
    vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
    vim.keymap.set("n", "0", "g0", { buffer = true, silent = true })
    vim.keymap.set("n", "$", "g$", { buffer = true, silent = true })
    vim.keymap.set("n", "H", "g0", { buffer = true, silent = true })
    vim.keymap.set("n", "L", "g$", { buffer = true, silent = true })
    vim.keymap.set("v", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("v", "k", "gk", { buffer = true, silent = true })
    vim.keymap.set("v", "0", "g0", { buffer = true, silent = true })
    vim.keymap.set("v", "$", "g$", { buffer = true, silent = true })
    vim.keymap.set("v", "H", "g0", { buffer = true, silent = true })
    vim.keymap.set("v", "L", "g$", { buffer = true, silent = true })
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

  local filename = vim.fn.expand("%:t")

  md_float = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " " .. filename .. " ",
    title_pos = "center",
  })

  -- window options
  vim.wo[md_float].number = true
  vim.wo[md_float].relativenumber = true
  
  -- Navigate by visual lines in float window
  vim.keymap.set("n", "j", "gj", { buffer = buf, silent = true })
  vim.keymap.set("n", "k", "gk", { buffer = buf, silent = true })
  vim.keymap.set("n", "0", "g0", { buffer = buf, silent = true })
  vim.keymap.set("n", "$", "g$", { buffer = buf, silent = true })
  vim.keymap.set("n", "H", "g0", { buffer = buf, silent = true })
  vim.keymap.set("n", "L", "g$", { buffer = buf, silent = true })
  vim.keymap.set("v", "j", "gj", { buffer = buf, silent = true })
  vim.keymap.set("v", "k", "gk", { buffer = buf, silent = true })
  vim.keymap.set("v", "0", "g0", { buffer = buf, silent = true })
  vim.keymap.set("v", "$", "g$", { buffer = buf, silent = true })
  vim.keymap.set("v", "H", "g0", { buffer = buf, silent = true })
  vim.keymap.set("v", "L", "g$", { buffer = buf, silent = true })

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

