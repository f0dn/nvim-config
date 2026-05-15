require('mason').setup()
local blink = require('blink.cmp')
local servers = require('mason-lspconfig').get_installed_servers()
local lsp_capabilities = blink.get_lsp_capabilities({
    textDocument = { completion = { completionItem = { snippetSupport = false } } },
})
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

local function word_starts_with(prefix)
    local current_line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local current_word = current_line:sub(1, cursor_col):match("%S+$") or ""
    return current_word:sub(1, #prefix) == prefix
end

blink.setup({
    keymap = {
        preset = 'none',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<Tab>'] = { 'accept', 'fallback' },
    },
    sources = {
        default = {
            'lsp', 'agentic_commands', 'agentic_files'
        },
        providers = {
            agentic_commands = {
                name = 'Agentic Commands',
                module = 'blink.cmp.sources.complete_func',
                enabled = function() return vim.bo.filetype == 'AgenticInput' and word_starts_with('/') end,
                opts = {
                    complete_func = function()
                        return "v:lua.require'agentic.acp.slash_commands'.complete_func"
                    end,
                },
                override = {
                    get_trigger_characters = function() return { '/' } end,
                },
            },
            agentic_files = {
                name = 'Agentic Files',
                module = 'blink.cmp.sources.path',
                enabled = function() return vim.bo.filetype == 'AgenticInput' and word_starts_with('@') end,
                override = {
                    get_trigger_characters = function(self)
                        local triggers = self:get_trigger_characters()
                        table.insert(triggers, '@')
                        return triggers
                    end,
                    get_completions = function(self, context, callback)
                        context.line = context.line:reverse():gsub('@', '/.@', 1):reverse()
                        context.bounds.start_col = context.bounds.start_col + 2
                        context.bounds.line = context.line
                        context.cursor[2] = context.cursor[2] + 2
                        context.bounds.length = context.bounds.length + 2

                        local function callback_wrapper(completions)
                            if completions then
                                for _, comp in ipairs(completions.items) do
                                    if not comp.textEdit.range._visited then
                                        comp.textEdit.range.start.character = comp.textEdit.range.start.character - 2
                                        comp.textEdit.range._visited = true
                                    end
                                end
                            end
                            callback(completions)
                        end

                        return self:get_completions(context, callback_wrapper)
                    end
                },
            },
        }
    },
    completion = {
        accept = {
            auto_brackets = {
                enabled = false,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
        },
        trigger = {
            show_on_trigger_character = true,
        }
    }
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
