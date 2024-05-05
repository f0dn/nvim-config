"return" @keyword
"exit" @keyword
"decl" @keyword
"if" @keyword
"func" @keyword
"for" @keyword
"mac" @keyword
"use" @keyword

"+" @operator
"-" @operator
"*" @operator
"/" @operator
"%" @operator
"!" @operator
"=" @operator
"==" @operator
"<" @operator
">" @operator
"@" @operator
"&" @operator
"&&" @operator
"||" @operator

"#" @constant

"(" @punctuation.bracket
")" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
"`" @string

";" @punctuation.delimiter

(int) @number
(str) @string
(identifier) @variable
(comment) @comment

((path) @namespace (#set! "priority" 110))
(use import: (identifier) @function)
(function name: (identifier) @function)
(call name: (identifier) @function)
(macro name: (identifier) @function)
(macro_call name: (identifier) @function)
(function arg: (identifier) @parameter)
(macro_arg name: (identifier) @parameter)
((identifier) @parameter.reference (#is? @parameter.reference parameter))
