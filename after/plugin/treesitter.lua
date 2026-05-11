local treesitter = require('nvim-treesitter')

local group = vim.api.nvim_create_augroup('TreeSitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    desc = 'Install treesitter parsers automatically',
    group = group,
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        local available_langs = treesitter.get_available()
        local is_available = vim.tbl_contains(available_langs, lang)
        if is_available then
            treesitter.install(lang):await(function()
                pcall(vim.treesitter.start) -- sometimes crashes because of filetypes :(
                treesitter.indentexpr()
            end)
        end
    end,
})
