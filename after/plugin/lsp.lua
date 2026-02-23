local lsp = require('lspconfig')
local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
      "omnisharp",
      "ols",
      "pyright",
      -- "ruff",
      "pylsp",
      "powershell_es",
      --
      "ltex",
  },
  automatic_enable = {
    exclude = { "ltex" },
  },
  -- handlers = {
  --   lsp.default_setup,
  -- },
  omnisharp ={}
})

require('mason-tool-installer').setup({
  ensure_installed = {
    "isort",
    "black",
    -- "ruff",
  },
})

lsp.pyright.setup{
  settings = {
    python = {
      venvPath = ".",
      venv = ".venv",
      -- pythonPath = ".venv/bin/python",  -- Linux/macOS
      pythonPath = ".venv/Scripts/python.exe", -- Windows
    }
  }
}

--
-- shared on_attach (use your own keymaps here)
local on_attach = function(_, bufnr)
  -- example:
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
end
-- vim.keymap.set("n", "K", vim.lsp.buf.hover)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- lsp.ruff.setup{ capabilities = capabilities, on_attach = on_attach }

local util = require("lspconfig.util")
local uv = vim.uv or vim.loop

local function exists(p) return p and uv.fs_stat(p) ~= nil end
local cwd = uv.cwd()
local venv_py   = util.path.join(cwd, ".venv", "Scripts", "python.exe")
local venv_pylsp= util.path.join(cwd, ".venv", "Scripts", "pylsp.exe")

lsp.pylsp.setup{
  cmd = { vim.fn.getcwd() .. "/.venv/Scripts/pylsp.exe" }, -- Windows
  -- cmd = exists(venv_pylsp) and { venv_pylsp } or nil, -- prefer pylsp from your .venv
  settings = {
    pylsp = {
      plugins = {
        rope = { enabled = true },
        pyflakes = { enabled = false },
        pycodestyle = { 
            enabled = true,
            maxLineLength = 120,
        },
        mccabe = { enabled = false },
        yapf = { enabled = false },
        autopep8 = { enabled = false },
        -- Point Jedi to your project venv for accurate symbols
        jedi = {
            environment = vim.fn.getcwd() .. "/.venv/Scripts/python.exe", -- exists(venv_py) and venv_py or nil,       -- absolute path
            extra_paths = { cwd },         
          -- environment = ".venv/Scripts/python.exe", -- Windows: ".venv/Scripts/python.exe"
        },
      },
    },
  },
  -- Optional: lower diagnostic priority so Pyright/Ruff win
  handlers = {
    ["textDocument/publishDiagnostics"] = function(...) end, -- disable pylsp diags
  },
}


lsp.omnisharp.setup({
    capabilities = capabilities, on_attach = on_attach,
    cmd = { "dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll" },
    enable_roslyn_analyzers = true,
    enable_import_completion = true,
    organize_imports_on_format = true,
})


cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--   ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--   ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--   ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--   ["<C-Space>"] = cmp.mapping.complete(),
-- })

-- lsp.on_attach(function(client, bufnr)
--   -- see :help lsp-zero-keybindings
--   -- to learn the available actions
--   lsp.default_keymaps({buffer = bufnr})
-- end)

require('cmp').setup({
    -- The 'sources' field determines where nvim-cmp looks for completion items
    sources = {
        { name = 'nvim_lsp' },          -- LSP-based completions
        { name = 'buffer' },            -- Fallback to buffer completions
        { name = 'path' }               -- Fallback to path completions
        -- Add other sources as needed
    }
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

lsp.ltex.setup({
  filetypes = { "markdown", "tex", "plaintex" },
  root_dir = util.root_pattern(".git", "pyproject.toml", "package.json"),
  settings = {
    ltex = {
      language = "en-GB", -- or en-US
      dictionary = {
        ["en-GB"] = {
          -- external dictionary file
          ":" .. (vim.fn.getcwd() .. "/.ltex.dictionary.en-GB.txt"),
        },
      },      diagnosticSeverity = "information",
      additionalRules = {
        enablePickyRules = true,
      },
      latex = {
        commands = {
          ["\\cite"] = "ignore",
          ["\\ref"] = "ignore",
        },
      },
    },
  },
})

