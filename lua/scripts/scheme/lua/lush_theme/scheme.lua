--
-- Built with,
--
--        ,gggg,
--       d8""8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP""8I
-- dP""88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
-- "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

local lush = require('lush')
local hsl = lush.hsl

-- s/\(.*\)\( {\)/\=submatch(1)..repeat(" ",36-strlen(submatch(1))).."{"
---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
    local sym = injected_functions.sym
    return {
        base_color                  { fg = hsl(220, 50, 60) },
        base_color_2                { fg = base_color.fg.abs_da(10) },
        base_color_3                { fg = base_color.fg.abs_da(20) },
        base_color_4                { fg = base_color.fg.abs_da(30) },
        base_color_5                { fg = base_color.fg.abs_da(40) },
        base_color_6                { fg = base_color.fg.abs_da(50) },

        white_color                 { fg = hsl(0, 0, 80) },
        black_color                 { fg = hsl(0, 0, 10) },
        purple_color                { fg = base_color.fg.ro(60) },
        red_color                   { fg = base_color.fg.ro(120) },
        yellow_color                { fg = base_color.fg.ro(180) },
        green_color                 { fg = base_color.fg.ro(240) },
        sea_color                   { fg = base_color.fg.ro(300) },

        -- UI
        Normal                      { bg = base_color_6.fg, fg = base_color.fg },
        NormalNC                    { bg = base_color_6.fg.abs_li(5), fg = base_color.fg },
        ColorColumn                 { bg = base_color_4.fg },
        CursorLine                  { bg = base_color_5.fg },
        LineNr                      { fg = base_color_3.fg },
        CursorLineNr                { fg = base_color.fg },
        StatusLine                  { bg = base_color_5.fg, fg = base_color_2.fg },
        StatusLineNC                { bg = base_color_4.fg, fg = base_color_1.fg },
        Pmenu                       { fg = base_color_2.fg, bg = base_color_5.fg },
        PmenuSel                    { bg = base_color_4.fg },
        PmenuSbar                   { bg = base_color_3.fg },
        PmenuThumb                  { bg = base_color_4.fg },
        MatchParen                  { bg = base_color_3.fg },

        -- Purple
        Question                    { fg = purple_color.fg },
        PreProc                     { fg = purple_color.fg.abs_da(10) },
        Title                       { fg = purple_color.fg.abs_sa(40) },

        -- Red
        Visual                      { bg = red_color.fg.abs_da(30).abs_sa(30) },
        DiffDelete                  { bg = red_color.fg.abs_da(30) },

        -- Yellow
        Search                      { fg = black_color.fg, bg = yellow_color.fg.abs_sa(40) },
        IncSearch                   { Search },
        Substitute                  { Search },
        SpecialKey                  { yellow_color },
        Statement                   { yellow_color },
        Special                     { fg = yellow_color.fg.abs_sa(40) },
        DiffChange                  { bg = yellow_color.fg.abs_da(30) },

        -- Green
        Type                        { fg = green_color.fg },
        Directory                   { fg = green_color.fg.abs_da(20) },
        MoreMsg                     { fg = green_color.fg.abs_da(30) },
        DiffAdd                     { bg = green_color.fg.abs_da(30) },

        -- Sea
        ModeMsg                     { fg = sea_color.fg },
        NonText                     { fg = sea_color.fg.abs_da(30) },

        -- Text
        text_color                  { fg = base_color.fg },
        sym"@text.literal"          { text_color },
        comment_color               { fg = hsl(228, 41, 37) },
        Comment                     { comment_color },
        sym"@comment"               { comment_color },

        -- Primitives
        string_color                { fg = hsl(183, 17, 46) },
        sym"@string"                { string_color },
        character_color             { string_color },
        sym"@character"             { string_color },
        number_color                { fg = hsl(295, 50, 55) },
        sym"@number"                { number_color },
        sym"@float"                 { number_color },
        boolean_color               { fg = hsl(310, 64, 41) },
        sym"@boolean"               { boolean_color },

        -- Variables
        variable_color              { fg = hsl(204, 69, 48) },
        Identifier                  { variable_color },
        sym"@variable"              { variable_color },
        sym"@field"                 { variable_color },
        constant_color              { boolean_color },
        Constant                    { constant_color },
        sym"@constant"              { constant_color },
        sym"@constant.builtin"      { constant_color },
        sym"@lsp.type.property"     { },
        paramater_color             { fg = hsl(272, 74, 46), gui = 'italic' },
        sym"@parameter"             { paramater_color },
        sym"@variable.parameter"    { paramater_color },
        sym"@lsp.type.parameter"    { paramater_color },

        -- Functions
        function_color              { fg = hsl(267, 37, 48) },
        sym"@function"              { function_color },
        sym"@function.builtin"      { function_color },
        sym"@method"                { function_color },
        sym"@method.call"           { function_color },
        sym"@lsp.type.method"       { function_color },
        sym"@lsp.type.function"     { function_color },
        sym"@lsp.mod.constructor"   { function_color },

        -- Keywords
        keyword_color               { fg = hsl(108, 35, 49) },
        sym"@keyword"               { keyword_color },
        sym"@conditional"           { keyword_color },
        sym"@repeat"                { keyword_color },
        sym"@type.qualifier"        { keyword_color },
        sym"@exception"             { keyword_color },
        sym"@type.builtin"          { keyword_color, gui = 'italic' },

        -- Pre Processors
        pre_proc_color              { fg = hsl(210, 60, 33) },
        sym"@include"               { pre_proc_color },

        -- Types and Classes
        type_color                  { fg = hsl(329, 42, 51) },
        sym"@type"                  { type_color },
        sym"@lsp.type.enum"         { type_color },
        sym"@lsp.type.class"        { type_color },
        sym"@lsp.type.struct"       { type_color },
        sym"@lsp.type.interface"    { type_color },
        sym"@storageclass.lifetime" { type_color },
        namespace_color             { fg = hsl(45, 100, 87), gui = 'italic' },
        sym"@namespace"             { namespace_color },
        sym"@lsp.type.namespace"    { namespace_color },

        -- Other Characters
        special_char_color          { boolean_color },
        sym"@string.escape"         { special_char_color },
        punctuation_color           { fg = base_color.fg },
        sym"@punctuation.delimiter" { punctuation_color },
        bracket_color               { fg = hsl(355, 47, 37) },
        sym"@constructor.lua"       { bracket_color },
        sym"@punctuation.bracket"   { bracket_color },
        operator_color              { pre_proc_color },
        sym"@operator"              { operator_color },

        -- Errors
        error_color                 { fg = red_color.fg.abs_da(10).abs_sa(50) },
        Error                       { bg = error_color.fg, fg = white_color.fg },
        ErrorMsg                    { Error },
        WarningMsg                  { Error },
        DiagnosticError             { error_color },
        DiagnosticDeprecated        { error_color, gui = 'strikethrough' },

        -- Warnings
        warning_color               { yellow_color },
        Todo                        { warning_color },
        DiagnosticWarn              { warning_color },
        DiagnosticUnnecessary       { warning_color },

        -- Suggestions
        suggestion_color            { white_color },
        DiagnosticInfo              { suggestion_color },
        DiagnosticHint              { suggestion_color },

        -- Success
        success_color               { fg = green_color.fg.abs_sa(10) },
        DiagnosticOk                { success_color },

        -- Trouble
        TroubleTextInformation      { fg = Normal.fg },
        TroubleTextError            { fg = Normal.fg },
        TroubleTextWarning          { fg = Normal.fg },
        TroubleTextHint             { fg = Normal.fg },
    }
end)

-- Return our parsed theme for extension or use elsewhere.
return theme
