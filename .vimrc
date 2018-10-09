" Some Linux distributions set filetype in /etc/vimrc.
" Clear filetype flags before changing runtimepath to force Vim to reload them.
execute pathogen#infect()
syntax on
filetype indent on

set number
:highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

"Delete instead of cut in visual mode when pressing d"
nnoremap d "_d
vnoremap d "_d

"Find in current directory"
set path=$PWD/**

"Faster scroll"
noremap <C-j> 4j
noremap <C-k> 4k
noremap <C-l> 4l
noremap <C-h> 4h

au FocusGained,BufEnter * :silent! !
au FocusLost,WInLeave * :wa

"Toggle NerdTree"
noremap <S-m> :NERDTreeToggle<CR>

"HTML syntax highlight"
au BufReadPost *.html set syntax=html

"Highlight search"
set hlsearch

"copy to clipboard
vmap <c-c> :w !pbcopy<CR><CR>

"Delets the last character on every line from
"the cursor position until the specified line no"
command! -nargs=* Rl call RemoveLastCharacter(<f-args>)
function RemoveLastCharacter(n_line)
  let c = 0
  if a:n_line < line(".")
    echo "Select the line number the function is going to run to"
    return 1
  endif

  let ln = a:n_line - line(".")
  while(c <= ln)
    :execute "normal! \<S-a>\<esc>s\<esc>0j"
    let c += 1
  endwhile
endfunction

"Add # at the beginning of every line from
"the cursor position until the specified line no"
command! -nargs=* Cm call Comment(<f-args>)
function Comment(n_line)
  let c = 0
  if a:n_line < line(".")
    echo "Select the line number the function is going to run to"
    return 1
  endif

  let ln = a:n_line - line(".")
  while(c <= ln)
    :execute "normal! 0i#\<esc>j"
    let c += 1
  endwhile
endfunction


"Add character at the end  of every line from
"the cursor position until the specified line no"
command! -nargs=* Add call AddCharacter(<f-args>)
function AddCharacter(n_line, char)
  let c = 0
  if a:n_line < line(".")
    echo "Select the line number the function is going to run to"
    return 1
  endif

  let ln = a:n_line - line(".")
  while(c <= ln)
    :execute "normal! \<S-a>" . a:char . "\<esc>j"
    let c += 1
  endwhile
endfunction
