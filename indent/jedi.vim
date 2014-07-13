" Vim indent file
" Language: jedi
" Maintainer: Herrington Darkholme
" Latest Revision: 12 July 2014

if exists("b:did_indent")
  finish
endif

unlet! b:did_indent
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetJediIndent()
setlocal indentkeys=o,O,*<Return>,},],0),!^F

" Only define the function once.
if exists("*GetJediIndent")
  finish
endif

if !exists('g:jedi_self_closing_tags')
  let g:jedi_self_closing_tags = 'meta|link|img|hr|br|input'
endif

setlocal formatoptions+=r
setlocal comments+=n:\|

function! GetJediIndent()
  let lnum = prevnonblank(v:lnum-1)
  if lnum == 0
    return 0
  endif
  let line = substitute(getline(lnum),'\s\+$','','')
  let cline = substitute(substitute(getline(v:lnum),'\s\+$','',''),'^\s\+','','')
  let lastcol = strlen(line)
  let line = substitute(line,'^\s\+','','')
  let indent = indent(lnum)
  let cindent = indent(v:lnum)
  let increase = indent + &sw
  echomsg line
  if indent == indent(lnum)
    let indent = cindent <= indent ? -1 : increase
  endif

  let group = synIDattr(synID(lnum,lastcol,1),'name')

  if line =~ '^\s*!html5'
    return indent
  elseif line =~ '^/\%(\[[^]]*\]\)\=$'
    return increase
  elseif line =~ '^:\%(if\|else\|unless\|for\)'
    return increase
  elseif line == '-#'
    return increase
  elseif line =~? '^\v%('.g:jedi_self_closing_tags.')>'
    return indent
  elseif line =~ '\v^[A-z]'
    return increase
  elseif group =~? '\v^%(jediAttributesDelimiter|jediClass|jediId|htmlTagName|htmlSpecialTagName|jediFilter)$'
    return increase
  else
    return indent
  endif
endfunction

" vim:set sw=2:
