source ~/Projects/Shell/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle robbyrussell/oh-my-zsh plugins/aws
antigen bundle robbyrussell/oh-my-zsh plugins/docker
antigen bundle robbyrussell/oh-my-zsh plugins/gitfast
antigen bundle robbyrussell/oh-my-zsh plugins/git-extras
antigen bundle robbyrussell/oh-my-zsh plugins/jsontools
antigen bundle robbyrussell/oh-my-zsh plugins/lein
antigen bundle robbyrussell/oh-my-zsh plugins/npm

antigen theme wezm

antigen apply

export GITHUB_USER="integralist"
export DEV_CERT_PATH="$HOME/.pki/bbc"
export DEV_CERT_PEM="$HOME/.pki/bbc/Certificate.pem"
export DEV_CERT_P12="$HOME/.pki/bbc/Certificate.p12"
export CLOUD_CERT_PEM="$HOME/.pki/bbc/cloud-ca.pem"
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
export DOCKER_TLS_VERIFY=1
export BBC_COSMOS_TOOLS_CERT=$DEV_CERT_PEM
export GOPATH=$HOME/Projects/golang
export PATH=$HOME/Projects/golang/bin:$PATH

function rubo() {
  docker run \
    --cpu-shares 1024 \
    --rm=true \
    --volume $(pwd):/app \
    bbcnews/rubocop-config --format simple --fail-level F | grep '^F:\|=='
}

function copy_sshkey() {
  pbcopy < ~/.ssh/$1_rsa.pub
}

alias dotfiles="ls -a | grep '^\.' | grep --invert-match '\.DS_Store\|\.$'"
alias getcommit="git log -1 | cut -d ' ' -f 2 | head -n 1 | pbcopy"
alias vp="vim +PluginInstall! +qall"
alias sshkey="ssh-keygen -t rsa -b 4096 -C 'mark.mcdx@gmail.com'"
alias irc="irssi"
alias r="source ~/.zshrc"

eval "$(rbenv init -)"

eval export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/M/.docker/machine/machines/dev"
export DOCKER_MACHINE_NAME="dev"

eval "$(docker-machine env dev)"

# Golang gb dependency gets blatted by my shell's git alias for 'git branch'
unalias gb
