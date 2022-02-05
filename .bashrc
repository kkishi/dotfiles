# Configs for AWS
if [[ -d ~/.aws ]]; then
  # EC2 default.
  if [[ -f /etc/bashrc ]]; then
    source /etc/bashrc;
  fi

  export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk.x86_64"
  export PATH="$HOME/projects/bazel-0.5.3/output:$PATH"
  export PATH="$HOME/projects/protoc-3.4.0-linux-x86_64/bin:$PATH"

  # NVM
  if [[ -f ~/.nvm/nvm.sh ]]; then
    source ~/.nvm/nvm.sh;
  fi
fi

# Fo Go
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# From https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# https://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=

alias emacs="emacs -nw"

# For pip3
export PATH="$HOME/.local/bin:$PATH"

# For screen
export SCREENDIR="$HOME/.screen"

# For pcstd
export CPLUS_INCLUDE_PATH="$HOME/projects/pcstd:$CPLUS_INCLUDE_PATH"

# For ac-library
export CPLUS_INCLUDE_PATH="$HOME/projects/ac-library:$CPLUS_INCLUDE_PATH"

# direnv
eval "$(direnv hook bash)"

# Color the terminal (borrowed from the Ubuntu default .bashrc)
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
[[ -f ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Sync programming contest repositories.
syncpc() {
  for c in atcoder aoj yukicoder codeforces; do
    pushd ~/projects/$c
    git pull
    go install github.com/kkishi/$c/cmd/...
    cd pclib
    git pull
    popd
  done
}
