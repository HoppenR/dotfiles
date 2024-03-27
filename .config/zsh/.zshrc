#
# ~/.config/zsh/.zshrc
#

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
    return
fi

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Options
setopt    MENU_COMPLETE
setopt    PROMPT_SUBST
setopt    SHARE_HISTORY
setopt no_CASE_GLOB
stty -ixoff
stty -ixon
tabs -4

# Prompt and colors
autoload -Uz colors
colors
PS1='[%n@%m %F{2}%c%f$(__git_ps1 " (%s)")]%F{2}%(?.$.?)%f '
RPS1='%(?..%F{1}%?%f)'
if command -v dircolors > /dev/null; then
    eval "$(dircolors)"
fi
#highlight vi visual mode
zle_highlight=( region:bg=5,fg=0 )
#set ls colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Mappings
zmodload zsh/complist
bindkey -v
bindkey -M command    '^[' send-break
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^[' send-break
bindkey -M menuselect '^n' vi-down-line-or-history
bindkey -M menuselect '^p' vi-up-line-or-history
bindkey -M menuselect '^y' accept-line
bindkey -M menuselect 'h'  vi-backward-char
bindkey -M menuselect 'j'  vi-down-line-or-history
bindkey -M menuselect 'k'  vi-up-line-or-history
bindkey -M menuselect 'l'  vi-forward-char
bindkey -M vicmd      '.'  vi-yank-arg
bindkey -M vicmd      'z='  spell-word
bindkey -M viins      '^?' backward-delete-char
bindkey -M viins      '^B' beginning-of-line
bindkey -M viins      '^E' end-of-line
bindkey -M viins      '^R' history-incremental-search-backward
bindkey -M viins      '^S' history-incremental-search-forward
bindkey -M viins      '§'  autosuggest-accept
bindkey -M visual     '¤'  edit-command-line

# Environment variables
DISABLE_AUTO_TITLE='true'
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
KEYTIMEOUT=1
SAVEHIST=10000
ZCALC_HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/zcalc_history"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=102'

# Aliases
alias :q='exit'
# Tools
alias cp='cp -i'       # Ask for confirmation before overwrite
alias mv='mv -i'       # Ask for confirmation before overwrite
alias rm='rm -i'       # Ask for confirmation before deletion
alias units='units --history ${XDG_STATE_HOME:-$HOME/.local/state}/units/history'
alias vim='nvim'
alias vimdiff='nvim -d'
alias z='zcalc'
# Color aliases
alias grep='grep --color=auto'
alias ls='ls --color=auto'
# Plugins
alias ssh='kitty +kitten ssh'
# Remove the default alias for run-help (man)
unalias run-help

# Functions
vi-yank-arg() {
  NUMERIC=1 zle .vi-add-next
  zle .insert-last-word
}

# Widgets
zle -N vi-yank-arg
zle -N edit-command-line
zle -N zcalc

# Plugins
autoload -Uz edit-command-line
autoload -Uz run-help
autoload -Uz zcalc
if [[ -r /usr/share/git/git-prompt.sh ]]; then
    source /usr/share/git/git-prompt.sh
fi
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fi
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi
if [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi
if [[ -r /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi

# Styles for zsh-syntax-highlighting
export ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white
export ZSH_HIGHLIGHT_STYLES[command]=fg=red,bold
export ZSH_HIGHLIGHT_STYLES[alias]=fg=red,bold

# opam configuration
[[ ! -r /home/christoffer/.local/share/opam/opam-init/init.zsh ]] || source /home/christoffer/.local/share/opam/opam-init/init.zsh  > /dev/null 2> /dev/null
