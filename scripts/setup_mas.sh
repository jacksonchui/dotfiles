#!/usr/bin/env bash

. $HOME/dotfiles/scripts/utils.sh

masApps=(
    "409203825"     #Numbers
    "904280696"     #Things
    "1616822987"    #Affinity Photo 2
    "497799835"     #Xcode
)

NEED_XCODE_AGREEMENT=1

need_xcode_config_and_agree() {
    if ! mas list | grep Xcode > /dev/null ; then
        warn "Need to configure Xcode and agree to license"
        NEED_XCODE_AGREEMENT=0
    fi
}

install_macApps() {
    need_xcode_config_and_agree

    info "Installing App Store apps..."
    for app in $masApps; do
        mas install $app
    done

    if [ $NEED_XCODE_AGREEMENT == 0 ] ; then
        sudo xcode-select --install
        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild --license
    fi
}

install_macApps
