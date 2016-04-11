
# ---- Command prompt
# Expand functions in the prompt
setopt prompt_subst

# Load colors
autoload -U colors && colors

# Change prompt
export PS1="[%{$fg[green]%}${SSH_CONNECTION+"%n@%m:"}%~%{$reset_color%}] "

# Global PATH
export PATH=$PATH:~/bin

# Node.js
export PATH="./node_modules/.bin:$PATH"

# ---- Aliases
# GIT
alias gs='git status'
alias gl='git pull'
alias ga='git add . -A && gs'
alias gco='git checkout'

gc() {
	git commit -m "'"$@"'"
}
