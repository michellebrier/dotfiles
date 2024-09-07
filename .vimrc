" VIM Configuration - Michelle Brier

" Cancel the compatibility with Vi. Essential if you want
" to enjoy the features of Vim
set nocompatible

" Activate pathogen
" If fzf installed using Homebrew on Apple Silicon:
" call pathogen#infect('bundle/{}', '/opt/homebrew/opt/fzf')
" Otherwise:
call pathogen#infect('bundle/{}', '/usr/local/opt/fzf')

" -- Display
set title                 " Update the title of your window or your terminal
set number                " Display line numbers
set ruler                 " Display cursor position
set wrap                  " Wrap lines when they are too long

set scrolloff=3           " Display at least 3 lines around you cursor
		  " (for scrolling)

set guioptions=T          " Enable the toolbar

" -- Search
set ignorecase            " Ignore case when searching
set smartcase             " If there is an uppercase in your search term
		  " search case sensitive again
set incsearch             " Highlight search results when typing
set hlsearch              " Highlight search results

set confirm
" -- Beep
set visualbell            " Prevent Vim from beeping
set noerrorbells          " Prevent Vim from beeping
set t_vb=

" Backspace behaves as expected
set backspace=indent,eol,start

" Hide buffer (file) instead of abandoning when switching
" to another buffer
" Allow having multiple files open and page through them with :bp and :bn.
" When switching files, preserve cursor location
set hidden
set nostartofline

" Automatically refresh files that haven't been edited by Vim
set autoread

" Trigger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Enable syntax highlighting
syntax enable

" Set syntax and indentations based on filetype, but use 2 space tabs and
" expand tabs to spaces
filetype indent plugin on
set autoindent
set shiftwidth=2
set softtabstop=2
set expandtab
syntax on

" Use the dark version of Solarized color scheme
" set background=dark
" let g:solarized_termcolors = 256
" colorscheme solarized

" Use ghdark color scheme
colorscheme ghdark

" Disabling the directional keys
map <up> <nop>
map <down> <nop> 
map <left> <nop> 
map <right> <nop> 
imap <up> <nop> 
imap <down> <nop> 
imap <left> <nop> 
imap <right> <nop>

" make Y act the same as D (copy to the end of the line)
map Y y$

vnoremap y y:call system('pbcopy', @")<CR>

" Replace esc key
" jj acts the same as escape. To type jj, have a 200ms timeout
inoremap jj <ESC>
set notimeout ttimeout ttimeoutlen=200

" Set leader key
let mapleader = ","

" jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1 " default 0
let g:vim_jsx_pretty_enable_jsx_highlight = 1

" ale
nmap <silent> <C-n> :ALENext<cr>
nmap <silent> <C-m> :ALEPrevious<cr>

let g:ale_fix_on_save = 1

let b:ale_fixers = {
\ 'javascript': ['prettier', 'eslint'],
\ 'typescript': ['prettier', 'eslint'],
\ 'json': ['prettier'],
\ 'css': ['prettier'],
\ 'python': ['flake8', 'pylint', 'isort', 'black'],
\}

" Because eslint and flow don't play well, we have to specify fixers and
" linters separately,
" From:
" https://www.reddit.com/r/vim/comments/94g7nx/help_request_ale_eslint_and_flow_getting_them_to/
let b:ale_linters = {
\ 'javascript': ['prettier', 'flow-language-server', 'eslint'],
\ 'javascriptreact': ['prettier', 'flow-language-server', 'eslint'],
\ 'typescript': ['prettier', 'eslint'],
\ 'typescriptreact': ['prettier', 'eslint'],
\ 'json': ['prettier'],
\ 'python': ['flake8', 'pylint', 'isort', 'black'],
\}

" Specify prettier and rubocop config
let g:ale_javascript_prettier_options = '--no-bracket-spacing --trailing-comma es5'

" Cntrl+L to clear highlighting/search results
nnoremap <C-L> :nohl<CR><C-L>

" coc configuration
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Always display last command and use a second line
" Give more space for displaying messages.
set laststatus=2
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" fzf
" If installed using Homebrew on Apple Silicon:
" set rtp+=/opt/homebrew/opt/fzf
" If installed using Homebrew:
set rtp+=/usr/local/opt/fzf

" Autocomplete : commands and show the last command
set wildmenu
set showcmd

" see current filename in status line
set statusline+=%F

" vv to generate new vertical vim split
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" vim-tmux-navigator
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" <ctrl>+j/k/h/l to switch vim panes
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" vimux
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" fzf-vim
nnoremap <silent> <C-f> :GFiles<CR>

" Rg
nnoremap <silent> <Leader>f :Rg<CR>

" vim-polyglot vim-python syntax highlighting
let g:python_highlight_all = 1

" vim-gitgutter
highlight SignColumn guibg=#000000 ctermbg=Black
