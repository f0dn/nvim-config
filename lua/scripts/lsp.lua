require('mason').setup()
local cmp = require('cmp')
local servers = require('mason-lspconfig').get_installed_servers()
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local telescope_builtin = require('telescope.builtin')
local conform = require('conform')

local short_indent_langs = { 'css', 'dart', 'haskell', 'html' }
local custom_configs = {
    dartls = {
        cmd = { 'dart', 'language-server', '--protocol=lsp' },
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    library = { vim.env.VIMRUNTIME }
                },
                globals = {
                    'vim',
                }
            }
        }
    },
    graphql = {
        filetypes = { 'graphql', 'javascript', 'typescript', 'typescriptreact' },
    },
    rust_analyzer = {
        settings = {
            ['rust-analyzer'] = {
                check = {
                    command = 'clippy'
                }
            }
        }
    }
}

--[[
vim.lsp.config('harper_ls', {
    filetypes = {},
    capabilities = lsp_capabilities,
    settings = {
        ["harper-ls"] = {
            linters = {
                SentenceCapitalization = false,
                SpellCheck = false,
            }
        }
    }
})
]]

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'CopilotChat' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
            else
                fallback()
            end
        end)
    })
})

conform.setup({
    formatters_by_ft = {
        rust = { 'dioxus' },
        python = { 'ruff' },
        gdscript = { 'gdformat' },
    }
})

local lsp_group = vim.api.nvim_create_augroup('LSP', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP keybinds',
    group = lsp_group,
    callback = function(event)
        local function opts(desc) return { desc = desc, buffer = event.buf } end
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('LSP Hover'))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('LSP Go to Definition'))
        vim.keymap.set('n', 'grr', telescope_builtin.lsp_references, opts('LSP References'))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts('LSP Code Actions'))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts('LSP Rename'))
        vim.keymap.set('n', '<C-f>', function()
            conform.format({ async = true, lsp_format = 'first' })
        end, opts('Format Current Buffer'))
    end
})

for _, server_name in ipairs(servers) do
    vim.lsp.enable(server_name)
    vim.lsp.config(server_name, {
        capabilities = lsp_capabilities,
    })
end

for server_name, config in pairs(custom_configs) do
    vim.lsp.config(server_name, config)
end

local short_indent_group = vim.api.nvim_create_augroup('ShortIndent', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    desc = 'Set short indent for certain languages',
    group = short_indent_group,
    pattern = short_indent_langs,
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
        }
    }
})
