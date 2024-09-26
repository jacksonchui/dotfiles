#!/usr/bin/env bash

. $HOME/dotfiles/scripts/utils.sh

stow_dotfiles() {
	files=( \
	  ".gitconfig"
	  ".ssh/config"
	  ".tmux.conf"
	  ".wezterm.lua"
	  ".zprofile"
	  ".zshrc"
	  ".zshrc.omz"
	)

	folders=( \
	  ".config/nvim"
	  ".config/skhd"
	  ".config/ripgrep"
	  ".config/yabai"
	  ".config/me"
	  ".config/starship"
      ".config/fish"
	)

	warn "Removing existing config files"
	for f in "${files[@]}"; do
	  rm -rf "$HOME/$f" || true
	done

	for d in "${folders[@]}"; do
	  rm -rf "$HOME/$d" || true
	  mkdir -p "$HOME/$d"
	done

	# name of the folder...
	dotfiles="git me nvim fish ripgrep skhd ssh starship tmux yabai wezterm zsh"


	info "Stowing: $dotfiles"
	stow -d stow --verbose 1 --target $HOME $dotfiles
}

stow_dotfiles
