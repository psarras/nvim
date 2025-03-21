-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "catppuccin/nvim", as = "catppuccin" }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use { "theprimeagen/harpoon" }
    use { "mbbill/undotree" }
    use { "tpope/vim-fugitive" }
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
    use { 'tpope/vim-surround' }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use { 'github/copilot.vim' }
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
