#
# ~/.config/zsh/.zshrc
#

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
    return
fi

# Debug check .zshrc sourced before sway auto-start from tty1, see '.zlogin'
if [[ -z "${WAYLAND_DISPLAY}" && "${XDG_VTNR}" -eq 1 ]]; then
    echo "$(date) - .zshrc skipped (tty=${TTY}, vtnr=${XDG_VTNR} uptime=$(uptime --pretty))" >> ~/.zshrc-sourced.log
    return
fi

# Completion
autoload -Uz compinit
compinit

zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' menu select=1 interactive
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
# Tool-specific completion
zstyle ':completion:*:*:cd:*' ignore-parents false
zstyle ':completion:*:*:cd:*' special-dirs true
# Fix bug when descriptions end up below MAC-addresses
zstyle ':completion:*:*:bluetoothctl-connect:*' list-grouped false
zstyle -e ':completion:*:*:kill:*:processes' command '(( ${#words} == 2 )) && reply=("ps -u \"${USER}\" -o pid,user:11,comm -w -w")'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Matchers
typeset -ga _zshrc_matchers
_zshrc_matchers=(
    'm:{a-z-}={A-Z_}'             # Find exact matches first
    'm:{a-z-}={A-Z_} l:|=* r:|=*' # then try substring-matching
    'm:{a-z-}={A-Z_} r:|?=**'     # then try fuzzy finding
)
zstyle ':completion:*' matcher-list "${_zshrc_matchers[@]}"

# Named directories
hash -d projects="${HOME}/projects"
hash -d personal="${HOME}/projects/personal"
hash -d dotfiles="${HOME}/dotfiles"

# Options
setopt    AUTO_PUSHD
setopt no_CASE_GLOB
setopt    CHASE_LINKS
#setopt    COMPLETE_IN_WORD
setopt    EXTENDED_GLOB
setopt    HIST_EXPIRE_DUPS_FIRST
setopt    HIST_FIND_NO_DUPS
setopt    HIST_VERIFY
setopt    INTERACTIVE_COMMENTS
setopt    MENU_COMPLETE
setopt    PROMPT_SUBST
setopt    SHARE_HISTORY
stty werase undef
stty -ixoff
stty -ixon
tabs -4

# Prompt and colors
autoload -Uz colors
colors
PS1='[%n@%m %F{2}%4(c:…/:)%3c%f$(__git_ps1 " (%s)")]%F{2}%(?.$.?)%f '
RPS1='%(?..%F{1}%?%f)'
if (( ${+commands[dircolors]} )); then
    eval "$(dircolors)"
