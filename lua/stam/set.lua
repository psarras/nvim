vim.opt.path:append('**')
vim.opt.wildmenu = true

vim.api.nvim_create_user_command('MakeTags', '!ctags -R', {})

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

--vim.opt.wrap = false

vim.opt.hlsearch = true
vim.opt.incsearch = true


vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.opt.cursorline = true  -- Highlight the current line
vim.opt.showmode = false   -- Do not show mode since we use a statusline plugin
vim.opt.conceallevel = 1
