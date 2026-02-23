-- after/ftplugin/markdown.lua
-- <leader>mw = float + outline
-- <leader>mz = float only

local md_float = nil
local md_bg = nil
local md_outline = nil
local md_source_win = nil
local md_group = nil

-------------------------------------------------
-- One-time Aerial config (prevents recentering its float)
-------------------------------------------------
do
  local ok, aerial = pcall(require, "aerial")
  if ok and not vim.g.__md_float_aerial_configured then
    vim.g.__md_float_aerial_configured = true

    aerial.setup({
      backends = { "treesitter", "lsp", "markdown" },
      layout = {
        default_direction = "right",
        resize_to_content = false,
      },
      float = {
        relative = "editor",
        override = function(conf, source_winid)
          local ok_geom, geom = pcall(vim.api.nvim_win_get_var, source_winid, "mw_md_geom")
          if ok_geom and type(geom) == "table" and geom.outline_enabled then
            conf.relative = "editor"
            conf.row = geom.row
            conf.col = geom.outline_col
            conf.width = geom.outline_w
            conf.height = geom.height
            conf.zindex = geom.z_outline
            return conf
          end
          return conf
        end,
      },
    })
  end
end

-------------------------------------------------
-- Winbar breadcrumb (unchanged)
-------------------------------------------------
vim.api.nvim_set_hl(0, "WinBar", { bg = "#11111b" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#11111b" })

local function abbreviate_text(text, max_length)
  if #text <= max_length then return text end
  return text:sub(1, max_length - 3) .. "..."
end

local function get_markdown_breadcrumb()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, current_line, false)

  local heading_stack = {}
  for i = 1, #lines do
    local hashes, text = lines[i]:match("^(#+)%s+(.+)$")
    if hashes then
      local level = #hashes
      while #heading_stack > 0 and heading_stack[#heading_stack].level >= level do
        table.remove(heading_stack)
      end
      table.insert(heading_stack, { level = level, text = text, line = i })
    end
  end

  if #heading_stack == 0 then return "No heading" end

  local win_width = vim.api.nvim_win_get_width(0)
  local separator_space = (#heading_stack - 1) * 3
  local prefix_space = 3

  local hash_space = 0
  for _, h in ipairs(heading_stack) do
    hash_space = hash_space + h.level + 1
  end

  local available_for_text = win_width - prefix_space - separator_space - hash_space - 5
  local max_text_per_heading = math.floor(available_for_text / #heading_stack)

  local parts = {}
  for _, heading in ipairs(heading_stack) do
    local text = heading.text
    if max_text_per_heading > 0 and max_text_per_heading < 30 then
      text = abbreviate_text(text, math.max(10, max_text_per_heading))
    elseif max_text_per_heading > 30 then
      text = abbreviate_text(text, 50)
    end
    local hl_group = string.format("@markup.heading.%d.markdown", heading.level)
    table.insert(parts, string.format("%%#%s#%s %s%%*", hl_group, string.rep("#", heading.level), text))
  end

  return "📍 " .. table.concat(parts, " %#Comment#>%* ")
end

local function update_markdown_winbar()
  vim.wo.winbar = get_markdown_breadcrumb()
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "BufReadPost" }, {
  pattern = "*.md",
  callback = function()
    vim.opt_local.colorcolumn = ""
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    vim.defer_fn(update_markdown_winbar, 10)
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "VimResized", "WinResized" }, {
      buffer = 0,
      callback = update_markdown_winbar,
    })

    -- enable spell checking for markdown files
    vim.opt.spell = false -- we use ltex-ls instead
    vim.opt.spelllang = { "en_gb" }  -- or "en_us"
    -- ]s → next error
    -- [s → previous error
    -- z= → suggestions
    -- zg → add to dictionary

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

-------------------------------------------------
-- Float helpers
-------------------------------------------------
local function is_valid(win) return win and vim.api.nvim_win_is_valid(win) end

local function calc_layout(with_outline)
  local cols = vim.o.columns
  local gap = 2
  local md_w = 90
  local outline_w = 34

  local height = math.floor(vim.o.lines * 0.95)

  local can_outline = with_outline and cols >= (md_w + gap + 24 + 4)
  local total_w = md_w + (can_outline and (gap + outline_w) or 0)

  local col = math.max(0, math.floor((cols - total_w) / 2))
  local row = math.max(0, math.floor((vim.o.lines - height) / 2))

  return {
    row = row,
    col = col,
    height = height,
    md_w = md_w,
    gap = gap,
    outline_enabled = can_outline,
    outline_w = can_outline and outline_w or 0,
    outline_col = col + md_w + gap,
    z_bg = 10,
    z_md = 50,
    z_outline = 60,
  }
end

local function close_md_suite()
  if md_group then
    pcall(vim.api.nvim_del_augroup_by_id, md_group)
    md_group = nil
  end

  local ok, aerial = pcall(require, "aerial")
  if ok and is_valid(md_float) and type(aerial.close) == "function" then
    pcall(vim.api.nvim_set_current_win, md_float)
    pcall(aerial.close)
  end

  if is_valid(md_outline) then pcall(vim.api.nvim_win_close, md_outline, true) end
  if is_valid(md_float) then pcall(vim.api.nvim_win_close, md_float, true) end
  if is_valid(md_bg) then pcall(vim.api.nvim_win_close, md_bg, true) end

  md_outline, md_float, md_bg = nil, nil, nil

  if is_valid(md_source_win) then
    pcall(vim.api.nvim_set_current_win, md_source_win)
  end
  md_source_win = nil
end

local function reposition(with_outline)
  if not is_valid(md_float) then return end
  local g = calc_layout(with_outline)

  if is_valid(md_bg) then
    vim.api.nvim_win_set_config(md_bg, {
      relative = "editor",
      row = 0,
      col = 0,
      width = vim.o.columns,
      height = vim.o.lines,
      zindex = g.z_bg,
    })
  end

  vim.api.nvim_win_set_config(md_float, {
    relative = "editor",
    row = g.row,
    col = g.col,
    width = g.md_w,
    height = g.height,
    zindex = g.z_md,
  })

  pcall(vim.api.nvim_win_set_var, md_float, "mw_md_geom", {
    row = g.row,
    col = g.col,
    height = g.height,
    outline_col = g.outline_col,
    outline_w = g.outline_w,
    z_outline = g.z_outline,
    outline_enabled = g.outline_enabled,
  })

  if is_valid(md_outline) then
    vim.api.nvim_win_set_config(md_outline, {
      relative = "editor",
      row = g.row,
      col = g.outline_col,
      width = g.outline_w,
      height = g.height,
      zindex = g.z_outline,
    })
  end
end

local function open_md_suite(with_outline)
  -- toggle off
  if is_valid(md_float) then
    close_md_suite()
    return
  end

  if vim.bo.filetype ~= "markdown" then
    vim.notify("Not a markdown buffer")
    return
  end

  md_source_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local g = calc_layout(with_outline)

  -- dim background
  local bg_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[bg_buf].bufhidden = "wipe"

  md_bg = vim.api.nvim_open_win(bg_buf, false, {
    relative = "editor",
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    style = "minimal",
    zindex = g.z_bg,
  })

  vim.api.nvim_set_hl(0, "MarkdownDim", { bg = "#11111b" })
  vim.wo[md_bg].winhighlight = "Normal:MarkdownDim"

  -- markdown float
  local filename = vim.fn.expand("%:t")
  md_float = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = g.md_w,
    height = g.height,
    row = g.row,
    col = g.col,
    border = "rounded",
    title = " " .. filename .. " ",
    title_pos = "center",
    style = "minimal",
    zindex = g.z_md,
  })

  vim.wo[md_float].wrap = true
  vim.wo[md_float].linebreak = true
  vim.wo[md_float].breakindent = true
  if with_outline then
      vim.wo[md_float].number = true
      vim.wo[md_float].relativenumber = true
  else
      vim.wo[md_float].number = false
      vim.wo[md_float].relativenumber = false
  end

  -- geometry for aerial.float.override
  pcall(vim.api.nvim_win_set_var, md_float, "mw_md_geom", {
    row = g.row,
    col = g.col,
    height = g.height,
    outline_col = g.outline_col,
    outline_w = g.outline_w,
    z_outline = g.z_outline,
    outline_enabled = g.outline_enabled,
  })

  -- outline float + aerial embed
  if g.outline_enabled then
    local outline_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[outline_buf].bufhidden = "wipe"

    md_outline = vim.api.nvim_open_win(outline_buf, false, {
      relative = "editor",
      width = g.outline_w,
      height = g.height,
      row = g.row,
      col = g.outline_col,
      border = "rounded",
      title = " Outline ",
      title_pos = "center",
      style = "minimal",
      zindex = g.z_outline,
    })

    vim.wo[md_outline].number = false
    vim.wo[md_outline].relativenumber = false
    vim.wo[md_outline].wrap = false

    local ok, aerial = pcall(require, "aerial")
    if ok and type(aerial.open_in_win) == "function" then
      aerial.open_in_win(md_outline, md_float)
      pcall(aerial.refetch_symbols, buf)
    else
      vim.notify("aerial.open_in_win() not available; update aerial.nvim", vim.log.levels.WARN)
    end
  end

  -- session autocmds
  md_group = vim.api.nvim_create_augroup("MarkdownFloatSuite", { clear = true })

  vim.api.nvim_create_autocmd("VimResized", {
    group = md_group,
    callback = function() reposition(with_outline) end,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = md_group,
    pattern = tostring(md_float),
    callback = close_md_suite,
  })

  if md_outline then
    vim.api.nvim_create_autocmd("WinClosed", {
      group = md_group,
      pattern = tostring(md_outline),
      callback = close_md_suite,
    })
  end
end

-------------------------------------------------
-- Keymaps
-------------------------------------------------
vim.keymap.set("n", "<leader>mw", function()
  open_md_suite(true)
end, { desc = "Markdown float + outline" })

vim.keymap.set("n", "<leader>mz", function()
  open_md_suite(false)
end, { desc = "Markdown float (no outline)" })
