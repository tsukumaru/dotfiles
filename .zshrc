export LANG=ja_JP.UTF-8

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

#pecoでブランチ選択
function peco-branch () {
    local branch=$(git branch | peco | tr -d ' ' | tr -d '*')
    if [ -n "$branch" ]; then
      if [ -n "$LBUFFER" ]; then
        local new_left="${LBUFFER%\ } $branch"
      else
        local new_left="$branch"
      fi
      BUFFER=${new_left}${RBUFFER}
      CURSOR=$#BUFFER
    fi
}
zle -N peco-branch
bindkey '^o' peco-branch
#======

#===git===

#親ブランチ情報を取得する
function get_parent_branch() {
  parent_branch=`git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -1 | awk -F'[]~^[]' '{print $2}'`
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd get_parent_branch

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

PROMPT="%{${fg[white]}%} (%*) %{${fg[magenta]}%} %M %{${fg[cyan]}%} %~ \$vcs_info_msg_0_ <- %{${fg[yellow]}%}(\$parent_branch)%{${reset_color}%}
%(?|%{${fg[green]}%}♪ Ｌ( ＾ω ＾ %)┘ Ｌ( ＾ω ＾ %)┘♪|%{${fg[red]}%}♪ Ｌ( ；ω ； %)┘ Ｌ( ；ω ； %)┘♪)%{${reset_color}%} $ "

RPROMPT="%{$fg[white]%(?..$bg[red])%} \$history[\$((\$HISTCMD-1))] %{$reset_color%}"
#======

#===PATH関連===
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
export GOROOT=`go env GOROOT`
export GOPATH=$HOME
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
if [ -x "`which direnv`" ]; then
        eval "$(direnv hook zsh)"
fi
#======

# z.shのインストール
source ~/.zsh.d/z/z.sh

#.zshrc.localの読み込み
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

function git-branch () {
    if [ $# = 0 -o $# = 1 ]; then
        echo "引数を'親ブランチ 子ブランチ'で指定してね！"
    else
        git checkout $1
        git branch $2
        git checkout $2
    fi
}
alias git-branch='git-branch'
