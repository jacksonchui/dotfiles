#!/usr/bin/env bash

setup_osx() {

    # Hide icons on desktop
    defaults write com.apple.finder CreateDesktop -bool false

    # Avoid creating .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Do not show warning when changing the file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"

    # Set weekly software update checks
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7

    # Set Dock autohide
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock showhidden -bool true
    defaults write com.apple.dock autohide-time-modifier -float 0.1
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock largesize -float 128
    defaults write com.apple.dock "minimize-to-application" -bool true
    defaults write com.apple.dock tilesize -float 32

    # Disable airplay (seems as of Sonoma, must manually toggle)
    defaults write com.apple.controlcenter.plist AirplayRecieverEnabled -bool false

    # Disable startup sound
    sudo nvram SystemAudioVolume=%01

    killall Dock 
}
