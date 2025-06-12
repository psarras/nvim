-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim', commit = 'ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3' }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim', commit = '857c5ac632080dba10aae49dba902ce3abf91b35' } }
    }
    use { "catppuccin/nvim", as = "catppuccin", commit = 'fa42eb5e26819ef58884257d5ae95dd0552b9a66' }
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = '42fc28ba918343ebfd5565147a42a26580579482',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use {'akinsho/git-conflict.nvim', commit = '4bbfdd92d547d2862a75b4e80afaf30e73f7bbb4', config = function()
      require('git-conflict').setup()
    end}
    use { "theprimeagen/harpoon", commit = '1bc17e3e42ea3c46b33c0bbad6a880792692a1b3' }
    use { "mbbill/undotree", commit = 'b951b87b46c34356d44aa71886aecf9dd7f5788a'}
    use { "tpope/vim-fugitive", commit = '4a745ea72fa93bb15dd077109afbb3d1809383f2' }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }
    use { 'tpope/vim-surround', commit = '3d188ed2113431cf8dac77be61b842acb64433d9' }
    use {
        'numToStr/Comment.nvim', commit = 'e30b7f2008e52442154b66f7c519bfd2f1e32acb',
        config = function()
            require('Comment').setup()
        end
    }
    use { 'github/copilot.vim', commit = '3955014c503b0cd7b30bc56c86c56c0736ca0951' }
    use({
      "kylechui/nvim-surround", commit = '8dd9150ca7eae5683660ea20cec86edcd5ca4046',
      config = function()
        require("nvim-surround").setup({})
      end
    })
    -- use({
    --     "epwalsh/obsidian.nvim",
    --     tag = "*", -- recommended, use latest release instead of latest commit
    --     requires = {
    --         -- Required.
    --         "nvim-lua/plenary.nvim",
    --
    --         -- see below for full list of optional dependencies 👇
    --     },
    --     config = function()
    --         require("obsidian").setup({
    --             workspaces = {
    --                 {
    --                     name = "personal",
    --                     path = "~/vaults/personal",
    --                 },
    --                 {
    --                     name = "work",
    --                     path = "~/vaults/work",
    --                 },
    --             },
    --
    --             -- see below for full list of options 👇
    --         })
    --     end,
    -- })
    -- use { 'mhartington/formatter.nvim' }
end)
