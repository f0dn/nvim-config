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
            dependencies = { { 'nvim-lua/plenary.nvim' } }
        },
        { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
        'nvim-treesitter/playground',
        'nvim-treesitter/nvim-treesitter-context',
        {
            'folke/trouble.nvim',
            dependencies = { { 'nvim-tree/nvim-web-devicons' } },
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
        'mbbill/undotree',
        'github/copilot.vim',
        'tpope/vim-fugitive',
        { "catppuccin/nvim",                 name = "catppuccin", priority = 1000 },
        { 'chomosuke/typst-preview.nvim',    ft = 'typst' },
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
                { "nvim-lua/plenary.nvim", branch = "master" },
            },
            build = "make tiktoken",
            opts = {
                -- See Configuration section for options
            },
        },
        {
            'weirongxu/plantuml-previewer.vim',
            dependencies = { { 'tyru/open-browser.vim' }, { 'aklt/plantuml-syntax' } },
        }
    },
    checker = { enabled = false },
})
