require('telescope').setup {
    defaults = {
        hidden = true,
        file_ignore_patterns = { '%.class', '%.bin', '%.dex', '%.flat', '%.lock', '%.jar', '.git/' },
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            }
        },
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    }
}

vim.api.nvim_set_keymap('n', '<leader>pf', ':lua require("telescope.builtin").find_files({ hidden = true })<CR>',
    { noremap = true, silent = true })
