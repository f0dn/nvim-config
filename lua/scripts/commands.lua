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

local copilot_augroup = vim.api.nvim_create_augroup("CopilotToggle", { clear = true })

local function stop_copilot()
    for _, client in pairs(vim.lsp.get_clients()) do
        if client.name == "GitHub Copilot" then
            client.stop()
        end
    end
end

stop_copilot()

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    group = copilot_augroup,
    callback = function()
        vim.cmd("Copilot restart")
        print("Starting Copilot...")
    end,
})

vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    group = copilot_augroup,
    callback = function()
        stop_copilot()
        print("Stopping Copilot due to inactivity.")
    end,
})
