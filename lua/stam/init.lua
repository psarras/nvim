require("stam.remap")
require("stam.packer")
require("stam.set")
require("catppuccin").setup({flavour="mocha", transparent_background = false})
vim.cmd.colorscheme "catppuccin"

-- briefly highlight selection
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch", -- Highlight group to use
      timeout = 200,         -- Duration of the highlight in milliseconds
    })
  end,
})

vim.opt.clipboard = "unnamedplus"

require('telescope').setup {
    defaults = {
        file_ignore_patterns = { ".git/*", "node_modules/*" }
    }
}
