# ~/.bashrc: executed by bash(1) for non-login shells.
DOTFILES_CONFIG_PATH=${JC_DOTFILES:-"$HOME/dotfiles"}/config


[[ $SHELL == *zsh ]] && echo "Enabling Oh My Zsh" && . $HOME/.zshrc.omz

echo "Using my_rc..."

## PLATFORM DEPENDENT SETUP ##
# 1. Linux Build
UNIX_BASE=$(uname)
if [[ $UNIX_BASE == "Linux" ]]; then
    echo "Applying Linux-specific policies"
    # SELinux
    alias audit2allow="sroot && ./external/selinux/prebuilts/bin/audit2allow"
    export PATH="$JC_DOTFILES/packages/nvim-linux64/bin:$PATH"
    export PATH="$JC_DOTFILES/packages/ripgrep/usr/bin:$PATH"
    echo $PATH
elif [[ $UNIX_BASE == "Darwin" ]]; then 
    echo "Applying Darwin-specific config"
    # Pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    # eval "$(pyenv virtualenv-init -)"
fi

# Source the home configs
. $HOME/.config/me/.me.rc
. $HOME/.config/me/.aliases

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ $SHELL == *bash ]]; then
    # don't put duplicate lines or lines starting with space in the history.
    #See bash(1) for more options
    HISTCONTROL=ignoreboth
    shopt -s histappend
    HISTSIZE=10000
    HISTFILESIZE=20000
    shopt -s checkwinsize

    # dir/subdir Path expansion pattern search "**"
    shopt -s globstar
   
    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi

    ## MY PROMPT ##
    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac
    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
        else
        color_prompt=
        fi
    fi
    if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
    PS1='\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    # This is the fuzzy command -r
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

elif [[ $SHELL == *zsh ]]; then
    # Ignore duplicates and commands starting with space in history
    setopt histignoredups histignorespace
    # Append history to the history file
    setopt histappend
    # Set the maximum number of lines saved in history
    HISTSIZE=10000
    # Set the maximum size of the history file
    SAVEHIST=20000
    # Enable recursive directory/subdirectory globbing pattern
    setopt globstarshort

    # Check if the terminal supports color
    if [[ $TERM == *256color || $TERM == xterm-color ]]; then
        color_prompt=yes
    else
        color_prompt=
    fi

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/rg

