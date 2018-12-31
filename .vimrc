" Some Linux distributions set filetype in /etc/vimrc.
" Clear filetype flags before changing runtimepath to force Vim to reload them.
execute pathogen#infect()
syntax on
filetype indent on

set foldlevelstart=99

"Vimscript file settings -----------------------------{{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

let mapleader="-"
" Add lorem ipsum text. The accepted argument is the number of words
command! -nargs=1 Lorem call s:GenerateLorem(<f-args>)
function! s:GenerateLorem(number)
  let l:c = 0
  let l:text = split("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.")
  let l:final = ""

  while l:c < a:number
    let l:final = l:final . ' ' . text[l:c]
    let l:c += 1
  endwhile

  put = l:final
endfunction

set number
:highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

"Delete instead of cut in visual mode when pressing d"
nnoremap d "_d
vnoremap d "_d

"find in current directory"
set path=$PWD/**

"copy to clipboard
vnoremap <C-c> :w !pbcopy<CR><CR>

"faster scroll"
noremap <C-j> 4j
noremap <C-k> 4k

"Resize window vertically -----------------------{{{
nnoremap <leader>wl :resize +5<CR>
nnoremap <leader>wh :resize -5<CR>
nnoremap <leader>vl :vertical resize -5<CR>
nnoremap <leader>vh :vertical resize +5<CR>
" }}}

au FocusGained,BufEnter * :silent! !
au FocusLost,WInLeave * :wa

"Toggle NerdTree"
noremap <S-m> :NERDTreeToggle<CR>

"HTML syntax highlight"
au BufReadPost *.html set syntax=html

"Highlight search"
set hlsearch incsearch

:let mapleader = "-"

"Comment/uncomment visually selected lines
vnoremap <leader>c :call Comment()<cr>
function! Comment()
  let line = getline('.')
  if line != ''
    call Comment_or_uncomment(line)
  endif
endfunction
function! Comment_or_uncomment(line)
  let l:comment_symbol = '#'
  if a:line =~ '^' . l:comment_symbol
    execute 'normal! 0s' . "\<esc>"
  else
    execute 'normal! 0i' . l:comment_symbol . "\<esc>"
  endif
endfunction

"Replace arg1 with arg2. The cursor will stay in place
"Example:
"Before: foo foo
"Cmd: S foo bar
"After: bar bar
command! -nargs=* S call s:Swap(<f-args>)
function! s:Swap(arg1, arg2)
  execute 'normal! mA:%s/' . a:arg1 . '/' . a:arg2 . '/ge|update' . "\<cr>" . '`A'
endfunction

:nnoremap / /\v

:nnoremap <leader>w dd
:nnoremap <leader>ev :split $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

:inoremap <leader>U <esc>viwUeA
:inoremap jk <esc>

" Operator ------------------------------ {{{
:onoremap p :<c-u>normal! mzf(vi(<cr>`z
:onoremap P :<c-u>normal! mzF(vi(<cr>`z

:onoremap s :<c-u>normal! mzf[vi[<cr>`z
:onoremap S :<c-u>normal! mzF[vi[<cr>`z

:onoremap c :<c-u>normal! mzf{vi{<cr>`z
:onoremap C :<c-u>normal! mzF{vi{<cr>`z
" }}}

" Abbreviations -------------------------- {{{
:iabbrev in inspect
:iabbrev defm <esc>gg:call s:ProcessModuleName()<cr>

function! s:ProcessModuleName()
  "Get first line from mix.exs
  execute ':r! sed -n 1p mix.exs'
  execute 'normal! f.d$'

  "get relative path
  let path = expand('%p')

  "Change /[a-z] to .[A-Z]
  let process_path = substitute(path, '/[a-zA-Z]', function('s:Upper'), 'g')
  "Remove from path everything before 'lib'
  let process_path = substitute(process_path, '[a-zA-Z.]\+ib.', '', '')
  "Change _[a-z] to [A-Z]
  let process_path = substitute(process_path, '_[a-zA-Z]', function('s:Camelize'), 'g')
  "Remove from path '.exs?'
  let process_path = substitute(process_path, '.exs\?', '', '')

  "paste
  put = process_path

  execute 'normal! ggddji' . "\<BS>" . '.' . "\<esc>" . 'A do' . "\<cr>" . '@moduledoc false' . "\<cr>" . 'end' . "\<esc>:2\<cr>"
endfunction

function! s:Upper(list)
  return substitute(toupper(a:list[0]), '/', '.', '')
endfunction

function! s:Camelize(list)
  return substitute(toupper(a:list[0]), '_', '', '')
endfunction
" }}}

" Autocmd -------------------------------- {{{
:augroup elixir
  " it removes groups(resets so we don't stach autocmds)
  autocmd!

  :autocmd BufWritePre *.exs :normal! =G

  :autocmd FileType elixir :iabbrev cased case<space><esc>mai do<esc>oend<esc>`ai
  :autocmd FileType elixir :iabbrev defd def<space>do<cr>end<esc>kwi<esc>i
:augroup END

" }}}
