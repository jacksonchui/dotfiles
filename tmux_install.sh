#!/usr/bin/env bash

if test ! $(which tmux); then
  echo "FAIL: Couldn't find tmux :( . Will not link the config";
  exit 1;
fi

TPM_DEST="$HOME/.tmux/plugins/tpm"
if [ ! -d $TPM_DEST ]; then
  echo "tpm for tmux doesn't exist ... installing"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
