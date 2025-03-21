vim.g.copilot_no_tab_map = true

-- Accept full suggestion
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Accept next word (Alt+Shift+L)
vim.api.nvim_set_keymap("i", "<A-L>", 'copilot#AcceptWord("")', { silent = true, expr = true })

-- Accept next line (Alt+Shift+J)
vim.api.nvim_set_keymap("i", "<A-J>", 'copilot#AcceptLine("")', { silent = true, expr = true })

