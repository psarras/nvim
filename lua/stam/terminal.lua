-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
    group = augroup,
    callback = function()
        if vim.v.event.status == 0 then
            vim.api.nvim_buf_delete(0, {})
        end
    end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

-- terminal
local terminal_state = {
    buf = nil,
    win = nil,
    is_open = false
}

local job_id = 0
local function FloatingTerminal()
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
        return
    end

    if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
        terminal_state.buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
    end

    -- Open horizontal bottom split and set buffer
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.4))
    terminal_state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal_state.win, terminal_state.buf)

    -- Launch terminal if buffer is empty
    local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
    if #lines == 0 or (lines[1] == "") then
        vim.fn.termopen(os.getenv("SHELL") or "pwsh")
    end
    job_id = vim.bo.channel
    terminal_state.is_open = true
    vim.cmd("startinsert")

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = terminal_state.buf,
        callback = function()
            if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                vim.api.nvim_win_close(terminal_state.win, false)
                terminal_state.is_open = false
            end
        end,
        once = true
    })
end

vim.api.nvim_create_user_command("RunDotnet", function()
    local path = vim.fn.expand("%:p:h")
    local project_dir = nil

    while path and path ~= "/" do
        local csproj = vim.fn.glob(path .. "/*.csproj")
        if csproj ~= "" then
            project_dir = path
            break
        end

        if vim.fn.isdirectory(path .. "/.git") == 1 then
            break
        end

        path = vim.fn.fnamemodify(path, ":h")
    end

    if project_dir then
        if job_id == 0 then
            FloatingTerminal()
        end
        vim.fn.chansend(job_id, "dotnet run --project " .. project_dir .. "\r\n")
    else
        print("No .csproj found in parent directories.")
    end
end, {})

vim.keymap.set("n", "<leader>dr", "<cmd>RunDotnet<CR>", { noremap = true, silent = true })


-- local function FloatingTerminal()
--   -- If terminal is already open, close it (toggle behavior)
--   if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
--     vim.api.nvim_win_close(terminal_state.win, false)
--     terminal_state.is_open = false
--     return
--   end
--
--   -- Create buffer if it doesn't exist or is invalid
--   if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
--     terminal_state.buf = vim.api.nvim_create_buf(false, true)
--     -- Set buffer options for better terminal experience
--     vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
--   end
--
--   -- Calculate window dimensions
--   local width = math.floor(vim.o.columns * 0.8)
--   local height = math.floor(vim.o.lines * 0.8)
--   local row = math.floor((vim.o.lines - height) / 2)
--   local col = math.floor((vim.o.columns - width) / 2)
--
--   -- Create the floating window
--   terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
--     relative = 'editor',
--     width = width,
--     height = height,
--     row = row,
--     col = col,
--     style = 'minimal',
--     border = 'rounded',
--   })
--
--   -- Set transparency for the floating window
--   vim.api.nvim_win_set_option(terminal_state.win, 'winblend', 0)
--
--   -- Set transparent background for the window
--   vim.api.nvim_win_set_option(terminal_state.win, 'winhighlight',
--     'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder')
--
--   -- Define highlight groups for transparency
--   vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
--   vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })
--
--   -- Start terminal if not already running
--   local has_terminal = false
--   local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
--   for _, line in ipairs(lines) do
--     if line ~= "" then
--       has_terminal = true
--       break
--     end
--   end
--
--   if not has_terminal then
--     vim.fn.termopen(os.getenv("SHELL") or "pwsh")
--   end
--
--   terminal_state.is_open = true
--   vim.cmd("startinsert")
--
--   -- Set up auto-close on buffer leave
--   vim.api.nvim_create_autocmd("BufLeave", {
--     buffer = terminal_state.buf,
--     callback = function()
--       if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
--         vim.api.nvim_win_close(terminal_state.win, false)
--         terminal_state.is_open = false
--       end
--     end,
--     once = true
--   })
-- end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end

-- Key mappings
vim.keymap.set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set({ "t", "n" }, "<Esc>", function()
    if terminal_state.is_open then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })
