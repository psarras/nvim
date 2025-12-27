vim.keymap.set('n', '<leader>>', function() vim.cmd('vertical resize +' .. 10) end, { silent = true })
vim.keymap.set('n', '<leader><', function() vim.cmd('vertical resize -' .. 10) end, { silent = true })
vim.keymap.set('n', '<leader>+', function() vim.cmd('resize +' .. 5) end, { silent = true })
vim.keymap.set('n', '<leader>-', function() vim.cmd('resize -' .. 5) end, { silent = true })

