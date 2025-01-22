require('mason').setup()
local cmp = require('cmp')
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local servers = mason_lspconfig.get_installed_servers()
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
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
}

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<C-f>', function()
            local filetype = vim.bo.filetype
            if filetype == 'rust' then
                vim.cmd('silent w')
                vim.cmd('silent !dx fmt --file %')
            elseif filetype == 'python' then
                vim.cmd('silent w')
                vim.cmd('silent !black --preview -q %')
            elseif filetype == 'gdscript' then
                vim.cmd('silent w')
                vim.cmd('silent !gdformat %')
            else
                vim.lsp.buf.format { async = true }
            end
        end, opts)
    end
})

for _, server_name in ipairs(servers) do
    lspconfig[server_name].setup({
        capabilities = lsp_capabilities,
    })
end

lspconfig.dartls.setup {
    cmd = { 'dart', 'language-server', '--protocol=lsp' },
    capabilities = lsp_capabilities,
}

lspconfig.lua_ls.setup {
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
}

lspconfig.graphql.setup {
    filetypes = { 'graphql', 'javascript', 'typescript', 'typescriptreact' },
}

lspconfig.rust_analyzer.setup {
    capabilities = lsp_capabilities,
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = 'clippy'
            }
        }
    },
    commands = {
        ExpandMacro = {
            function()
                vim.lsp.buf_request_all(
                    0,
                    'rust-analyzer/expandMacro',
                    vim.lsp.util.make_position_params(),
                    function(responses)
                        local result = { '```rust' }
                        local lines = responses[2].result.expansion:gmatch('[^\n]+')
                        local i = 1
                        for line in (lines) do
                            if i ~= 1 then
                                table.insert(result, line:sub(4))
                            end
                            i = i + 1
                        end
                        table.remove(result, #result)
                        table.insert(result, '```')
                        vim.lsp.util.open_floating_preview(result, 'markdown')
                    end
                )
            end
        }
    }
}
