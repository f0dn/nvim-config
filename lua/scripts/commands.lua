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
