#!/usr/bin/env bash

masApps=(
    "409203825"     #Numbers
    "904280696"     #Things
    "1616822987"    #Affinity Photo 2
)

install_macApps() {
    echo "Installing App Store apps..."
    for app in $masApps; do
        mas install $app
    done
}

