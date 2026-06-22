vim.keymap.set({ 'n', 'v' }, 'gx', function()
    local dir = vim.b.netrw_curdir
    local file = vim.fn.expand('<cfile>')
    local absolute_path = vim.fn.fnameescape(dir .. '/' .. file)
    vim.ui.open(absolute_path)
end, { buffer = true, desc = 'Opens filepath or URI under cursor with the system handler' })
