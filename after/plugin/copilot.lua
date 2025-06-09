vim.g.copilot_no_tab_map = true

-- Accept full suggestion
vim.api.nvim_set_keymap("i", "<C-Y>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Accept next word (Alt+Shift+L)
vim.api.nvim_set_keymap("i", "<C-L>", 'copilot#AcceptWord("")', { silent = true, expr = true })

-- Accept next line (Alt+Shift+J)
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#AcceptLine("")', { silent = true, expr = true })

