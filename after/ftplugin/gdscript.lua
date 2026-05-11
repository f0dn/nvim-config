local port = os.getenv('GDScript_Port') or '6005'
local cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port))
local pipe = '/tmp/godot.pipe'

-- fix default created files
vim.cmd('%s/\\t/    /ge')

vim.lsp.start({
    name = 'Godot',
    cmd = cmd,
    root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
    on_attach = function(_, _)
        vim.cmd('silent echo serverstart("' .. pipe .. '")')
    end
})

local group = vim.api.nvim_create_augroup('GDScript', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
    desc = 'Stop the GDScript server when leaving the buffer',
    group = group,
    callback = function()
        vim.cmd('silent echo serverstop("' .. pipe .. '")')
    end
})
