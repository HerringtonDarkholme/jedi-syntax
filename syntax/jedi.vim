" Vim syntax file
" Language: Jedi
" Maintainer: Herrington Darkholme
" Filenames: *.jedi

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'jedi'
endif

runtime! syntax/html.vim
runtime! syntax/html/html5.vim
" silent! syntax include @htmlCoffeescript syntax/coffee.vim
unlet! b:current_syntax
" silent! syntax include @htmlStylus syntax/stylus.vim
unlet! b:current_syntax
" silent! syntax include @htmlMarkdown syntax/markdown.vim
unlet! b:current_syntax
runtime! syntax/php.vim

syn case match

syn cluster jediTop contains=jediBegin,jediComment,jediSuppression,jediJavascript,jediBlock,jediMixin

syn match   jediBegin "^\s*\%([<>]\|&[^=~ ]\)\@!" nextgroup=jediTag,jediText,jediJavascript,jediScriptConditional,jediScriptStatement,jediAttributes,jediDirective,jediMixin,jediExprOutput

" #jedi-block
syn match   jediBlock "^\s*#\%(\w\|-\)\+"

syn match   jediTag "+\?\w\+\%(:\w\+\)\=" contained contains=htmlTagName,htmlSpecialTagName nextgroup=jediPostfix,@jediComponent skipwhite
syn cluster jediComponent contains=jediAttributes,jediIdChar,jediBlockExpansionChar,jediClassChar,jediText,jediJavascript,jediAssignment
" syn region  jediAttributes matchgroup=jediAttributesDelimiter start="(" end=")" contained contains=@htmlJavascript,jediHtmlArg,htmlArg,htmlEvent,htmlCssDefinition nextgroup=@jediComponent

" @attr = \"{...}\" | @attr = '...'
syn match   jediAttributes "\s*@\%(\w\|-\)\+\s*" contained contains=@htmlJavascript,jediHtmlArg,htmlArg,htmlEvent,htmlCssDefinition nextgroup=jediAttrAssign
syn match   jediAttributes "\s*@@" contained nextgroup=jediAttrName skipwhite
syn match   jediAttrName   "\s*\%(\w\|-\)\+" contained contains=@htmlJavascript,jediHtmlArg,htmlArg,htmlEvent,htmlCssDefinition nextgroup=jediAttrAssign
syn match   jediAttrAssign "\s*=\s*" contained nextgroup=jediAttributeString
syn region  jediAttributeString contained start=+'+ end=+'\s*+ skip=+\\'+ nextgroup=@jediComponent,jediPostfix,jediAttrName
syn region  jediAttributeString contained start=+"+ end=+"\s*+ skip=+\\"+ contains=jediInterpolation nextgroup=@jediComponent,jediPostfix,jediAttrName

" class, id syntactical sugar
syn match   jediClassChar "\." contained nextgroup=jediClass
syn match   jediBlockExpansionChar "\s*>\s*" contained nextgroup=jediTag
syn match   jediIdChar "#{\@!" contained nextgroup=jediId
syn match   jediClass "\%(\w\|-\)\+" contained nextgroup=@jediComponent,jediPostfix skipwhite

" Id must be the last only one
syn match   jediId "\%(\w\|-\)\+" contained nextgroup=jediAttributes,jediBlockExpansionChar,jediText,jediPostfix
syn region  jediDocType start="^\s*\(!html5\)" end="$"
" Unless I'm mistaken, syntax/html.vim requires
" that the = sign be present for these matches.
" This adds the matches back for jedi.
syn keyword jediHtmlArg contained href title

" comment, suppression, text
syn region jediText matchgroup=jediTextQuote start="'" end="'\|$" skip="\\'" contained
syn region jediText matchgroup=jediTextQuote start='"' end='"\|$' contains=jediInterpolation skip='\\"' contained
"
syn match   jediComment '^\%(\s*\)!\%(html5\)\@!.*$'
syn match   jediComment '^\%(\s*\)//.*$'
syn region  jediSuppression start="^\%(\s*\|\t*\)--"  end="$"

syn region  jediInterpolation matchgroup=jediDelimiter start="{" end="}" contains=@htmlJavascript contained
syn match   jediInterpolationEscape "\\\@<!\%(\\\\\)*\\\%(\\\ze#{\|#\ze{\)"

" colon keyword
" syn region jediColon start=":" end="\s*" contains=jediKeyword nextgroup=jediAnyExpr
syn region  jediDirective matchgroup=jediColon start="^\s*:" end="$" contains=jediKeyword,@jediAnyExpr
syn keyword jediExprKeyword contained containedin=jediPostfix if for let else in then
syn keyword jediKeyword contained skipwhite nextgroup=@jediAnyExpr if else for in let import unsafe external

