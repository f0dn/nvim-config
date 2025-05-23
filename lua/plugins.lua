local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.2',
            -- or                    , branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } }
        },
        { 'nvim-treesitter/nvim-treesitter',                  run = ':TSUpdate' },
        'nvim-treesitter/playground',
        'nvim-treesitter/nvim-treesitter-context',
        {
            'folke/trouble.nvim',
            requires = { { 'nvim-tree/nvim-web-devicons' } },
        },
        'williamboman/mason-lspconfig.nvim',
        {
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        'saadparwaiz1/cmp_luasnip',
        'mfussenegger/nvim-jdtls',
        'L3MON4D3/LuaSnip',
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'theprimeagen/harpoon',
        'mbbill/undotree',
        'github/copilot.vim',
        'tpope/vim-fugitive',
        'rktjmp/lush.nvim',
        'rktjmp/shipwright.nvim',
        { dir = '/home/there/.config/nvim/lua/scripts/scheme' },
        'ThePrimeagen/vim-be-good',
        'thosakwe/vim-flutter',
    },
    checker = { enabled = false },
})
