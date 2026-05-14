vim.g.copilot_assume_mapped = true
vim.g.netrw_banner = 0;

local options = {
    hlsearch = false,
    ignorecase = true,

    background = 'dark',
    termguicolors = true,
    winborder = 'rounded',

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,

    rnu = true,
    nu = true,
    scl = 'number',

    swapfile = false,
    backup = false,
    undofile = true,
    undodir = os.getenv('HOME') .. '/.nvim/undodir',

    cursorline = true,
    colorcolumn = '80',
    scrolloff = 15,
    wrap = false,
}

for key, value in pairs(options) do
    vim.opt[key] = value
end
