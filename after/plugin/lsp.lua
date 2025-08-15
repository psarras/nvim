local lsp = require('lsp-zero')

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {"omnisharp", "ols"},
  handlers = {
    lsp.default_setup,
  },
  omnisharp ={}
})

local cmp = require('cmp')

local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

require('cmp').setup({
    -- The 'sources' field determines where nvim-cmp looks for completion items
    sources = {
        { name = 'nvim_lsp' },          -- LSP-based completions
        { name = 'buffer' },            -- Fallback to buffer completions
        { name = 'path' }               -- Fallback to path completions
        -- Add other sources as needed
    }
})


require("lspconfig").omnisharp.setup({
  cmd = { "dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll" },
  enable_roslyn_analyzers = true,
  enable_import_completion = true,
  organize_imports_on_format = true,
})
--
--
-- vim.diagnostic.config({
--   virtual_text = true,
--   signs = true,
--   update_in_insert = false,
-- })
--
--
vim.keymap.set("n", "<leader>am", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>en", function() -- Go to next diagnostic
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to next error" })
vim.keymap.set("n", "<leader>ep", function() -- Go to previous diagnostic
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to previous error" })

vim.keymap.set("n", "<leader>wn", function() -- Go to next diagnostic
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING }) -- ]d
end, { desc = "Go to next warning" })
vim.keymap.set("n", "<leader>wp", function() -- Go to next diagnostic
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING }) -- [d
end, { desc = "Go to next warning" })

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)


