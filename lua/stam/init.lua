require("stam.remap")
--print("from stam")
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

