require("stam.packer")
require("stam.remap")
require("stam.set")
require("catppuccin").setup({ flavour = "mocha", transparent_background = false })
vim.cmd.colorscheme "catppuccin"
require("stam.terminal")
-- require("luasnip.loaders.from_lua").load({ paths = "~/AppData/Local/nvim/lua/stam/snippets" })
require("luasnip.loaders.from_vscode").lazy_load()
local ls = require("luasnip")


vim.keymap.set('n', '<leader>ir', function()
  dofile(vim.fn.expand("~/AppData/Local/nvim/lua/stam/init.lua"))
end, { desc = "Reload stam.lua" })

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
-- briefly highlight selection
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch", -- Highlight group to use
            timeout = 200,   -- Duration of the highlight in milliseconds
        })
    end,
})

vim.opt.clipboard = "unnamedplus"

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            ".git/*",
            "node_modules/*",
            "bin/*",
            "obj/*",
            ".venv/*",
            ".obsidian/*",
        }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    }
}


vim.api.nvim_create_user_command('MakeTags', '!ctags -R', {})

require('refactoring').setup({
    prompt_func_return_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = true,
    },
    prompt_func_param_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = true,
    },
    printf_statements = {},
    print_var_statements = {},
    show_success_message = true, -- shows a message with information about the refactor on success
                                  -- i.e. [Refactor] Inlined 3 variable occurrences
})

-- session filename to look for in the target directory
local SESSION_NAME = ".vim"

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local args = vim.fn.argv()
    local base_dir = (#args > 0)
      and vim.fn.fnamemodify(args[1], ":p:h")
      or vim.fn.getcwd()

    local session_path = vim.fs.joinpath(base_dir, SESSION_NAME)
    vim.g._session_path = session_path

    if vim.fn.filereadable(session_path) == 1 then
      vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))
      -- Re-run BufRead for buffers restored by the session
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("doautocmd BufRead")
          end)
        end
      end
    end

    -- Open any CLI files in their own tab(s)
    for _, f in ipairs(args) do
      vim.cmd("tab drop " .. vim.fn.fnameescape(f))
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    local path = vim.g._session_path or SESSION_NAME
    vim.cmd("mksession! " .. vim.fn.fnameescape(path))
  end,
})

