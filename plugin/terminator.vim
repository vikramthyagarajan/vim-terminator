rubyfile ~/programmingstuff/vimstuff/vim-terminator/lib/window-manager.rb

"setting defaults for the WindowManager
let columns = &columns
let lines = &lines
ruby WindowManager.initialize(VIM::evaluate('columns'), VIM::evaluate('lines'))

function! StartTerminator()
ruby WindowManager.createTerminatorWindow()
endfunction

function! ShowTerminator()
ruby WindowManager.showTerminator()
endfunction

function! HideTerminator()
ruby WindowManager.hideTerminator()
endfunction

function! TestWin()
ruby puts WindowManager.columns
endfunction
