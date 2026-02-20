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
        },

        preview = {
            treesitter = false,
        },

        layout_config = {
            preview_cutoff = 1,
        },
    },

    pickers = {
        live_grep = {
            additional_args = function()
                return { "--no-heading" }
            end,

            -- Only affects <leader>fc / live_grep
            preview = {
                filetype_hook = function(_, _, opts)
                    -- Soft wrap in the PREVIEW window (not results)
                    vim.api.nvim_set_option_value("wrap", true, { win = opts.winid })
                    -- Optional: nicer wrapping for prose / long lines
                    vim.api.nvim_set_option_value("linebreak", true, { win = opts.winid })
                    vim.api.nvim_set_option_value("breakindent", true, { win = opts.winid })
                    return true
                end,
            },
        },

        find_files = {
            hidden = false,
        },
    },
}

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.buffers, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fc', builtin.live_grep, { desc = "Live grep" })
