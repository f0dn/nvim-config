local trouble = require('trouble')

trouble.setup({
    auto_preview = false,
    focus = true,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.keymap.set('n', '<leader>d', function() trouble.open('diagnostics') end)
