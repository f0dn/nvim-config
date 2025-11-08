local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')

telescope.setup {
    defaults = {
        file_ignore_patterns = { '%.class', '%.bin', '%.dex', '%.flat', '%.lock', '%.jar', '.git/', '__pycache__/' },
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            }
        },
    }
}

vim.keymap.set('n', '<leader>pf', function() telescope_builtin.find_files({ hidden = true }) end,
    { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ps',
    function() telescope_builtin.live_grep({ additional_args = function() return { '--hidden' } end }) end,
    { noremap = true, silent = true })
