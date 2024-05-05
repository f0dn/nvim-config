vim.cmd.colorscheme('scheme')

vim.filetype.add({
    extension = {
        rz = "rizz",
    },
})

vim.cmd("let processing = 0")

vim.api.nvim_create_autocmd('BufWinLeave', {
    desc = 'Processing clean up',

    pattern = '*.java',
    callback = function(opts)
        if vim.api.nvim_eval('processing') == 1 then
            vim.api.nvim_buf_set_lines(0, 0, 3, false, {})
            local num_lines = vim.api.nvim_buf_line_count(0)
            vim.api.nvim_buf_set_lines(0, num_lines - 1, num_lines, false, {})
            vim.cmd("%norm 0xxxx")

            vim.cmd("silent sav " .. vim.api.nvim_buf_get_name(0):gsub("%..*", ".pde"))
            vim.cmd("silent !rm " .. vim.api.nvim_buf_get_name(0):gsub("%..*", ".java"))
            vim.cmd("let processing = 0")
        end
    end,
})
