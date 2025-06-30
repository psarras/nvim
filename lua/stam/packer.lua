-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim', commit = 'ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3' }
    use{ "chentoast/marks.nvim", config= function()
        -- https://github.com/chentoast/marks.nvim
        -- mx              Set mark x
        -- m,              Set the next available alphabetical (lowercase) mark
        -- m;              Toggle the next available mark at the current line
        -- dmx             Delete mark x
        -- dm-             Delete all marks on the current line
        -- dm<space>       Delete all marks in the current buffer
        -- m]              Move to next mark
        -- m[              Move to previous mark
        -- m:              Preview mark. This will prompt you for a specific mark to
        --                 preview; press <cr> to preview the next mark.
        --                 
        -- m[0-9]          Add a bookmark from bookmark group[0-9].
        -- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
        -- m}              Move to the next bookmark having the same type as the bookmark under
        --                 the cursor. Works across buffers.
        -- m{              Move to the previous bookmark having the same type as the bookmark under
        --                 the cursor. Works across buffers.
        -- dm=             Delete the bookmark under the cursor.
        --
        require("marks").setup({
            -- whether to map keybinds or not. default true
            default_mappings = true,
            -- which builtin marks to show. default {}
            builtin_marks = { ".", "<", ">", "^" },
            -- whether movements cycle back to the beginning/end of buffer. default true
            cyclic = true,
            -- whether the shada file is updated after modifying uppercase marks. default false
            force_write_shada = false,
            -- how often (in ms) to redraw signs/recompute mark positions. 
            -- higher values will have better performance but may cause visual lag, 
            -- while lower values may cause performance penalties. default 150.
            refresh_interval = 250,
            -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
            -- marks, and bookmarks.
            -- can be either a table with all/none of the keys, or a single number, in which case
            -- the priority applies to all marks.
            -- default 10.
            sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
            -- disables mark tracking for specific filetypes. default {}
            excluded_filetypes = {},
            -- disables mark tracking for specific buftypes. default {}
            excluded_buftypes = {},
            -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
            -- sign/virttext. Bookmarks can be used to group together positions and quickly move
            -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
            -- default virt_text is "".
            bookmark_0 = {
                sign = "⚑",
                virt_text = "hello world",
                -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
                -- defaults to false.
                annotate = false,
            },
            mappings = {}
        })

    end
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim'} }
    }
    use { "catppuccin/nvim", as = "catppuccin", commit = 'fa42eb5e26819ef58884257d5ae95dd0552b9a66' }
    use {
        'nvim-treesitter/nvim-treesitter',
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
    use { "ThePrimeagen/refactoring.nvim",
        requires = {
            { 'nvim-lua/plenary.nvim'},
            {'nvim-treesitter/nvim-treesitter'}
        }
    }
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
