local builtin = require('telescope.builtin')


vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.buffers, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fc', function()
	builtin.grep_string({search = vim.fn.input("Grep > ")});
end)
