local function stop_copilot()
    for _, client in pairs(vim.lsp.get_clients()) do
        if client.name == 'GitHub Copilot' then
            client:stop()
        end
    end
end

stop_copilot()

local copilot_augroup = vim.api.nvim_create_augroup('CopilotToggle', { clear = true })

vim.api.nvim_create_autocmd('InsertEnter', {
    desc = 'Start Copilot when entering insert mode',
    pattern = '*',
    group = copilot_augroup,
    callback = function()
        vim.cmd('Copilot restart')
        print('Starting Copilot...')
    end,
})

vim.api.nvim_create_autocmd('CursorHold', {
    desc = 'Stop Copilot after inactivity',
    pattern = '*',
    group = copilot_augroup,
    callback = function()
        stop_copilot()
        print('Stopping Copilot due to inactivity.')
    end,
})
