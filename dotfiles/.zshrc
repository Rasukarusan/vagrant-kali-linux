bindkey -e
autoload -U compinit
compinit
source /vagrant/dotfiles/zsh-my-theme.sh
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
setopt auto_param_slash
setopt mark_dirs
setopt auto_menu
setopt interactive_comments
setopt magic_equal_subst
setopt complete_in_word
setopt print_eight_bit
setopt extended_history
setopt hist_expire_dups_first
setopt share_history
setopt histignorealldups
setopt hist_save_no_dups
setopt extended_history
setopt print_eight_bit
setopt hist_ignore_all_dups
setopt auto_cd
setopt no_beep
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

fpath=($HOME/.zsh/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init

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

export MANPATH="/usr/local/man:$MANPATH"
export LANG=ja_JP.UTF-8
export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --select-1 --exit-0 --multi'

# ================================================== #
#
# ============================== #
#            Function            #
# ============================== #
function clean_cdr_cache_history() {
    local function getDeleteNumbers() {
        local delete_line_number=1
        local delete_line_numbers=()
        while read line; do
            ls $line >/dev/null 2>&1
            if [ $? -eq 1 ]; then
                delete_line_numbers=($delete_line_number "${delete_line_numbers[@]}" )
            fi
            delete_line_number=$(expr $delete_line_number + 1)
        done
        echo "${delete_line_numbers[@]}"
    }

    local history_cache=~/.cache/cdr/history
    local delete_line_numbers=($(cat $history_cache | tr -d "$" | tr -d "'" | getDeleteNumbers))
    for delete_line_number in "${delete_line_numbers[@]}"
    do
        printf "\e[31;1m$(sed -n ${delete_line_number}p $history_cache)\n"
        sed -i '' -e "${delete_line_number}d" $history_cache
    done
}

# ================================================== #
#
# ============================== #
#         Function-alias         #
# ============================== #
#
function _process_kill_by_fzf(){
    process=(`ps aux | awk '{print $2" "$9" "$11}' | fzf | awk '{print $1}'`)
    echo $process
    for item in ${process[@]}
    do
        kill $process
    done
}

function fzf-cdr() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}

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

function _changeMode() {
    ifconfig wlan0 down
    iwconfig wlan0 mode $1
    ifconfig wlan0 up
}
function _changeModeToMonitorByAirmon() {
    airmon-ng check kill
    airmon-ng start wlan0
}
function _gitLogPreviewOpen() {
    hashCommit=`git log --oneline | fzf --height 100% --prompt "SELECT COMMIT>" --preview "echo {} | cut -d' ' -f1 | xargs git show --color=always"`
    if [ -n "$hashCommit" ]; then
        git show `echo ${hashCommit} | awk '{print $1}'`
    fi
}


# ================================================== #
#
# ============================== #
#         alias-Command          #
# ============================== #
alias ls='ls --color=auto'
alias l='ls --color=auto -ltr'
alias la='ls -la'
alias laa='ls -ld .*'
alias ll='ls -l'
alias llh='ls -lh'
alias grep='grep --color=auto'
alias his='history -E -i 1 | fzf'
alias grepr='grep -r'
alias ..='cd ..'
alias ...='cd ../../'
alias zshrc='vim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias ssh='TERM=xterm ssh'
alias fin='echo `ls -t | head -n 1`'
alias cdd='fzf-cdr'
alias gd='git diff -b'
alias gdc='git diff -b --cached'
alias co='git checkout $(git branch -a | tr -d " " |fzf --height=100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")'
alias co-='git checkout -'
alias gst='git status'
alias gca='git checkout $(git diff --name-only)'
alias fin='echo `ls -t | head -n 1`'
alias late='less $(echo `ls -t | head -n 1`)'
alias monitor='airodump-ng wlan0mon'

# ================================================== #
#
# ============================== #
#         alias-Function         #
# ============================== #
alias pspk='_process_kill_by_fzf'
alias fgg='_fgg'
alias tigg='_gitLogPreviewOpen'
alias modeToManage='_changeMode managed'
alias modeToMonitor='_changeMode monitor'
alias modeToMonitorByAirmon='_changeModeToMonitorByAirmon'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
