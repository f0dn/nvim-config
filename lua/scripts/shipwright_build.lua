local colorscheme = require('scripts.scheme.lua.lush_theme.scheme')
local lushwright = require('shipwright.transform.lush')

run(colorscheme,
    lushwright.to_vimscript,
    {overwrite, "lua/scripts/scheme/scheme.vim"}
)
