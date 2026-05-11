-- custom language :)
vim.filetype.add({
    extension = {
        rz = 'razor',
    },
})

-- latex compile and save on write
local latex_group = vim.api.nvim_create_augroup('LatexCompile', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    desc = 'Compile LaTeX files on save',
    group = latex_group,
    pattern = { '*.tex' },
    callback = function()
        vim.cmd([[
            silent !mkdir -p '%:p:h/out'
            silent !pdflatex -output-directory='%:p:h/out' -interaction=batchmode % > /dev/null
        ]])
    end
})