fi
#highlight vi visual mode
zle_highlight=('region:bg=5,fg=0')
#set ls colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Mappings
zmodload zsh/complist
bindkey -v
bindkey -M command    '^[' send-break
bindkey -M menuselect '^I' vi-forward-char
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^['   send-break
bindkey -M menuselect '^e'   send-break
bindkey -M menuselect '^h'   vi-backward-char
bindkey -M menuselect '^j'   vi-down-line-or-history
bindkey -M menuselect '^k'   vi-up-line-or-history
bindkey -M menuselect '^l'   vi-forward-char
bindkey -M menuselect '^n'   vi-down-line-or-history
bindkey -M menuselect '^p'   vi-up-line-or-history
bindkey -M menuselect '^y'   accept-line
bindkey -M vicmd      '.'    vi-yank-arg
bindkey -M vicmd      '^[[F' end-of-line
bindkey -M vicmd      '^[[H' beginning-of-line
bindkey -M vicmd      'z='   spell-word
bindkey -M viins      '^?'   backward-delete-char
bindkey -M viins      '^B'   beginning-of-line
bindkey -M viins      '^E'   end-of-line
#bindkey -M viins      '^R'   history-incremental-search-backward
bindkey -M viins      '^R'   fzf-history-widget
#bindkey -M viins      '^S'   history-incremental-search-forward
bindkey -M viins      '^S'   fzf-history-widget-exact
bindkey -M viins      '^W'   backward-kill-word
bindkey -M viins      '^[[A' history-beginning-search-backward
bindkey -M viins      '^[[B' history-beginning-search-forward
bindkey -M viins      '^[[F' end-of-line
bindkey -M viins      '^[[H' beginning-of-line
bindkey -M viins      '^a'   cd-show
bindkey -M viins      '^g'   cdstack-menu
#bindkey -M viins      '§'    autosuggest-accept
bindkey -M viins      '§'    closest-history-match-accept
bindkey -M visual     '¤'    edit-command-line

# Zsh Setting Variables
DISABLE_AUTO_TITLE='true'
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
KEYTIMEOUT=1
SAVEHIST=10000
ZCALC_HISTFILE="${XDG_STATE_HOME}/zsh/zcalc_history"
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=102'
WORDCHARS='*?[]~=&;!#$%^(){}<>'

# Aliases
alias :q='exit'
# Tools
alias cp='cp -i'       # Ask for confirmation before overwrite
alias mv='mv -i'       # Ask for confirmation before overwrite
alias rm='rm -i'       # Ask for confirmation before deletion
alias edit-var='vared -i edit-command-line'
alias ll='ls -l --almost-all'
alias units="units --history ${XDG_STATE_HOME}/units/history"
alias vim='nvim'
alias vimdiff='nvim -d'
alias z='zcalc'
# Color aliases
alias grep='grep --color=auto'
alias ls='ls --color=auto'
# Plugins
alias ssh='kitty +kitten ssh'
# Remove the default alias for run-help (man)
if [[ "${aliases[run-help]}" == 'man' ]]; then
    unalias run-help
fi

# Functions
function timer() {
    # After $1 minutes: notify-send $2
    sched "+$(( ${1:-10} * 60 ))" notify-send "${2:-Timer done!}"
}
function nv() {
    local selected
    local -a roots
    roots=(
        "${HOME}/projects"
        "${HOME}/projects/personal/"
        "${HOME}/dotfiles/.config/"
    )
    if (( ${+commands[fd]} )); then
        selected=$(fd --type d --max-depth 1 . "${roots[@]}" | fzf)
    else
        selected=$(find "${roots[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
    fi
    if [[ -n "${selected}" ]]; then
        cd "${selected}"
        nvim -- ${selected}
    fi
}
function gr() {
    local git_root
    git_root=$(git rev-parse --show-toplevel)
    if [[ -n "${git_root}" ]]; then
        cd "${git_root}"
    fi
}
function take() {
    if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
        takeurl "$1"
    elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
        takegit "$1"
    else
        takedir "$@"
    fi
}
function takegit() {
    git clone -- "$1"
    cd "$(basename "${1%%.git}")"
}
function takeurl() {
    local data thedir
    data="$(mktemp)"
    curl -L -- "$1" > "${data}"
    tar xf "${data}"
    thedir="$(tar tf "${data}" | head -n 1)"
    rm "${data}"
    cd "${thedir}"
}
function takedir() {
    if mkdir -p -- "$@"; then
        cd -- "${@:$#}"
    fi
}
function restart-failed-units() {
    local output="$(systemctl list-units --failed --quiet --no-pager --no-legend --plain)"
    if [[ -z "${output}" ]]; then
        echo 'fatal: no failed systemd units' >&2
        return 1
    fi
    local -a failed_units
    failed_units=("${(@f)output}")
    failed_units=("${(@)failed_units%% *}")
    zargs --no-run-if-empty --interactive -- "${failed_units[@]}" -- systemctl restart --
}
function work-hours() {
    local -a days
    days=('Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday')
    local -i total_minutes=0
    local start _end lunch
    for day in ${days}; do
        echo "\n${day}:"
        vared -p '   Start time (HH:MM): ' start
        vared -p '   End time (HH:MM): ' _end
        vared -p '   Lunch minutes: ' lunch
        local -i start_min=$((10#${start%:*} * 60 + 10#${start#*:}))
        local -i end_min=$((10#${_end%:*} * 60 + 10#${_end#*:}))
        local -i worked=$((end_min - start_min - lunch))
        hours=$((worked / 60))
        minutes=$((worked % 60))
        echo "  Worked: ${hours}h ${minutes}m"
        total_minutes+=worked
    done
    local -i total_hours=$((total_minutes / 60))
    local -i total_remainder=$((total_minutes % 60))
    echo "\nTotal for week: ${total_hours}h ${total_remainder}m"
}

# Zle keybind functions
function _assert_zle_context() {
    if (( ! ${+WIDGET} )); then
        print "Warning: '${funcstack[-1]}' expects to run in a ZLE context" >&2
        return 1
    fi
}
function _vi-yank-arg() {
    _assert_zle_context || return
    NUMERIC=1 zle .vi-add-next
    zle .insert-last-word
}
function _cdstack-menu() {
    _assert_zle_context || return
    if (( ${#dirstack[@]} == 0 )); then
        zle -M 'directory stack is empty'
        return 0
    fi

    zle push-line-or-edit
    BUFFER='cd +'
    CURSOR="${#BUFFER}"
    zle complete-word

    if (( ${#dirstack} == 1 )); then
        zle accept-line
    elif [[ "${BUFFER}" == 'cd +' ]]; then
        zle send-break
    fi
}
function _cd-show() {
    _assert_zle_context || return
    local -a parts
    parts=("${(z)BUFFER}")

    if [[ "${parts[1]}" != cd ]]; then
        zle -M 'cd-show: not a cd command'
        return 1
    elif (( ${#parts} < 2 )); then
        zle -M 'cd-show: expected argument'
        return 1
    elif (( ${#parts} > 2 )); then
        zle -M 'cd-show: too many arguments'
        return 1
    fi

    local target
    if target="$(realpath -e "${parts[2]}" 2>&-)"; then
        zle -M "→ ${target}"
    else
        zle -M "invalid path: '${parts[2]}'"
    fi
}
function _closest-history-match-accept() {
    _assert_zle_context || return
    zle history-beginning-search-backward
    zle end-of-line
}
function _fzf-history-widget-exact() {
    local FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS}${FZF_CTRL_R_OPTS:+ }"
    FZF_CTRL_R_OPTS+="--prompt '(exact)> ' --exact"
    zle fzf-history-widget
}

# Widgets
zle -N edit-command-line
# local
zle -N cd-show _cd-show
zle -N cdstack-menu _cdstack-menu
zle -N closest-history-match-accept _closest-history-match-accept
zle -N vi-yank-arg _vi-yank-arg
zle -N fzf-history-widget-exact _fzf-history-widget-exact

# Builtin plugins
autoload -Uz edit-command-line
autoload -Uz run-help
autoload -Uz zargs
autoload -Uz zcalc

# File plugins
typeset -ga _zshrc_file_plugin_paths
_zshrc_file_plugin_paths=(
   '/usr/share/git/git-prompt.sh'
   '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh'
   '/usr/share/fzf/key-bindings.zsh'
   # '/usr/share/fzf/completion.zsh'
   # "${OPAMROOT:-${XDG_DATA_HOME}/opam}/opam-init/init.zsh"
   # '/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh'
)
for fpp in "${_zshrc_file_plugin_paths[@]}"; do
    if [[ -r "${fpp}" ]]; then
        source "${fpp}"
    fi
done

if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
    # Styles for zsh-syntax-highlighting
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=white'
    ZSH_HIGHLIGHT_STYLES[command]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#a89888'
fi
