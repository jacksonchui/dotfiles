#!usr/bin/env bash

install_homebrew() {
    if ! brew -v &>/dev/null
    then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew already installed"
    fi

    (
        cd "$HOME/dotfiles/config"
        if [ -f "Brewfile" ]; then
            brew tap homebrew/bundle && \
            brew bundle
            echo "COMPLETE: Installed brew dependencies"
        else
            echo "Couldn't find $brewfile. Are you sure it is in $bundle_loc?"
        fi
    )
}
