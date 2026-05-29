# XDG base dirs (needed before anything else that uses them)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# uv — fast Python package/project manager
if [[ -f "$HOME/.local/bin/uv" ]]; then
  eval "$("$HOME/.local/bin/uv" generate-shell-completion zsh 2>/dev/null)" || true
fi

# Local overrides
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"