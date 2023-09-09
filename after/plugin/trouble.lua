local trouble = require('trouble')

trouble.setup({
    mode = 'document_diagnostics',
    auto_preview = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.keymap.set('n', '<leader>d', trouble.open)
