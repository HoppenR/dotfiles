### XDG STANDARD SETTINGS
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


### STANDARD PROGRAMS
export BROWSER="/usr/bin/firefox"
export EDITOR="/usr/bin/nvim"
export PAGER="/usr/bin/less"
export TERMINAL="/usr/bin/kitty"

### TOOL SETTINGS
# `__git_ps1`:
export GIT_PS1_SHOWCOLORHINTS="true"
export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWUNTRACKEDFILES="true"
export GIT_PS1_SHOWUPSTREAM="true"
# `highlight`:
export HIGHLIGHT_TABWIDTH="4"
export HIGHLIGHT_STYLE="$HOME/.cache/wal/highlight.theme"
export HIGHLIGHT_OPTIONS="--line-numbers"
# `less`:
export LESS="-FRX -x1,5"

### FILE LOCATIONS
export CARGO_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/cargo"
export GNUPGHOME="${XDG_STATE_HOME:-$HOME/.local/state}/gnupg"
export GOPATH="${XDG_CACHE_HOME:-$HOME/.cache}/go"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/config"
export LESSHISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/less/history"
export OPAMROOT="${XDG_DATA_HOME:-$HOME/.local/share}/opam"
export PARALLEL_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/parallel"
export PULSE_COOKIE="${XDG_DATA_HOME:-$HOME/.local/share}/pulse/cookie"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

### EXTRA PATH DIRECTORIES
PATH="$HOME/.local/bin:$PATH"
export PATH
