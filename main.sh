#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

. scripts/utils.sh
. scripts/cli.sh
. setup_stow.sh
. scripts/brew.sh
. scripts/osx.sh
. scripts/setup_mas.sh
. scripts/tmux_tpm.sh

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
  warn "Setting up OSX"
  echo -e "\n"

  info "################################################################################"
  info "Xcode Commandline Tools"
  info "################################################################################"
  install_xcode

  info "################################################################################"
  info "Homebrew Packages"
  info "################################################################################"
  install_homebrew
  success "Finished installing Homebrew packages"

  setup_fzf_completion
  success "Finished setting up fzf completion"

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
  info "Tmux Plugins"
  info "################################################################################"
  wait_input
  install_tmux_tpm
  success "Finished installing tmux plugins"


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

