local old_git = vim.cmd.Git

local function git()
    if vim.fn.FugitiveGitDir() == '' then
        local git_dir = vim.fn.expand('~/.dotfiles')
        local work_tree = vim.fn.expand('~')

        vim.fn.FugitiveDetect(git_dir, work_tree)
    end

    old_git()
end

vim.cmd.Git = git

vim.keymap.set('n', '<leader>g', vim.cmd.Git, { desc = 'Open Git status' })
