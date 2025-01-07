"return" @keyword
"exit" @keyword
"decl" @keyword
"if" @keyword
"else" @keyword
"func" @keyword
"for" @keyword
"mac" @keyword
"use" @keyword
"const" @keyword

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
"," @punctuation.delimiter
"." @punctuation.delimiter

(int) @number
(str) @string
(char) @character
(identifier) @variable
(comment) @comment

(_ path: (identifier) @namespace (#set! "priority" 110))
(function name: (identifier) @function)
(call name: (identifier) @function)
(macro name: (identifier) @function)
(macro_call name: (identifier) @function)
(macro_use name: (identifier) @function)
(function param: (identifier) @parameter)
(macro_arg name: (identifier) @parameter)
((identifier) @parameter.reference (#is? @parameter.reference parameter))
