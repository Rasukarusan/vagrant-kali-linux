if &compatible
  set nocompatible
endif

set runtimepath+=/root/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('/root/.vim/dein')
  call dein#begin('/root/.vim/dein')

    call dein#add('/root/.vim/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('Shougo/vimproc.vim', {'build': 'make'})
    call dein#add('Shougo/unite.vim')
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/neocomplcache')
    call dein#add('scrooloose/nerdtree')
    call dein#add('jistr/vim-nerdtree-tabs')
    call dein#add('vim-scripts/PDV--phpdocumentor-for-vim')
    call dein#add('airblade/vim-gitgutter') " git管理下の場合行番号の横に差分記号を表示
    call dein#add('tomtom/tcomment_vim') " ctrl+-でコメントアウト
    call dein#add('tpope/vim-fugitive') " :Gstatusなどでvimにいながらgitコマンドが打てる
    call dein#add('vim-airline/vim-airline') " ステータスラインを表示
    call dein#add('rking/ag.vim')
    call dein#add('Shougo/vimproc')  " unite.vimで必要
    call dein#add('thinca/vim-quickrun') " shファイル等をその場で実行
    call dein#add('vim-jp/vimdoc-ja') " helpを:hで日本語で表示
    call dein#add('junegunn/fzf.vim') "fzfでファイル検索
    call dein#add('mattn/emmet-vim') " Emmnet
    call dein#add('Shougo/denite.nvim')
    call dein#add('ozelentok/denite-gtags')
    call dein#add('pocari/vim-denite-command-history') " コマンドの履歴を表示
    call dein#add('kana/vim-submode') " 画面分割時の画面大きさ変更キーなど連続で打つコマンドを楽にする
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" シンタックスハイライト
syntax on
set t_Co=256
colorscheme jellybeans
" 自動でインデントを挿入
set autoindent
" タブをスペースに変換
set expandtab
set tabstop=4
set shiftwidth=4
" 履歴件数
set history=1000
" jsonやmarkdownでダブルクォート、*が消えるのを回避
set conceallevel=0
" 検索語句のハイライト
set hlsearch
" カーソル行をハイライト。これをONにするとvimが重くなるのでコメントアウトした。
" set cursorline
set number
" 括弧の後に自動でインデントを挿入
set cindent
" 検索時に大文字小文字無視
set ignorecase
" 検索語句を全て英小文字で入力した場合のみ区別を無視
set smartcase
" クリップボード共有(vim --version | grep clipboard で+clipboardとなっていないと使えない。-clipbordになってると無理)
set clipboard=unnamed
" タブを >--- 半スペを . で表示する
set listchars=tab:»-,trail:･
" 保存時に行末の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge
" vimでバックスペースを有効に
set backspace=indent,eol,start
" マウスを有効に。クリックでカーソル移動もOK。
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif
" 指定のデータをレジスタに登録する
function! s:Clip(data)
    " clipPathをした時に余分なPATHを削除
    let pattern=""
    " @*でクリップボードにコピーされる。
    let @*=substitute(a:data,pattern,"","g")
    echo "clipped: " . @*
endfunction
" 現在開いているファイルのパスをレジスタへ
command! -nargs=0 ClipPath call s:Clip(expand('%:p'))
" 現在開いているファイルのファイル名をレジスタへ
command! -nargs=0 ClipFile call s:Clip(expand('%:t'))

" ===============キーマップ関連===================== "
" 入力モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
nnoremap <C-e> <Esc>$a
inoremap <C-e> <Esc>$a
nnoremap ss zz
nnoremap sa ^
nnoremap se $
vnoremap sa ^
vnoremap se $
nnoremap sl <C-w>l
nnoremap sh <C-w>h
"表示行単位で移動(snippet展開対策済み)
nnoremap j gj
onoremap j gj
xnoremap j gj
nnoremap k gk
onoremap k gk
xnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
" jjでエスケープ
inoremap <silent> jj <ESC>
" 日本語入力で”っj”と入力してもEnterキーで確定させればインサートモードを抜ける
inoremap <silent> っj <ESC>
" 入力モード中:wqと打つとノーマルモードに戻って:wqになる
inoremap :wq <ESC>:wq
inoremap :w <ESC>:w
inoremap :q <ESC>:q
" 閉じかっこをENTERと同時に挿入
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
" 削除した際ヤンクしないように
nnoremap x "_x
nnoremap _ci "_ci
nnoremap _D "_D
nnoremap _dd "_dd
vnoremap _d "_d
" タブ移動のショートカット
nnoremap <C-l> <ESC>gt
nnoremap <C-h> <ESC>g<S-t>
" 画面分割時の移動のショートカット
nnoremap <C-k> <ESC><C-w>k
nnoremap <C-j> <ESC><C-w>j
" pasteモード(,iでもペーストモードへ)
nnoremap ,i :<C-u>set paste<Return>i
autocmd InsertLeave * set nopaste
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" Yで末尾までコピー
nnoremap <S-y> <C-v>$y
" syで単語コピー
nnoremap sy byw
" swpファイルを作成しない
set noswapfile
" ビープ音をOFFにする
set belloff=all
