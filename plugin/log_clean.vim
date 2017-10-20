function! s:LogcatClean()
  :%g/\cipervoice/d
  :%g/\csipmess/d
  :%g/\caudio/d
  :%g/\clinphone/d
  :%g/\cuniconf/d
  :%g/\calarm/d
  :%g/\cupdateser/d
  :%g/\cwdtsys/d
  :%g/\clightservice/d
  :%g/\cuptk/d
  :%g/\cdoorphone/d
  :%g/\cips_/d
  :%g/\cBDIMADLIN/d
  :%g/\curmetsystem/d
  :%g/\cvold/d
  :%g/\cmount/d
  :%g/\cpowerman/d
  :%g/\cpackageman/d
endfunction

function! SetupLogcatClean()
  execute "an <silent> 2.500 ToolBar.-sep8-            <Nop>"
  execute "an <silent> 2.501 ToolBar.LogcatClean       :silent! call <SID>LogcatClean()<CR>"

  execute "tmenu ToolBar.LogcatClean Clean Logcat"
endfunction

" Avoid installing the menus twice
if !exists("log_clean_menus")
  let log_clean_menus = 1
  silent! call SetupLogcatClean()
endif
