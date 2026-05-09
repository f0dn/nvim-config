-- custom language :)
vim.filetype.add({
    extension = {
        rz = 'razor',
    },
})

-- latex compile and save on write
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = { '*.tex' },
    callback = function()
        vim.cmd([[
            silent !mkdir -p '%:p:h/out'
            silent !pdflatex -output-directory='%:p:h/out' -interaction=batchmode % > /dev/null
        ]])
    end
})
