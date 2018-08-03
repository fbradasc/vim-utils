function! AddDirectoryHelper(srcfiles, topsrcdir, menuname)
  silent! let first_buffer = bufnr("$")
  silent! let counter = 0
  while counter < len(a:srcfiles)
    if filereadable(a:srcfiles[counter])
      silent! execute "bad" a:srcfiles[counter]
      " silent! let menuitem0 = substitute(a:srcfiles[counter], '^' . a:topsrcdir, '', "g")
      silent! let menuitem0 = strpart(a:srcfiles[counter], strlen(a:topsrcdir))
      silent! let menuitem1 = substitute(menuitem0, '^[\.\/]*', a:menuname, "g")
      silent! let menuitem2 = substitute(menuitem1, '[\\/]', '/', "g")
      silent! let menuitem3 = substitute(menuitem2, '\.', '\\.', "g")
      silent! let menuitem4 = substitute(menuitem3, '\/', '.', "g")
      silent! execute "an" menuitem4 . " :b " . a:srcfiles[counter] . "<CR>"
    endif
    let counter = counter + 1
  endwhile
endfunction

function! s:UpdateCtagsAndCscopeDb()
  if has('cscope')
    silent! let extensions = [""*.cxx"", ""*.cpp"", ""*.h"", ""*.hpp"", ""*.inl"", ""*.c"", ""*.java""]
    silent! let update_file_list = "find . -iname " . join(extensions, " -o -name ") . " > ./cscope.files"
    silent! echo update_file_list
    silent! echo system(update_file_list)
    silent! echo system("cscope -bq")
    silent! echo system("ctags --tag-relative=yes -R .")
    silent! cscope kill 0
    silent! cscope add .
  endif
endfunction

function! s:ClearDirectory()
  silent! execute "aun" "Directory"
  silent! execute "1,".bufnr("$")."bw!"
  silent! execute "an Directory.Add :call <SID>AddDirectory('')<CR>"
endfunction

function! s:AddDirectory(topdir)
  if getftype(a:topdir) != "dir"
    silent! let topsrcdir = substitute(browsedir("Select the topmost source dir", getcwd()), "\\", "/", "g")
    if getftype(topsrcdir) != "dir"
      return
    endif
  else
    silent! let topsrcdir = a:topdir
  endif
  silent! execute ":cd " . topsrcdir 
  silent! let topsrcdir = getcwd()
  silent! call s:UpdateCtagsAndCscopeDb()
  silent! call s:ClearDirectory()
  silent! execute "an Directory.Clear  :call <SID>ClearDirectory()<CR>"
  silent! execute "an Directory.Rescan :call <SID>AddDirectory('" . topsrcdir . "')<CR>"
  silent! execute "an Directory.-sep1- <nop>"

  silent! let first_buffer = bufnr("$")

  "
  "---------------------
  " Adding Files
  "---------------------
  "
  silent! let srcfiles = []
  silent! let srcfiles += split(globpath(topsrcdir, "**/*"))
  silent! call sort(srcfiles)
  silent! call filter(srcfiles, 'v:val !~ "\\.o\\>"')
  silent! call filter(srcfiles, 'v:val !~ "\\.so"')
  silent! call filter(srcfiles, 'v:val !~ "\\.svn\\>"')
  silent! call filter(srcfiles, 'v:val !~ "\\.git\\>"')
  silent! call filter(srcfiles, 'v:val !~ "CVS"')
  silent! call AddDirectoryHelper(srcfiles,topsrcdir,"Directory/Files/")

  silent! execute "b" first_buffer+1
endfunction

" Avoid installing the menus twice
if !exists("did_directory_menus")
    let did_directory_menus = 1
    silent! execute "an Directory.Add :call <SID>AddDirectory('')<CR>"
endif
" command! -nargs=0 PRJ call s:RunDirectory()
