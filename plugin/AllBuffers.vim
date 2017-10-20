function! AllBuffers(cmnd)
  let cmnd = a:cmnd
  let i = 1
  while (i <= bufnr("$"))
    if bufexists(i)
      execute "buffer" i
      execute cmnd
    endif
    let i = i+1
  endwhile
endfunction

fun! AllWindows(cmnd)
    let cmnd = a:cmnd
    let origw = winnr()
    let i = 1
    while (i <= bufnr("$"))
        if bufexists(i)
            let w = bufwinnr(i)
            if w != -1
                echo "=== window: " . w . " file: " . bufname(i)
                execute "normal \<c-w>" . w . "w"
                execute cmnd
            endif
        endif
        let i = i+1
    endwhile
    execute "normal \<c-w>" . origw . "w"
endfun

function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction

function! BufDo(command)
let currBuff=bufnr("%")
execute 'bufdo ' . a:command
execute 'buffer ' . currBuff
endfunction
