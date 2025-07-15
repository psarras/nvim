require("stam.packer")
require("stam.remap")
require("stam.set")
require("catppuccin").setup({ flavour = "mocha", transparent_background = false })
vim.cmd.colorscheme "catppuccin"
require("stam.terminal")

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



