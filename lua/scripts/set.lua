vim.g.copilot_assume_mapped = true
vim.g.netrw_banner = 0;

local options = {
    hlsearch = false,

    background = 'dark',

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    smartindent = true,
    rnu = true,
    nu = true,
    scl = 'number',

    wrap = false,

    scrolloff = 15,

    swapfile = false,
    backup = false,
    undodir = "/home/there/.nvim/undodir",
    undofile = true,

    cursorline = true,

    colorcolumn = '90',
    termguicolors = true,

    ignorecase = true,

    winborder = "rounded",
}

for key, value in pairs(options) do
   vim.opt[key] = value
end
