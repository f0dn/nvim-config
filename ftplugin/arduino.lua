vim.cmd("silent sav " .. vim.api.nvim_buf_get_name(0):gsub("%..*", ".java"))
vim.cmd("silent !rm " .. vim.api.nvim_buf_get_name(0):gsub("%..*", ".pde"))
vim.opt['filetype'] = 'java'
vim.cmd("let processing = 1")

vim.cmd("%norm I    ")
local fname = string.sub(vim.api.nvim_buf_get_name(0), vim.loop.cwd():len() + 2)
local cname = string.gsub(fname, "%..*", ""):gsub(".", string.upper, 1)
vim.api.nvim_buf_set_lines(0, 0, 0, false, { "import processing.core.*;", "", "class " .. cname .. " extends PApplet {" })
local num_lines = vim.api.nvim_buf_line_count(0)
vim.api.nvim_buf_set_lines(0, num_lines, num_lines, false, { "}" })
vim.cmd("silent write")
