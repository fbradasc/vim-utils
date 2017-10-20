if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1
if !exists('g:arduino_did_initialize')
  call arduino#LoadCache()
  call arduino#InitializeConfig()
  let g:arduino_did_initialize = 1
endif

" Use C rules for indentation
setl cindent

call arduino#RebuildMakePrg()

if g:arduino_auto_baud
  au BufReadPost,BufWritePost *.ino,*.pde call arduino#SetAutoBaud()
endif

" command! -buffer -bar -nargs=? ArduinoChooseBoard call arduino#ChooseBoard(<f-args>)
" command! -buffer -bar -nargs=? ArduinoChooseProgrammer call arduino#ChooseProgrammer(<f-args>)
" command! -buffer -bar ArduinoVerify call arduino#Verify()
" command! -buffer -bar ArduinoUpload call arduino#Upload()
" command! -buffer -bar ArduinoSerial call arduino#Serial()
" command! -buffer -bar ArduinoUploadAndSerial call arduino#UploadAndSerial()
" command! -buffer -bar -nargs=? ArduinoChoosePort call arduino#ChoosePort(<f-args>)

command! -bar          ArduinoVerify           call arduino#Verify()
command! -bar          ArduinoUpload           call arduino#Upload()
command! -bar          ArduinoSerial           call arduino#Serial()
command! -bar          ArduinoUploadAndSerial  call arduino#UploadAndSerial()
command! -bar -nargs=? ArduinoChooseBoard      call arduino#ChooseBoard(<f-args>)
command! -bar -nargs=? ArduinoChooseProgrammer call arduino#ChooseProgrammer(<f-args>)
command! -bar -nargs=? ArduinoChoosePort       call arduino#ChoosePort(<f-args>)

execute "an Plugin.Arduino.Verify               :ArduinoVerify<CR>"
execute "an Plugin.Arduino.Upload               :ArduinoUpload<CR>"
execute "an Plugin.Arduino.Serial               :ArduinoUpload<CR>"
execute "an Plugin.Arduino.Upload\ and\ Monitor :ArduinoUploadAndSerial<CR>"
execute "an Plugin.Arduino.Choose.Board         :ArduinoChooseBoard<CR>"
execute "an Plugin.Arduino.Choose.Programmer    :ArduinoChooseProgrammer<CR>"
execute "an Plugin.Arduino.Choose.Port          :ArduinoChoosePort<CR>"
