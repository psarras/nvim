local builtin = require('telescope.builtin')

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
            hidden = false,
            -- find_command = { "rg","--ignore","--hidden","--files prompt_prefix=🔍" },
        },
    }
}



vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.buffers, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fc', builtin.live_grep, {desc = "Live grep"});
