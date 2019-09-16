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
set bs=2

"Add comment to Elixir
iabbrev privatecom <cr># ---------------------------------------------<cr>#                    PRIVATE<cr># ---------------------------------------------

"Adds quotation marks around the word where the cursor is
nnoremap <leader>" mZbi"<esc>ea"<esc>`Z

"Command for creating IO."inspects
"Example:
":IO var -> IO.inspect(var, label: Var)
":IO > -> |> IO.inspect(label: <the first word above>)
"TODO: pune sa fie pe rand nu sub el
"TODO: this will break: 'unique_constraint(:email)' <- fix it
"TODO: this will break: 'end)' <- fix it
"TODO: this will break: 'k' followed by IO |> <- fix it
"TODO: this will break: '}'
command! -nargs=1 IO call s:IOInspect(<f-args>)
function! s:IOInspect(label)
  if a:label =~ ">"
    execute 'normal! Vy'
    let l:line = @"

    let l:word = substitute(l:line, '^\s*[|>]*\s*', '', '')
    let l:word = substitute(l:word, '[\(\[\?]', ' ', '')

    "TODO: split can be replaced with something better
    let l:word = split(l:word)[0]

    execute 'normal! mZo|> IO.inspect(label: ' . l:word. "\<esc>" . 'bvUA)' . "\<esc>" . '`Z'
  else
    execute 'normal! mZoIO.inspect('. a:label . ', label: ' .  a:label . "\<esc>" . 'bvU' . 'A)' . "\<esc>" . '`Z'
  endif
endfunction

"Shortcut for Ack!
command! -nargs=1 A Ack! <f-args>

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

"Delete from cursor to end without copying
nnoremap <S-d> v$h"_d

"Delete and insert without copying
nnoremap s "_s
vnoremap s "_s

"find in current directory"
set path=$PWD/**

"copy to clipboard
vnoremap <C-c> :w !pbcopy<CR><CR>

"faster scroll"
noremap <C-j> 4j
noremap <C-k> 4k

"Resize window vertically -----------------------{{{
nnoremap <leader>rk :resize +5<CR>
nnoremap <leader>rj :resize -5<CR>
nnoremap <leader>rl :vertical resize -5<CR>
nnoremap <leader>rh :vertical resize +5<CR>
" }}}

au FocusGained,BufEnter * :silent! !
au FocusLost,WInLeave * :wa

"Toggle NerdTree"
nnoremap <S-m> :NERDTreeToggle<CR>

"HTML syntax highlight"
au BufReadPost *.html set syntax=html

"Highlight search"
set hlsearch incsearch

:let mapleader = "-"

"Comment/uncomment visually selected lines
vnoremap <leader>c :call Comment()<cr>
function! Comment()
  let line = getline('.')

  execute 'normal! mZ'

  if line != ''
    call Comment_or_uncomment(line)
  endif

  execute 'normal! V`Z='
endfunction
"TODO: remove sequences of '#'
function! Comment_or_uncomment(line)
  let l:comment_symbol = '#'
  if a:line =~ '^\s\+' . l:comment_symbol
    execute 'normal! 0f' . l:comment_symbol . 's' . "\<esc>"
  elseif a:line =~ '^#'
    execute 'normal! 0s'
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

:inoremap <leader>U <esc>mZviwU`Z

"Return to normal mode when jk/kj
:inoremap jk <esc>

" Operator ------------------------------ {{{
:onoremap p :<c-u>normal! mzf(vi(<cr>`z
:onoremap P :<c-u>normal! mzF(vi(<cr>`z

:onoremap s :<c-u>normal! mzf[vi[<cr>`z
:onoremap S :<c-u>normal! mzF[vi[<cr>`z

:onoremap c :<c-u>normal! mzf{vi{<cr>`z
:onoremap C :<c-u>normal! mzF{vi{<cr>`z

:onoremap " :<c-u>normal! mzf"vi"<cr>`z
" }}}

" Abbreviations -------------------------- {{{
:iabbrev > \|>

:iabbrev defm <esc>gg:call ProcessModuleName()<cr>
function! ProcessModuleName()
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

  "Too slow for big files
  ":autocmd BufWritePre *.exs :normal! =G
  ":autocmd BufWritePre *.ex :normal! =G

  :autocmd! FileType elixir :iabbrev cased case<space><esc>mai do<esc>oend<esc>`ai
  :autocmd! FileType elixir :iabbrev defd def<space>do<cr>end<esc>kwi<esc>i
:augroup END
" }}}
