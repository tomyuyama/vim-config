" -------------------------------------------------
" Custom settings
syntax on
filetype plugin indent on
set shiftwidth=2
colorscheme molokai
set nowrap
set splitbelow

" Font setting for gvim (ubuntu), need install Ricty fonts first
set guifont=Ricty\ 12

" -------------------------------------------------
" netrw configurations
" 2014/3/29
"
" always tree view
let g:netrw_liststyle=3
" VSと.で始まるファイルは表示しない
" let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'
" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" " 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1
" open size
let g:netrw_winsize = 80

" -------------------------------------------------
" NeoBundle configuration
" 2014/3/29
" NeoBundle がインストールされていない時、
" " もしくは、プラグインの初期化に失敗した時の処理
function! s:WithoutBundles()
  colorscheme desert
  " その他の処理
endfunction

" NeoBundle よるプラグインのロードと各プラグインの初期化
function! s:LoadBundles()
  " 読み込むプラグインの指定
  NeoBundle 'Shougo/neobundle.vim'
  NeoBundle 'tpope/vim-surround'
  " ...
  " 読み込んだプラグインの設定
  " ...
endfunction

" NeoBundle がインストールされているなら LoadBundles() を呼び出す
" そうでないなら WithoutBundles() を呼び出す
function! s:InitNeoBundle()
  if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    filetype plugin indent off
    if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    try
      call neobundle#rc(expand('~/.vim/bundle/'))
      call s:LoadBundles()
    catch
      call s:WithoutBundles()
    endtry 
  else
    call s:WithoutBundles()
  endif

  filetype indent plugin on
  syntax on
endfunction

call s:InitNeoBundle()

" -------------------------------------------------
" Save Point script
" 2014/3/29
" save directory
let s:save_point=expand('~/.vim/save_point')

" sessionが保存するデータセッション
" globals option remove
set sessionoptions=blank,curdir,buffers,folds,help,slash,tabpages,winsize,localoptions

" 保存
function! s:save_window(file)
  let options = [
	\ 'set columns=' . &columns,
	\ 'set lines=' . &lines,
	\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
	\ ]
  call writefile(options, a:file)
endfunction

function! s:save_point(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir)
  endif

  " ファイルが存在していないか、書き込み可能の場合のみ
  if !filereadable(a:dir.'/vimwinpos.vim') || filewritable(a:dir.'/vimwinpos.vim')
    if has("gui")
      call s:save_window(a:dir.'/vimwinpos.vim')
    endif
  endif

  if !filereadable(a:dir.'/session.vim') || filewritable(a:dir.'/session.vim')
    execute "mksession! ".a:dir."/session.vim"
  endif

  if !filereadable(a:dir.'/viminfo.vim') || filewritable(a:dir.'/viminfo.vim')
    execute "wviminfo!  ".a:dir."/viminfo.vim"
  endif
endfunction

" 復元
function! s:load_point(dir)
  if filereadable(a:dir."/vimwinpos.vim") && has("gui")
    execute "source ".a:dir."/vimwinpos.vim"
  endif

  if filereadable(a:dir."/session.vim")
    execute "source ".a:dir."/session.vim"
  endif

  if filereadable(a:dir."/viminfo.vim")
    execute "rviminfo ".a:dir."/viminfo.vim"
  endif
endfunction

" 呼び出しを行うコマンド
command! SavePoint :call s:save_point(s:save_point)
command! LoadPoint :call s:load_point(s:save_point)

" 自動的に保存、復元するタイミングを設定
augroup SavePoint
  autocmd!
  autocmd VimLeavePre * SavePoint

  " 自動で保存、復元を行う場合
  "   autocmd CursorHold * SavePoint
  "   autocmd VimEnter * LoadPoint
augroup END

" -------------------------------------------------
"  blanket, quote auto completion
"  2014/3/29
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>


" -------------------------------------------------
" Plugins
" Color schemes
NeoBundle 'tomasr/molokai'

" Scala syntax hi-light
NeoBundle 'derekwyatt/vim-scala'

" HTML5
NeoBundle 'othree/html5.vim'

" Play2
NeoBundle 'gre/play2vim'

" Unite
NeoBundle 'Shougo/unite.vim'

