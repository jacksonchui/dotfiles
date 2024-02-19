#!/usr/bin/env bash

if test ! $(which tmux); then
  echo "FAIL: Couldn't find tmux :( . Will not link the config";
  exit 1;
fi

. scripts/utils.sh

install_tmux_tpm() {
  local TMUX_PLUGINS="$HOME/.tmux/plugins"

  if [ ! -d $TMUX_PLUGINS/tpm ]; then
    info "Installing tmux tpm"
    mkdir -p $TMUX_PLUGINS
    git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGINS/tpm
  else
    warn "TPM for tmux already installed"
  fi
}

