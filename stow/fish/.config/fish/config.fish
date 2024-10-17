# NOTE: Always source these since our default shell is fish

# env var for programs
set -gx GOBIN                   $HOME/go/bin

# PATH
set -gx PATH $GOBIN $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH /usr/local/sbin $PATH

if status is-interactive

# -- ShellCheck --

# ENV Vars
set -gx VISUAL                  nvim
set -gx EDITOR                  $VISUAL
set -gx FISH_CONFIG_PATH        $HOME/.config/fish
set -gx RIPGREP_CONFIG_PATH     $HOME/.config/ripgrep/rg
set -gx DOTFILES_CONFIG_PATH    $HOME/dotfiles/config

# Enable Homebrew
set -gx HOMEBREW_NO_INSTALL_CLEANUP TRUE
eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH
set -gx PATH /usr/local/opt/ruby/bin:$HOME/.gem/ruby/2.7.0/bin $PATH
set -gx PATH $PATH $HOME/dotfiles/scripts

# ALIASES (hard sets with no expansion)
alias ls="lsd"
alias cd="z"

# ABBREVIATIONS
abbr grep 'grep --color=auto'
abbr fgrep 'fgrep --color=auto'
abbr egrep 'egrep --color=auto'
abbr ll 'ls -alFh'
abbr la 'ls -A'
abbr reload-profile "source ~/.zshrc"
abbr ftgz "tar --use-compress-program=pigz -zcvf"
abbr reload-tmux "eval \$(tmux showenv -s | grep -E '^(SSH|DISPLAY)')"

## Pretty git print in fish
set HASH "%C(always,yellow)%h%C(always,reset)"
set RELATIVE_TIME "%C(always,green)%ar%C(always,reset)"
set AUTHOR "%C(always,bold blue)%an%C(always,reset)"
set REFS "%C(always,red)%d%C(always,reset)"
set SUBJECT "%s"

set FORMAT "$HASH $RELATIVE_TIME{$AUTHOR{$REFS $SUBJECT"

function pretty_git_log
    git log --graph --pretty="tformat:$FORMAT" $argv |
    column -t -s '{' |
    less -XRS --quit-if-one-screen
end

## For git
abbr gst "git status"
abbr gc "git commit"
abbr co "git checkout"
abbr gaa "git add -A"
abbr gd "git diff"
abbr gdc "git diff --cached"
abbr gl pretty_git_log


# Check and install fisher
if type -q fisher
    fisher --version
else
    echo "Fisher is not installed. Installing..."
    # this is maintained under ~/.config/fish/fish_plugins
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
    fisher install PatrickF1/fzf.fish
    fisher install edc/bass
end

# Enable starship
if type -q starship
    source (starship init fish | psub)
else
    echo "starship is not installed."
end

if type -q zoxide
    source (zoxide init fish | psub)
end

# Enable fzf
if type -q fzf
    set -gx FZF_DEFAULT_OPTS "--height 50% --reverse --inline-info -m --border"
    set -gx FZF_DEFAULT_COMMAND "rg --files"
else
    echo "fzf is not installed."
end

# Initialize pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin" $PATH
set -gx PYENV_VERSION '3.12'
source (pyenv init - | psub)
source (pyenv virtualenv-init - | psub)

# Configure tmux multiplexer
set SESSION_TAG "tmux1"
function setup_env
    # Check if the session already exists
    if tmux has-session -t $SESSION_TAG
        # If the session exists, attach to it
        tmux attach-session -t $SESSION_TAG
    else
        # If the session doesn't exist, create and attach to it
        tmux new-session -s $SESSION_TAG
    end
end

# Work-specific extensions
if test -f $FISH_CONFIG_PATH/work.fish
    source $FISH_CONFIG_PATH/work.fish
end

# TIPS

# psub: process command subsitution provides a temp file, when needed
# cat (ls | psub) literally moves the output into a file, of which you  can cat
# so for stuff that generates commands, to source ... this is useful... it's like
# storing in a temp variable.

# `set -gx` sets an env var as global and passes it into subshells

end # match not interactive else
