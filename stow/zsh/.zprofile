# Homebrew no cleanup
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE

# -- ShellCheck --
eval "$(/opt/homebrew/bin/brew shellenv)"

# -- PATH --
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$HOME/.gem/ruby/2.7.0/bin:$PATH"

# Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
   force_color_prompt=yes
# MACOS
elif [[ "$OSTYPE" == "darwin"* ]]; then
   conda_path="$HOME/.miniconda3"
   export CLICOLOR=1 #get ANSI colors
   export TERM=xterm-256color
fi

# -- GREP Color support --
if [ -x /usr/bin/dircolors ]; then
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
fi

# Tips for Self
## rsync -avz --exclude ".git" --exclude "node_modules" artemis1:~/website/AlphaGarden/alphagarden.org ~/alphagarden.org --delete
## youtube-dl -f bestaudio --extract-audio --audio-format aac --audio-quality 0 https://www.youtube.com/watch\?v\=QcHT89eXmRw
# ssh-keygen -f ~/name_this_rsa
# ssh-copy-id -i ~/.ssh/my_rsa user@host

