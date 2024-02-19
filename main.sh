#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

. scripts/utils.sh
. scripts/cli.sh
. scripts/oh-my-zsh.sh
. setup_stow.sh
. scripts/brew.sh
. scripts/setup_mas.sh
. scripts/osx.sh

cleanup() {
	err "Last command failed"
	info "Finishing..."
}

wait_input() {
	read -rp "Press enter to continue: "
}

install_xcode() {
  if xcode-select -p >/dev/null; then
    warn "xCode Command Line Tools already installed"
  else
    info "Installing xCode Command Line Tools..."
    xcode-select --install
    sudo xcodebuild -license accept
  fi
}


main() {
  info "Installing ..."

  install_xcode

  info "################################################################################"
  info "Homebrew Packages"
  info "################################################################################"
  wait_input
  install_homebrew
  success "Finished installing Homebrew packages"

  info "################################################################################"
  info "Oh-my-zsh"
  info "################################################################################"
  wait_input
  install_oh_my_zsh
  success "Finished installing Oh-my-zsh"

  setup_fzf_completion
  success "Finished setting up fzf completition"

  info "################################################################################"
  info "MacOS Apps"
  info "################################################################################"
  wait_input
  install_macApps
  success "Finished install mac apps"

  info "################################################################################"
  info "Golang tools"
  info "################################################################################"
  wait_input
  install_go_tools
  success "Finished installing Golang tools"

  info "################################################################################"
  info "Configuration"
  info "################################################################################"
  wait_input

  setup_osx
  success "Finished configuring MacOS defaults. NOTE: restart is needed"

  stow_dotfiles
  success "Finished stowing dotfiles"
}

main

