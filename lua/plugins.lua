local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    gh('nvim-lua/plenary.nvim'),       -- for telescope
    gh('nvim-tree/nvim-web-devicons'), -- for telescope
    gh('tyru/open-browser.vim'),       -- for plantuml previewer
    gh('aklt/plantuml-syntax'),        -- for plantuml previewer
    gh('catppuccin/nvim'),

    -- tree sitter
    gh('nvim-treesitter/nvim-treesitter'),
    gh('nvim-treesitter/nvim-treesitter-context'),

    -- lsp
    gh('neovim/nvim-lspconfig'),
    gh('williamboman/mason.nvim'),
    gh('williamboman/mason-lspconfig.nvim'),
    gh('hrsh7th/nvim-cmp'),
    gh('hrsh7th/cmp-nvim-lsp'),
    gh('stevearc/conform.nvim'),
    gh('mfussenegger/nvim-jdtls'),

    -- telescope
    gh('nvim-telescope/telescope.nvim'),
    gh('nvim-telescope/telescope-ui-select.nvim'),

    -- ai
    gh('github/copilot.vim'),
    gh('carlos-algms/agentic.nvim'),

    -- misc
    gh('tpope/vim-fugitive'),
    gh('mbbill/undotree'),
    gh('chomosuke/typst-preview.nvim'),
    gh('weirongxu/plantuml-previewer.vim'),
})

local update_callbacks = {
    ['nvim-treesitter'] = function()
        vim.cmd.TSUpdate()
    end,
}

local pack_group = vim.api.nvim_create_augroup('PackChanged', { clear = true })
vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Run plugin callbacks on plugin updates',
    group = pack_group,
    callback = function(ev)
        if ev.data.kind == 'update' then
            for name, callback in pairs(update_callbacks) do
                if name == ev.data.spec.name then
                    if not ev.data.active then vim.cmd.packadd(name) end
                    callback()
                end
            end
        end
    end
})
