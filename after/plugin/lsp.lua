local lsp = require('lsp-zero')

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {'tsserver', 'rust_analyzer'},
  handlers = {
    lsp.default_setup,
  },
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
