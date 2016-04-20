
# ---- Command prompt
# Expand functions in the prompt
setopt prompt_subst

# Load colors
autoload -U colors && colors

# Set prompt
export PROMPT='%{$fg[green]%}%~%{$reset_color%} '
export RPROMPT='$(git_prompt_string)'

parse_git_branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

parse_git_state_color() {
  local GIT_STATE_COLOR=""

  GIT_PROMPT_AHEAD="%{$fg[green]%}"
  GIT_PROMPT_MODIFIED="%{$fg[red]%}"
  GIT_PROMPT_STAGED="%{$fg[yellow]%}"
  GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}"
  GIT_PROMPT_MERGING="%{$fg[magenta]%}"

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE_COLOR="$GIT_PROMPT_AHEAD"
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE_COLOR="$GIT_PROMPT_MODIFIED"
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE_COLOR="$GIT_PROMPT_UNTRACKED"
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE_COLOR="$GIT_PROMPT_MERGING"
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE_COLOR="$GIT_PROMPT_STAGED"
  fi

  echo "$GIT_STATE_COLOR"
}

git_prompt_string() {
  echo "$(parse_git_state_color)$(parse_git_branch)%{$reset_color%}"
}

# ---- PATH
# Global
export PATH=$PATH:~/bin

# Brew
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/sbin:$PATH"

# Node.js
export PATH="./node_modules/.bin:$PATH"

# PHP
export PATH="$(brew --prefix homebrew/php/php70)/bin:$PATH"

# ---- Aliases
# GIT
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias ga='git add . -A && gs'
alias gco='git checkout'

gc() {
	git commit -m "$*"
}

# Brew update
alias brew-update='brew update && brew upgrade --all && brew prune && brew cleanup && brew prune && brew doctor';
