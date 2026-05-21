vim.g.maplocalleader = ' '

local agentic = require('agentic')

agentic.setup({
    provider = 'copilot-acp',
    file_picker = {
        enabled = false,
    }
})

vim.keymap.set('n', '<leader>a', function()
    agentic.toggle()
    vim.schedule(vim.cmd.stopinsert) -- start in normal mode
end, { desc = 'Toggle Agent panel' })








-- TODO fix this when agentic.nvim has better autocomplete support

-- clears the agentic.nvim autocmd that auto-triggers omni complete
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'AgenticInput',
    callback = function(ev)
        vim.schedule(function()
            vim.api.nvim_clear_autocmds({ event = 'TextChangedI', buffer = ev.buf })
        end)
    end,
})

local function word_starts_with(prefix)
    local current_line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local current_word = current_line:sub(1, cursor_col):match("%S+$") or ""
    return current_word:sub(1, #prefix) == prefix
end

local blink_providers = {
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

local blink = require('blink.cmp')
for name, provider in pairs(blink_providers) do
    blink.add_source_provider(name, provider)
    blink.add_filetype_source('AgenticInput', name)
end
