#!/usr/bin/env bash

. scripts/utils.sh

install_go_tools() {
  declare -A tools=(
    [arduino]="github.com/arduino/arduino-language-server@latest"
    [delve]="github.com/go-delve/delve/cmd/dlv@latest"
    [shfmt]="mvdan.cc/sh/v3/cmd/shfmt@latest"
  )

  for tool in "${!tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      info "Installing go tool < $tool >"
      go install "${tools[$tool]}"
    else
      warn "$tool is already installed"
    fi
  done
}

init_rust() {
  # Check for updates
  rustup update

  # Uninstall and install stable toolchain if updates are available
  if rustup toolchain list | grep -q "(installed)" && ! rustup toolchain list | grep -q stable; then
      rustup toolchain uninstall stable
  fi

  rustup toolchain install stable

  # Install rust, configure environment
  rustup-init --quiet -y
  # Web assembly target
  rustup target add wasm32-wasi
  # Use compiler plugin manager to install copy of rust-src for rust-analyzer
  rustup component add rust-src
  source "$HOME/.cargo/env"
}

setup_fzf_completion() {
  /opt/homebrew/opt/fzf/install \
    --no-fish \
    --key-bindings \
    --completion \
    --no-update-rc
}