syn match   jediOperators   /[-+&<>]/ contained
syn keyword jediOperators   contained div mul mod
syn region  jediPostfix	    contained start="\v\s+(if|else|let|for)\@=" end="$" nextgroup=@jediAnyExpr
syn region  jediParenthesis start="(" end=")" contained keepend contains=@jediAnyExpr
syn region  jediBrackets    matchgroup=Function start="\[" end="\]" contained keepend contains=@jediAnyExpr
syn match   jediIdentifier  /\<[^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^0-9][^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^]*/ nextgroup=jediAssignment skipwhite contained
syn match   jediAssignment  /=/ nextgroup=@jediAnyExpr skipwhite contained
syn match   jediArgument    /*/ nextgroup=@jediAnyExpr skipwhite contained
syn match   jediNumber      /\<0[bB][01]\+\>/        nextgroup=@jediAnyExpr skipwhite skipempty
syn match   jediNumber      /\<0[oO][0-7]\+\>/       nextgroup=@jediAnyExpr skipwhite skipempty
syn match   jediNumber      /\<0[xX][0-9a-fA-F]\+\>/ nextgroup=@jediAnyExpr skipwhite skipempty
syn match   jediNumber      /[+-]\=\%(\d\+\.\d\+\|\d\+\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syn cluster jediAnyExpr     contains=jediExprKeyword,jediOperators,jediParenthesis,jediBrackets,jediAttributeString,jediNumber,jediIdentifier,jediArgument

" mixin
syn match  jediMixin "::" nextgroup=jediTag

syn region  jediJavascriptFilter matchgroup=jediFilter start="^\z(\s*\):javascript\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript
syn region  jediCoffeescriptFilter matchgroup=jediFilter start="^\z(\s*\):coffeescript\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlCoffeescript
syn region  jediMarkdownFilter matchgroup=jediFilter start=/^\z(\s*\):markdown\s*$/ end=/^\%(\z1\s\|\s*$\)\@!/ contains=@htmlMarkdown
syn region  jediStylusFilter matchgroup=jediFilter start="^\z(\s*\):stylus\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlStylus
syn region  jediPHPFilter matchgroup=jediFilter start="\%(\s*\)--\@!" end="$" contains=@phpClTop
syn region  jediPlainFilter matchgroup=jediFilter start="^\z(\s*\):\%(sass\|less\|cdata\)\s*$" end="^\%(\z1\s\|\s*$\)\@!"

syn region  javascriptParenthesisBlock start="(" end=")" contains=@htmlJavascript contained keepend
syn cluster htmlJavascript add=javascriptParenthesisBlock

syn region  jediExprOutput  start="=" end="$" contained contains=@jediAnyExpr keepend

syn region  jediJavascript start="^\z(\s*\)script\%(:\w\+\)\=" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript,jediJavascriptTag keepend
syn region  jediJavascriptTag contained start="^\z(\s*\)script\%(:\w\+\)\=" end="$" contains=jediBegin,jediTag
syn region  jediCssBlock        start="^\z(\s*\)style" nextgroup=@jediComponent,jediError  end="^\%(\z1\s\|\s*$\)\@!" contains=@jediTop,@htmlCss keepend

syn match  jediError "\$" contained

hi def link jediScriptConditional      PreProc
hi def link jediScriptStatement        PreProc
hi def link jediHtmlArg                htmlArg
hi def link jediBlock                  Identifier
" hi def link jediText                   String
hi def link jediAttributeString        String
hi def link jediAttributesDelimiter    Identifier
hi def link jediIdChar                 Special
hi def link jediClassChar              Special
hi def link jediBlockExpansionChar     Special
hi def link jediId                     Identifier
hi def link jediClass                  Type
hi def link jediDelimiter              Delimiter
" hi def link jediFilter                 PreProc
hi def link jediDocType                PreProc
hi def link jediAttributes             PreProc
hi def link jediComment                Comment
hi def link jediSuppression            jediComment
hi def link jediColon                  PreProc
hi def link jediKeyword                PreProc
hi def link jediExprKeyword			   PreProc
hi def link jediNumber	     		   Number
hi def link jediArgument 			   Type
hi def link jediTextQuote              Keyword
hi def link jediMixin                  Keyword
hi def link jediOperators              Operator

let b:current_syntax = "jedi"

if main_syntax == "jedi"
  unlet main_syntax
endif
