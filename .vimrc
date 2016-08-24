"NeoBundle Scripts-----------------------------
if &compatible
	set nocompatible " Be iMproved
endif

" Required:
set runtimepath^=$HOME/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('$HOME/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neocomplete'
NeoBundle  'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'miyakogi/seiya.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'

"for vim-surround
"任意のキーに割り当てられる
"1(!の意味)に<!-- -->を割り当てた
let g:surround_{char2nr("1")} = "<!--\r-->"
nm <Leader>1 ysiw1
nm <Leader><Leader>1 yss1
xm <Leader>1 S1
"カーソル下の単語のsurrounding
nm <Leader>{ ysiw{
nm <Leader>} ysiw}
nm <Leader>[ ysiw[
nm <Leader>] ysiw]
nm <Leader>( ysiw(
nm <Leader>) ysiw)
nm <Leader>< ysiw<
nm <Leader>> ysiw>
nm <Leader>" ysiw"
nm <Leader>' ysiw'
nm <Leader>` ysiw`
nm <Leader>* ysiw*
"カーソル下の行のsurrounding
nm <Leader><Leader>{ yss{
nm <Leader><Leader>} yss}
nm <Leader><Leader>[ yss[
nm <Leader><Leader>] yss]
nm <Leader><Leader>( yss(
nm <Leader><Leader>) yss)
nm <Leader><Leader>< yss<
nm <Leader><Leader>> yss>
nm <Leader><Leader>" yss"
nm <Leader><Leader>' yss'
nm <Leader><Leader>` yss`
nm <Leader><Leader>* yss*
"ビジュアルモードで選択時のsurrounding
xm { S{
xm } S}
xm [ S[
xm ] S]
xm ( S(
xm ) S)
xm < S<
xm > S>
xm " S"
xm ' S'
xm ` S`
xm * S*
" **2つでかこめる**
xm <Leader>* S*gvS*

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

let g:seiya_auto_enable=1

colorscheme badwolf
" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

"NeoComplete---------------------
"Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/.vimshell_hist',
			\ 'scheme' : $HOME.'/.gosh_completions'
			\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
	For no inserting <CR> key.
	"return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^.\t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"End Neocomplete-----------------------------

" vimのtab機能------------------------------
" Anywhere SID.
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnrs = tabpagebuflist(i)
        let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
        let no = i  " display 0-origin tabpagenr.
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = fnamemodify(bufname(bufnr), ':t')
        let title = '[' . title . ']'
        let s .= '%'.i.'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= no . ':' . title
        let s .= mod
        let s .= '%#TabLineFill# '
    endfor
    let s .= '%#TabLineFill#%T%=%#TabLine#'
    return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=1 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1
" で1番左のタブ、t2
" で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc
" 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx
" タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
" End tab機能-------------------------------

"vi互換をキャンセル
set nocompatible

autocmd FileType * setlocal formatoptions-=ro

imap <C-j> <C-[>

set backspace=start,eol,indent

set showmatch

set number

set title

syntax on

"hi Comment ctermfg=red

"hi Constant ctermfg=Lightblue

hi LineNr ctermfg=Cyan

"hi Identifier ctermfg=Lightgrey

set incsearch

set tabstop=4

set shiftwidth=4

set expandtab

set autoindent
set smartindent

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.pm setlocal tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 shiftwidth=2
augroup END

set whichwrap=b,s,h,l,<,>,[,]

set laststatus=2
"ff: ファイルフォーマット
"\%03.3b: ASCII
"\%02.2B: HEX
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

"クリップボードにコピーを有効
set clipboard=unnamed,autoselect

augroup BUFWRITE_POSTDELETE
	au!
	autocmd BufWritePOST * call BufWritePostDelete()
augroup END

function! BufWritePostDelete()
	let crlen=0
	if &binary==0
		let crlen = &ff=='dos'?2:1
	endif
	if getfsize(expand('%:p'))<=crlen
		call delete(expand('%:p'))
	endif
endfunction

set cursorline
highlight Cursorline term=underline cterm=underline

highlight Cursor term=underline cterm=underline ctermfg=NONE

set scrolloff=100

"行末の空白自動削除
autocmd BufWritePre * :%s/\s\+$//ge
