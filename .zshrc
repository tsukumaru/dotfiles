bindkey -e

setopt auto_cd
setopt auto_pushd

alias tm='tmux'
alias tma='tmux a'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pu='pushd'
alias pp='popd'
alias la='ls -a'
cdls ()
{
  \cd "$@" && ls -a
}
alias cd='cdls'

re-prompt() {
zle .reset-prompt
zle .accept-line
			}
zle -N accept-line re-prompt
export EDITOR=vim

export LSCOLORS=dxfxcxdxbxegedabagacad
alias ls="ls -G"


autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=2

# LS_COLORSを設定しておく
export LS_COLORS='di=33:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
autoload -Uz colors
colors

setopt promptsubst

# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }


PROMPT="%{${fg[white]}%} (%*) %{${fg[magenta]}%} %m %{${fg[cyan]}%} %~ %1(v|%F{green}%1v%f|) %{${reset_color}%}
%{${fg[green]}%}♪ Ｌ( ＾ω ＾ )┘ Ｌ( ＾ω ＾ )┘♪ %{${reset_color}%} $ "

#RPROMPT="%{$fg[white]%(?..$bg[red])%} $history[$((HISTCMD-1))] %{$reset_color%}"
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

