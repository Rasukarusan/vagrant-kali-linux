bindkey -e # ctrl-aやctrl-eでカーソル移動
autoload -U compinit
compinit
# テーマ読み込み
source /vagrant/dotfiles/zsh-my-theme.sh
# Tabで選択できるように
zstyle ':completion:*:default' menu select=2
# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
setopt auto_param_slash       # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs              # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt auto_menu              # 補完キー連打で順に補完候補を自動で補完
setopt interactive_comments   # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst      # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word       # 語の途中でもカーソル位置で補完
setopt print_eight_bit        # 日本語ファイル名等8ビットを通す
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt share_history          # 他のターミナルとヒストリーを共有
setopt histignorealldups      # ヒストリーに重複を表示しない
setopt hist_save_no_dups      # 重複するコマンドが保存されるとき、古い方を削除する。
setopt extended_history       # $HISTFILEに時間も記録
setopt print_eight_bit        # 日本語ファイル名を表示可能にする
setopt hist_ignore_all_dups   # 同じコマンドをヒストリに残さない
setopt auto_cd                # ディレクトリ名だけでcdする
setopt no_beep                # ビープ音を消す
# コマンドを途中まで入力後、historyから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

alias ls='ls --color=auto'
alias l='ls --color=auto -ltr'
alias la='ls -la'
alias laa='ls -ld .*'
alias ll='ls -l'
alias grep='grep --color=auto'
alias his='history -E -i 1 | fzf'
alias grepr='grep -r'
alias ..='cd ..'
alias ...='cd ../../'
alias zshrc='vim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias vimrc='vim ~/.vimrc'

#centosにsshするとviで下記のエラーが出ることがあるので対策
# E437: terminal capability "cm" required
alias ssh='TERM=xterm ssh'

fpath=($HOME/.zsh/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init
export MANPATH="/usr/local/man:$MANPATH"
export LANG=ja_JP.UTF-8
# fzfのリストを上から並べ、全画面ではなくvimのquickfixライクにする
export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --select-1 --exit-0 --multi'
# 最終更新日が一番新しいもののファイル名を取得
alias fin='echo `ls -t | head -n 1`'
function late() {
    less $(echo `ls -t | head -n 1`)
}
# fzf版cdd
alias cdd='fzf-cdr'
function fzf-cdr() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}
# cdrの設定
autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*'      recent-dirs-max 500
  zstyle ':chpwd:*'      recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
# fgをfzfで
alias fgg='_fgg'
function _fgg() {
    wc=$(jobs | wc -l | tr -d ' ')
    if [ $wc -ne 0 ]; then
        job=$(jobs | awk -F "suspended" "{print $1 $2}"|sed -e "s/\-//g" -e "s/\+//g" -e "s/\[//g" -e "s/\]//g" | grep -v pwd | fzf | awk "{print $1}")
        wc_grep=$(echo $job | grep -v grep | grep 'suspended')
        if [ "$wc_grep" != "" ]; then
            fg %$job
        fi
    fi
}
# fzfを使ってプロセスKILL
alias pspk='_pspk'
function _pspk(){
    process=(`ps aux | awk '{print $2" "$9" "$11}' | fzf | awk '{print $1}'`)
    echo $process
    for item in ${process[@]}
    do
        kill $process
    done
}
# git logをpreviewで差分を表示する
alias -g tigg='_gitLogPreviewOpen'
function _gitLogPreviewOpen() {
    hashCommit=`git log --oneline | fzf --height 100% --prompt "SELECT COMMIT>" --preview "echo {} | cut -d' ' -f1 | xargs git show --color=always"`
    if [ -n "$hashCommit" ]; then
        git show `echo ${hashCommit} | awk '{print $1}'`
    fi
}
alias monitor='airodump-ng wlan0'

# USB-WifiをManageModeに切り替える
alias modeToManage='_changeMode managed'
# USB-WifiをMonitorModeに切り替える
alias modeToMonitor='_changeMode monitor'
function _changeMode() {
    ifconfig wlan0 down
    iwconfig wlan0 mode $1
    ifconfig wlan0 up
}

alias modeToMonitorByAirmon='_changeModeToMonitorByAirmon'
function _changeModeToMonitorByAirmon() {
    airmon-ng check kill
    airmon-ng start wlan0
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ================================================== #
# #
# # ============================== #
# #         alias-Command          #
# # ============================== #

alias gd='git diff -b'
alias gdc='git diff -b --cached'
alias co='git checkout $(git branch -a | tr -d " " |fzf --height=100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")'
alias co-='git checkout -'
alias gst='git status'
alias gca='git checkout $(git diff --name-only)'
# 最終更新日が一番新しいもののファイル名を取得
alias fin='echo `ls -t | head -n 1`'
# less `fin`と打つのが面倒だったため関数化。finはコマンドとして残しておきたいので残す
alias late='less $(echo `ls -t | head -n 1`)'

