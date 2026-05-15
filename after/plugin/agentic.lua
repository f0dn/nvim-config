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

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'AgenticInput',
    callback = function(ev)
        vim.schedule(function()
            vim.api.nvim_clear_autocmds({ event = 'TextChangedI', buffer = ev.buf })
        end)
    end,
})
