vim.cmd.colorscheme('scheme')

vim.filetype.add({
    extension = {
        rz = "razor",
    },
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    callback = function()
        vim.lsp.stop_client(vim.lsp.get_clients({ name = 'Godot' }))
    end
})
