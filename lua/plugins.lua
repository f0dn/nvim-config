local augroup_packer = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = 'plugins.lua',
    group = augroup_packer,
    command = 'source <afile> | PackerCompile',
})

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                    , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-context'
    use { 'folke/trouble.nvim',
        requires = { { 'nvim-tree/nvim-web-devicons' } },
    }
    use 'williamboman/mason-lspconfig.nvim'
    use {
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
    }
    use 'saadparwaiz1/cmp_luasnip'
    use 'mfussenegger/nvim-jdtls'
    use 'L3MON4D3/LuaSnip'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'theprimeagen/harpoon'
    use 'mbbill/undotree'
    use 'github/copilot.vim'
    use 'tpope/vim-fugitive'
    use 'rktjmp/lush.nvim'
    use "rktjmp/shipwright.nvim"
    use '/home/there/.config/nvim/lua/scripts/scheme'
    use 'ThePrimeagen/vim-be-good'
    use 'thosakwe/vim-flutter'
end)
