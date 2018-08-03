"                       :SIP - Search in exvim project
"                       ------------------------------
"                        (C) 2004 Francesco Bradascio
"
"                       http://fbradasc.altervista.org
"                          mailto:fbradasc@gmail.com
"
" DESCRIPTION
"
"     This plugin allow you to search the current search pattern in all the
"     files loaded in the exvim project
"
" INSTALLATION
"
"     Copy this file into the VIM plugin directory.
"
" USAGE
"
"     Just do a search in whatsoever way into the current buffer and then
"     run :SIP to process the same search in all the other open buffers.
"
"     Use the quickfix commands (:cn, :cp, ...) to navigate through the
"     patterns found, :cclose to close the found's list, that's all.
"     Do ':help quickfix.txt' for more details.
"
" COPYING POLICY
"
"     This library is free software; you can redistribute it and/or
"     modify it under the terms of the GNU Lesser General Public
"     License as published by the Free Software Foundation; either
"     version 2.1 of the License, or (at your option) any later version.
"
"     This library is distributed in the hope that it will be useful,
"     but WITHOUT ANY WARRANTY; without even the implied warranty of
"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
"     Lesser General Public License for more details.
" 
"     You should have received a copy of the GNU Lesser General Public
"     License along with this library; if not, write to the Free Software
"     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
"

function! s:SetWildignorePattern()
endfunction

function! s:RunSearchInProject()
    "save the original view
    let [origbuf, origview] = [bufnr("%"), winsaveview()]
    let foldenableSave = &foldenable
    set nofoldenable

    cclose
    "create a new, empty quickfix list
    call setqflist([])

"    let all = range(0, bufnr('$'))
"    let files = {}
"    for b in all
"        if bufexists(b) && buflisted(b) && bufname(b) != ""
"            let files[bufname(b)] = bufname(b)
"        endif
"    endfor

    let loc_wig = &wildignore

    if exists("g:exvim_folder")
        let path = g:exvim_folder.'/id-lang-autogen.map'
        if findfile(path) != ""
           set wildignore=
           for line in readfile(path)
                if line =~ 'IGNORE'
                    let line = substitute(line, "[ \t]*IGNORE.*$", "", "")
                    let line = substitute(line, "^\*/", "", "")
                    " let line = substitute(line, "^\(.*/\*\)$", "\1**", "")
                    if &wildignore != ""
                        let &wildignore .= ','
                    endif
                    let &wildignore .= line
                endif
            endfor
        endif
    endif

    :set nomore
    :silent 0verbose noautocmd vimgrep! //gj **
"    :silent 0verbose noautocmd try
"    \ | vimgrepadd! //gj **
"    \ | catch /^Vim\%((\a\+)\)\=:E480/
"    \ | catch /^Vim\%((\a\+)\)\=:E499/
"    \ | endtry
    :set more

    let &wildignore = loc_wig

    "restore the original view for the active window or jump to first match
    exec "buffer " . origbuf
    let &foldenable = foldenableSave
    call winrestview(origview)
    if getqflist() == []
        echoe "E480: No Match: " . @/
    else
        botright copen
        cc
    endif
endfunction

command! -nargs=0 SIP call s:RunSearchInProject()
