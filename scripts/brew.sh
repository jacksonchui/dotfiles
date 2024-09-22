#! /usr/bin/env sh

. $HOME/dotfiles/scripts/utils.sh

install_homebrew() {
    if ! brew -v &>/dev/null
    then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        warn "Homebrew already installed"
    fi

    (
        cd "$HOME/dotfiles/config"
        if [ -f "Brewfile" ]; then
            brew tap homebrew/bundle && \
            brew bundle
            info "COMPLETE: Installed brew dependencies"
        else
            err "Couldn't find $brewfile. Are you sure it is in $bundle_loc?"
        fi
    )
}

install_homebrew
