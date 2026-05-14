local agentic = require('agentic')

agentic.setup({
    provider = 'copilot-acp'
})

vim.keymap.set('n', '<leader>a', function() agentic.toggle() end, { desc = 'Toggle Agent panel' })
