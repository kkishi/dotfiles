# Configs for AWS
if [[ -d ~/.aws ]]; then
  # EC2 default.
  if [[ -f /etc/bashrc ]]; then
    source /etc/bashrc;
  fi

  export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk.x86_64"
  export PATH="/home/ec2-user/projects/bazel-0.5.3/output:$PATH"
  export PATH="/usr/local/go/bin:$PATH"
  export PATH="/home/ec2-user/go/bin:$PATH"
  export PATH="/home/ec2-user/projects/protoc-3.4.0-linux-x86_64/bin:$PATH"

  # NVM
  if [[ -f ~/.nvm/nvm.sh ]]; then
    source ~/.nvm/nvm.sh;
  fi
fi

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
