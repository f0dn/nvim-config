local dotfiles_git_dir = vim.fn.expand("~/.dotfiles")

local function smart_git()
    if vim.fn.FugitiveGitDir() == '' then
        vim.fn.FugitiveDetect(dotfiles_git_dir)
    end

    vim.cmd.Git()
end

vim.api.nvim_create_user_command('Dot', function(opts)
    vim.fn.FugitiveDetect(dotfiles_git_dir)

    local cmd = vim.fn["fugitive#Command"](
        opts.line1,
        opts.count,
        opts.range > 0 and 1 or 0,
        opts.bang and 1 or 0,
        "",
        opts.args
    )

    local ok, err = pcall(vim.cmd, cmd)

    if not ok then
        error(err)
    end
end, {
    bang = true,
    nargs = "?",
    range = true,
    complete = function(...)
        return vim.fn["fugitive#Complete"](...)
    end,
})
vim.keymap.set('n', '<leader>g', smart_git, { desc = 'Open Git status' })
