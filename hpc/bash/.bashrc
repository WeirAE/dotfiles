# Early exit for non-interactive shells
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	 . /etc/bashrc
fi

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
# Expand the history size
export HISTSIZE=500
export HISTFILESIZE=10000
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
# Flush to disk after every command so parallel sessions don't lose history
PROMPT_COMMAND='history -a'

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------
export EDITOR="vim"
export VISUAL="vim"

# ---------------------------------------------------------------------------
# Git agent
# ---------------------------------------------------------------------------
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_rsa
fi
