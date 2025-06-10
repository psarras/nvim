vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('t', 'jk', [[<C-\><C-n>]]) -- no need to escape the '\'
vim.keymap.set('i', 'jk', [[<C-\><C-n>]]) -- no need to escape the '\'

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "H", "^", {noremap = true })
vim.keymap.set("n", "L", "$", {noremap = true })
vim.keymap.set("n", "<A-S-K>", ":tabn<CR>", {noremap = true })
vim.keymap.set("n", "<A-S-J>", ":tabp<CR>", {noremap = true })
vim.keymap.set("n", "<A-S-N>", ":tabnew<CR>", {noremap = true })

-- For normal mode, replacing the word under cursor without affecting the cursor position much
-- vim.keymap.set('n', '<leader>p', function()
--  vim.cmd('normal! viw"\\_d')
--  vim.cmd('normal! P')
-- end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>p', 'viw"_dP', {silent = true})
vim.keymap.set('x', 'p', '"_dP', {silent = true})

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.api.nvim_set_keymap('n', '<F9>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Map <leader>wv to split the window vertically
vim.api.nvim_set_keymap('n', '<leader>wv', ':vsplit<CR>', { noremap = true, silent = true })

-- Map <leader>wv to split the window horizontal
vim.api.nvim_set_keymap('n', '<leader>wh', ':split<CR>', { noremap = true, silent = true })

-- Map <leader>wu to close the current buffer
vim.api.nvim_set_keymap('n', '<leader>wu', ':bd<CR>', { noremap = true, silent = true })

-- Move between Panes, Ctrl+w and then the directions h,j,k,l

vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

-- Back and Forward
vim.api.nvim_set_keymap('n', '<leader>gb', '<C-o>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gf', '<C-i>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gu', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>h', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })


-- Comments
vim.api.nvim_set_keymap('n', '<leader>c', ':normal gcc<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', ':<C-u>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
    { noremap = true, silent = true })

-- auto format
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format{async =true}<CR>', { noremap = true, silent = true })

-- Jump to the next conflict marker
vim.api.nvim_set_keymap('n', '<leader>n', '/<<<<<<<\\|=======\\|>>>>>>>\\<CR>', { noremap = true, silent = true })



require('git-conflict').setup { default_mappings = false }

vim.api.nvim_create_autocmd('User', {
  pattern = 'GitConflictDetected',
  callback = function()
    -- map buffer-local shortcuts
    vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)')
    vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)')
    vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)')
    vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)')
    vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)')
    vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)')
  end
})


