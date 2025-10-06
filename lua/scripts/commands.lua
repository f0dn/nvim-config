vim.filetype.add({
    extension = {
        rz = "razor",
    },
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    callback = function()
        vim.api.nvim_command('silent echo serverstop("/tmp/godot.pipe")')
    end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.tex" },
    callback = function()
        vim.cmd([[
            silent !mkdir -p '%:p:h/out'
            silent !pdflatex -output-directory='%:p:h/out' -interaction=batchmode % > /dev/null
        ]])
    end
})
