# ---------------------------------------------------------------------------
# Early exit for non-interactive shells
# ---------------------------------------------------------------------------
[[ $- != *i* ]] && return

# ---------------------------------------------------------------------------
# XDG base dirs (set early; other configs depend on them)
# ---------------------------------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ---------------------------------------------------------------------------
# PATH — personal bin directories prepended, deduplication enabled
# ---------------------------------------------------------------------------
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$path[@]"
)
export PATH

# ---------------------------------------------------------------------------
# Oh My Zsh
# ---------------------------------------------------------------------------
export ZSH="${XDG_DATA_HOME}/oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z                        # fast directory jumping
  python
  pip
  virtualenv
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY       # record timestamps
mkdir -p "$(dirname "$HISTFILE")"

# ---------------------------------------------------------------------------
# Editor / pager
# ---------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-RFX"


# Aliases go here


# Widgets go here
