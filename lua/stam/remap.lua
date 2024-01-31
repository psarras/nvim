vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('t', 'jk', [[<C-\><C-n>]]) -- no need to escape the '\'
vim.keymap.set('i', 'jk', [[<C-\><C-n>]]) -- no need to escape the '\'

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Map <leader>wv to split the window vertically
vim.api.nvim_set_keymap('n', '<leader>wv', ':vsplit<CR>', {noremap = true, silent = true})

-- Map <leader>wv to split the window horizontal
vim.api.nvim_set_keymap('n', '<leader>wh', ':split<CR>', {noremap = true, silent = true})

-- Map <leader>wu to close the current buffer
vim.api.nvim_set_keymap('n', '<leader>wu', ':bd<CR>', {noremap = true, silent = true})

-- Move between Panes, Ctrl+w and then the directions h,j,k,l
