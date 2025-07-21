require("stam.packer")
require("stam.remap")
require("stam.set")
require("catppuccin").setup({ flavour = "mocha", transparent_background = false })
vim.cmd.colorscheme "catppuccin"
require("stam.terminal")
-- require("luasnip.loaders.from_lua").load({ paths = "~/AppData/Local/nvim/lua/stam/snippets" })
require("luasnip.loaders.from_vscode").lazy_load()
local ls = require("luasnip")





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

-- Load/Save session if it exists
local session_file = ".vim"

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        if vim.fn.filereadable(session_file) == 1 then
            vim.cmd("source " .. session_file)
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
                    vim.api.nvim_buf_call(buf, function()
                        vim.cmd("doautocmd BufRead")
                    end)
                end
            end
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.cmd("mksession! " .. session_file)
    end,
})
