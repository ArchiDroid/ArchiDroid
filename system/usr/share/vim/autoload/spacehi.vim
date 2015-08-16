" vim600: set foldmethod=marker:
" $Id: spacehi.vim,v 1.4 2014/07/08 15:37:13 laz Exp $
"
" Description:  Per buffer, togglable syntax highlighting of tabs and trailing
"               spaces. 	 	 	 	 	 	 
" Author:       Adam Lazur <adam@lazur.org>
" Last Change:  $Date: 2014/07/08 15:37:13 $
" URL:          http://adam.lazur.org/vim/spacehi.vim
" License:      Redistribution and use of this file, with or without
"               modification, are permitted without restriction.
"
" Section: Documentation {{{1
"
" This plugin will highlight tabs and trailing spaces on a line, with the
" ability to toggle the highlighting on and off. Using highlighting to
" illuminate these characters is preferrable to using listchars and set list
" because it allows you to copy from the vim window without getting shrapnel
" in your buffer.
"
" NOTE: "set list" will override SpaceHi's highlighting.
"
" Highlighting can be turned on and off with the functions SpaceHi() and
" NoSpaceHi() respectively. You can also toggle the highlighting state by
" using ToggleSpaceHi(). By default, ToggleSpaceHi is bound to the key F3.
"
" You can customize the colors by setting the following variables to a string
" of key=val that would normally follow "highlight group" command:
"
"       g:spacehi_spacecolor
"       g:spacehi_tabcolor
"
" The defaults can be found in the "Default Global Vars" section below.
"
" You can give a list of filetypes to exclude 
"
" If you want to highlight tabs and trailing spaces by default for every file
" that is syntax highlighted, you can add the following to your vimrc:
"
"       autocmd syntax * SpaceHi
"
" The author currently uses the following (a little overboard) in his vimrc:
"
"   autocmd BufNewFile,BufReadPost,FilterReadPost,FileReadPost,Syntax * SpaceHi
"   au FileType help NoSpaceHi

" Section: Plugin header {{{1
" If we have already loaded this file, don't load it again.
if exists("loaded_spacehi")
    finish
endif
if !has("syntax")
    finish
else
    let loaded_spacehi=1
endif

" Section: Default Global Vars {{{1
if !exists("g:spacehi_tabcolor")
    " highlight tabs with red underline
    let g:spacehi_tabcolor="ctermfg=1 cterm=underline"
    let g:spacehi_tabcolor=g:spacehi_tabcolor . " guifg=red gui=underline"
endif
if !exists("g:spacehi_spacecolor")
    " highlight trailing spaces in blue underline
    let g:spacehi_spacecolor="ctermfg=4 cterm=underline"
    let g:spacehi_spacecolor=g:spacehi_spacecolor . " guifg=blue gui=underline"
endif

" Section: Functions {{{1
" Function: s:SpaceHi() {{{2
" Turn on highlighting of spaces and tabs
fun s:SpaceHi()
    " highlight tabs
    syntax match spacehiTab /\t/ containedin=ALL
    execute("highlight spacehiTab " . g:spacehi_tabcolor)

    " highlight trailing spaces
    syntax match spacehiTrailingSpace /\s\+$/ containedin=ALL
    execute("highlight spacehiTrailingSpace " . g:spacehi_spacecolor)

    let b:spacehi = 1
endfun

" Function: s:NoSpaceHi() {{{2
" Turn off highlighting of spaces and tabs
fun s:NoSpaceHi()
    syntax clear spacehiTab
    syntax clear spacehiTrailingSpace
    let b:spacehi = 0
endfun

" Function: s:ToggleSpaceHi() {{{2
" Toggle highlighting of spaces and tabs
fun s:ToggleSpaceHi()
    if exists("b:spacehi") && b:spacehi
        call s:NoSpaceHi()
        echo "spacehi off"
    else
        call s:SpaceHi()
        echo "spacehi on"
    endif
endfun

" Section: Commands {{{1
com! SpaceHi call s:SpaceHi()
com! NoSpaceHi call s:NoSpaceHi()
com! ToggleSpaceHi call s:ToggleSpaceHi()

" Section: Default mappings {{{1
" Only insert a map to ToggleSpaceHi if they don't already have a map to
" the function and don't have something bound to F9
if !hasmapto('ToggleSpaceHi') && maparg("<F9>") == ""
  map <silent> <unique> <F9> :ToggleSpaceHi<CR>
endif
