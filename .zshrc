#^a, -eで移動できるように
bindkey -e

#cdなしでの移動
setopt auto_cd
setopt auto_pushd

re-prompt() {
    zle .reset-prompt
    zle .accept-line
}
zle -N accept-line re-prompt
export EDITOR=vim

#lsの色付け
export LSCOLORS=dxfxcxdxbxegedabagacad
# LS_COLORSを設定しておく
export LS_COLORS='di=33:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

#補完
autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=2
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#===alias===
alias tm='tmux'
alias tma='tmux a'
alias pu='pushd'
alias pp='popd'

case "${OSTYPE}" in
darwin*)
    # Mac
    alias ls="ls -GF"
    ;;
linux*)
    # Linux
    alias ls='ls -F --color'
    ;;
esac

alias la='ls -a'
#cdしたときに自動的にls -a($HOMEに来たときを除く)
cdls ()
{
    \cd "$@"
    if [ $PWD != $HOME ]; then
        ls -a
    fi
}
alias cd='cdls'

setopt BASH_REMATCH
cdp ()
{
    if [ $# = 0 ]; then
        if [[ $PWD =~ project\/([a-zA-Z0-9_\-]*)\/.*$ ]]; then
            cd ~/project/$BASH_REMATCH[2]
        else
            cd ~/project
        fi
    else
        cd ~/project/$1
    fi
}
alias cdp='cdp'
alias ...='cd ../..'
alias ....='cd ../../..'
#======

#===peco===
#pecoでコマンド履歴検索
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

#pecoでディレクトリ履歴から検索して移動
function peco-z-search
{
    which peco z > /dev/null
    if [ $? -ne 0 ]; then
        echo "Please install peco and z"
        return 1
    fi
    local res=$(z | sort -rn | cut -c 12- | peco)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N peco-z-search
bindkey '^f' peco-z-search
#======

#===git===
# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
autoload -Uz colors
colors

setopt prompt_subst
setopt transient_rprompt
precmd () { vcs_info }

# 表示フォーマットの指定
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:git:*' formats '%F{green}%c%u[%b]%f'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]'

PROMPT="%{${fg[white]}%} (%*) %{${fg[magenta]}%} %M %{${fg[cyan]}%} %~ %{${reset_color}%}\$vcs_info_msg_0_
%{${fg[green]}%}♪ Ｌ( ＾ω ＾ )┘ Ｌ( ＾ω ＾ )┘♪ %{${reset_color}%} $ "

RPROMPT="%{$fg[white]%(?..$bg[red])%} \$history[\$((\$HISTCMD-1))] %{$reset_color%}"
#======

#===PATH関連===
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
export GOROOT=/usr/local/go
export GOPATH=$HOME/.anyenv/envs/goenv/gocode
export PATH=$PATH:$GOPATH/bin
if [ -x "`which direnv`" ]; then
        eval "$(direnv hook zsh)"
fi
#======

# z.shのインストール
source ~/.zsh.d/z.sh

#.zshrc.localの読み込み
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
