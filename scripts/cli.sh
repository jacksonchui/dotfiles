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

setup_fzf_completion() {
  /opt/homebrew/opt/fzf/install --no-fish --completion
}
