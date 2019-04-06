#!/usr/bin/env bash

echo .bashrc loaded

# Prevent shellcheck from worrying about code sourced at runtime.
# https://github.com/koalaman/shellcheck/wiki/SC1090
# shellcheck source=/dev/null

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

# DISABLED...
# shellcheck source=/dev/null
# https://github.com/jarun/googler/blob/master/auto-completion/bash/googler-completion.bash
# source ~/googler-completion.bash

# tells Readline to perform filename completion in a case-insensitive fashion
bind "set completion-ignore-case on"

# filename matching during completion will treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# will get Readline to display all possible matches for an ambiguous pattern at the first <Tab> press instead of at the second
bind "set show-all-if-ambiguous on"

# no bell sound on error
bind "set bell-style none"

# DISABLED...
# enable emacs like bindings (<C-a> and <C-e> for start and end of line shortcuts)
# set -o emacs

# enable vim like bindings instead of emails (e.g. no longer use <C-a> or <C-e>)
set -o vi

# append to the history file, don't overwrite it
shopt -s histappend

# save multi-line commands as one command
shopt -s cmdhist

# no need to type cd (works for .. but not -, although alias -- -='cd -' fixes it)
shopt -s autocd 2>/dev/null

# autocorrect minor spelling errors
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

# check windows size if windows is resized
shopt -s checkwinsize 2>/dev/null

# use extra globing features. See man bash, search extglob.
shopt -s extglob 2>/dev/null

# include .files when globbing.
shopt -s dotglob 2>/dev/null

# case insensitive globbing
shopt -s nocaseglob 2>/dev/null

# can be useful to utilise the gnu style error message format
shopt -s gnu_errfmt 2>/dev/null

# ensure SIGHUP is sent to all jobs when an interactive login shell exits
shopt -s huponexit 2>/dev/null

# custom environment variables
export DROPBOX="$HOME/Dropbox"
export GITHUB_USER="integralist"

# application configuration
export GOOGLER_COLORS=bjdxxy # https://github.com/jarun/googler/
export LSCOLORS="dxfxcxdxbxegedabagacad" # http://geoff.greer.fm/lscolors/
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
export GOPATH=$HOME/code/go
export EDITOR="vim"
export HOMEBREW_NO_ANALYTICS=1
export SSH_PUBLIC_KEY="$HOME/.ssh/github_rsa.pub"
export FZF_DEFAULT_COMMAND="ag --ignore-dir node_modules --filename-pattern ''" # can use --ignore-dir multiple times
# export PROMPT_DIRTRIM=4 # truncate start of long path

# prevent tmux from triggering the path to be updated with duplicate items
if [[ -z $TMUX ]]; then
  export PATH=$GOPATH/bin:$PATH
fi

# git specific configurations
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true     # * for unstaged changes (+ staged but uncommitted changes)
export GIT_PS1_SHOWSTASHSTATE=true     # $ for stashed changes
export GIT_PS1_SHOWUNTRACKEDFILES=true # % for untracked files
export GIT_PS1_SHOWUPSTREAM="auto"     # > for local commits on HEAD not pushed to upstream
                                       # < for commits on upstream not merged with HEAD
                                       # = HEAD points to same commit as upstream

# history configuration
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth" # avoid duplicate entries
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history" # don't record some commands
export HISTTIMEFORMAT='%F %T ' # useful timestamp format
history -a # record each line as it gets issued
PROMPT_COMMAND="history -a" # don't lose commands when session accidentally terminates

# force colours
export force_color_prompt=yes

# use colour prompt
export color_prompt=yes

function prompt_right() {
  echo -e ""
}

function prompt_left() {
  num_jobs=$(jobs | wc -l)

  if [ "$num_jobs" -eq 0 ]; then
    num_jobs=""
  else
    num_jobs=' (\j)'
  fi

  echo -e "\\e[33m\\]\\u. \\[\\e[37m\\]\\w\\[\\e[00m\\]$num_jobs\\e[31m\\]$(__git_ps1)\\e[00m\\] \\e[0;37m(\\A)\\e[0m"

  # \e indicates escape sequence (sometimes you'll see \033)
  # the m indicates you've provided a colour sequence
  #
  # 30: Black
  # 31: Red
  # 32: Green
  # 33: Yellow
  # 34: Blue
  # 35: Purple
  # 36: Cyan
  # 37: White
  #
  # a semicolon allows additional attributes:
  #
  # 0: Normal text
  # 1: Bold or light, depending on terminal
  # 4: Underline text
  #
  # there are also background colours (put before additional attributes with ; separator):
  #
  # 40: Black background
  # 41: Red background
  # 42: Green background
  # 43: Yellow background
  # 44: Blue background
  # 45: Purple background
  # 46: Cyan background
  # 47: White background
}

function prompt() {
  compensate=11
  unset PS1

  PS1=$(printf "%*s\\r%s\\n\$ " "$(($(tput cols)+compensate))" "$(prompt_right)" "$(prompt_left)")
}

function toggle_hidden() {
  setting=$(defaults read com.apple.finder AppleShowAllFiles)

  if [ "$setting" == "NO" ]; then
    echo "Enabling hidden files"
    defaults write com.apple.finder AppleShowAllFiles YES
  else
    echo "Disabling hidden files"
    defaults write com.apple.finder AppleShowAllFiles NO
  fi

  killall Finder
}

function gc {
  if [ -z "$1" ]; then
    printf "\\n\\tUse: gc <checkout-branch-name>\\n"
  else
    git checkout "$1"
  fi
}

function gcb {
  if [ -z "$1" ]; then
    printf "\\n\\tUse: gcb <create-branch-name>\\n"
  else
    transformed=$(echo "$1" | tr '-' '_')
    git checkout -b "$(date +%Y_%m_%d)_$transformed"
  fi
}

function dotf {
  # shellcheck disable=SC2164

  if [ -z "$1" ]; then
    pushd "$PWD" && dotfiles && popd
  else
    pushd "$1" && dotfiles && popd
  fi
}

function merge-diff {
  # show all of the commits that were merged in by <commit>
  # but none of the commits that were already on the branch
  # you get to see this (sort of) when using my `git lg` alias (see my .gitconfig)
  git log "$1^-"
}

function headers {
  # Note: also possible by using 2>&1 after curl
  #       which allows piping of output
  #       curl -v -o /dev/null https://www.buzzfeed.com/?site-router-debug=true 2>&1 | grep -i siterouter

  if [[ "$1" =~ -(h|help)$ ]]; then
    printf "\\n\\t1st param: URL\\n\\t2nd param: regex\\n\\t3rd param: http request header"
    printf "\\n\\n\\tif you have no need for a regex\\n\\tbut need a http header\\n\\tthen just use an empty string ''\\n"
    return
  fi

  if [ -z "$1" ]; then
    printf "\\n\\tExamples:\\n\\t\\theaders https://www.buzzfeed.com/?country=us 'x-(vcl|buzz|cache|site)' '-H User-Agent:iphone'\\n"
    printf "\\t\\theaders https://www.buzzfeed.com/?country=us 'mobile' '-H User-Agent:iphone -H X-Foo:bar'\\n"
    printf "\\t\\theaders https://www.buzzfeed.com/?country=us '' '-H User-Agent:iphone -H X-Foo:bar'\\n"
    printf "\\n\\tHelp:\\theaders -h\\n\\t\\theaders -help\\n"
    return
  fi

  local url=$1
  local pattern=${2:-''}
  local header=${3:-}

  # why define local variables separate from their sub processes?
  # summary: return values are ignored otherwise, and so `set -e` might miss them
  # https://github.com/koalaman/shellcheck/wiki/SC2155
  local response status

  # don't quote $header as it breaks everything
  # shellcheck disable=SC2086
  response=$(curl -H Fastly-Debug:1 $header -D - -o /dev/null -s "$url") # -D - will dump to stdout
  status=$(echo "$response" | head -n 1)

  printf "\\n%s\\n\\n" "$status"
  echo "$response" | sort | tail -n +3 | grep -Ei "$pattern"
}

function replace {
  # given an extension ($1), find all files with that extension,
  # then search each file for the specified text ($2) and
  # replace it with the specified text ($3)
  local extension=$1
  local f=$2
  local r=$3
  find . -type f -name "*.$extension" -exec gsed -i "s/$f/$r/g" {} +
}

function age {
  local filename changed now elapsed
  filename=$1
  changed=$(perl -MFile::stat -e "print stat(\"${filename}\")->mtime")
  now=$(date +%s)
  elapsed=$(("$now"-"$changed"))
  echo $elapsed
}

function search {
  local flags=${1:-}
  local pattern=$2
  local directory=${3:-.}
  local exclude='(build/|\.mypy_cache|\.sav|vendors-bundle\.js|dist/|\.map|\.git/|build\.js|node_modules|tests/|swagger|fb\.js)'

  if [ -z "$1" ]; then
    printf "\\n\\tUsage:\\n\\t\\tsearch <flags:[--]> <pattern:['']> <directory:[./]>\\n"

    # shellcheck disable=SC1117
    # disabled because \\\\b for literal \b (with double quotes) is ridiculous
    printf '\n\tExample:\n\t\tsearch -- "def\\b" ~/code/buzzfeed/mono/site_router'
    printf '\n\t\tsearch "--files Dockerfile -C 5" "FROM node" ./'
    printf '\n\t\tsearch "-A 5" "..." ./  # shows 5 lines before search results'
    printf '\n\t\tsearch "-B 5" "..." ./  # shows 5 lines after search results\n'
    return
  fi

  time sift -n -X json --err-show-line-length --exclude-ipath $exclude $flags "$pattern" "$directory"
  # time grep --exclude-dir .git -irlno $pattern $directory
}

function hmac {
  # share a secret "key" between client and server
  # then if you both generate the same hmac you're ok
  #
  # example (generates hexidecimal output):
  # hmac mds5 "some data to encrypt" "key"
  #
  # example (convert hexidecimal to binary then encode as Base64)
  # hmac sha256 "some data to encrypt" "key" -binary | base64
  digest="$1"
  data="$2"
  key="$3"
  shift 3 # this moves the positional arguments (`help shift`)
          # meaning we can use $@ to print out remaining args
  echo -n "$data" | openssl dgst "-$digest" -hmac "$key" "$@"
}

function spotify {
  # pick random track to start playing playlist from
  local max=${1:-10}
  echo $((1 + RANDOM % max))
}

function search_git {
  # search_git 'def f'
  git rev-list --all | xargs git grep "$1"
}

function vimin {
  # usage: echo foo | vimin 'norm VgU'
  #
  # explanation of how vim handles stdin
  # https://gist.github.com/Integralist/2b01cfdaf9c85efb0de6e2b2085896c3

  # store off standard input piped to this function
  read -d '' -r stdin

  # capture the first parameter passed to this function
  local cmd="$1"

  # re-pipe the standard input to vim with correct flags
  echo "$stdin" | vim - -es --not-a-term +"$cmd" +'%p' +'qa!'
}

# shellcheck disable=SC2034
read -r -d '' git_icons <<- EOF
* unstaged changes
+ staged but uncommitted changes
$ stashed changes
% untracked files
> local commits on HEAD not pushed to upstream
< commits on upstream not merged with HEAD
= HEAD points to same commit as upstream
EOF

# shellcheck disable=SC2034
read -r -d '' dns_help <<- EOF
connectivity debugging steps...

  * check what dns servers are being used:
    dns

  * check we can reach google domain:
    ping google.com

  * execute a dns lookup using different dns servers (one remote, one local):
    nslookup google.com 8.8.8.8
    nslookup google.com 192.168.1.1

  * can we curl an endpoint:
    curl -Lsvo /dev/null http://google.com/

  * also check performance:
    speedtest-cli
EOF

# the following variables are necessary to determine the appropriate formatted
# output (used by the `a` alias defined below)...

# shellcheck disable=SC2034
bold=$(tput bold)
# shellcheck disable=SC2034
normal=$(tput sgr0)

# custom alias'
#
# note: use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
#       alternatively use the `a` alias to show all defined alias' from this file

alias a='cat ~/.bashrc | grep "^alias" | gsed -En "s/alias (\w+)=(.+)/${bold}\1\n  ${normal}\2\n/p"'
alias ascii='man 7 ascii'
alias brew_openssl='/usr/local/opt/openssl/bin/openssl'
alias builtins="enable -a" # list all shell builtins
alias c-="git checkout -"
alias c="clear"
alias cm="git checkout master"

alias commands_dir='echo $PATH | tr ":" "\n" | sort | egrep "^/(usr|bin)"'
alias commands='for i in $(commands_dir):; do eval "ls -l $i"; done'

# Note:
# Slash ('/') immediately after each pathname is a directory
# Asterisk ('*') after each pathname is an executable
# At sign ('@') after each pathname is a symbolic link
# Equals sign ('=') after each pathname is a socket
# Percent sign ('%') after each pathname is a whiteout
# Vertical bar ('|') after each pathname is a FIFO

alias copy="tr -d '\\n' | pbcopy" # e.g. echo $DEV_CERT_PATH | copy
alias datesec='date +%s'
alias did="vim +'normal Go' +'r!date' ~/did.txt"
alias dns="scutil --dns | grep 'nameserver\\[[0-9]*\\]'"
alias dnshelp='echo "$dns_help"'
alias dotfiles="ls -a | grep '^\\.' | grep --invert-match '\\.DS_Store\\|\\.$'"
alias drm='docker rm $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'
alias gb="git branch"
alias gbd="git branch -D"
alias gcp="git cherry-pick -"
alias getcommit="git rev-parse HEAD | tr -d '\\n' | pbcopy"
alias gitupstream="echo git branch -u origin/\\<branch\\>"
alias gpr="git pull --rebase origin master"
alias irc="irssi"
alias ll="ls -laGpFHh"
alias ls="ls -GpF"
alias muttb="mutt -F ~/.muttrc-buzzfeed"
alias nvimupdate="brew reinstall --HEAD neovim" # brew reinstall --env=std neovim
alias pipall="pip freeze --local | grep -v '^\\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.bash_profile" # this also sources .bashrc and also causes `pass` autocomplete to be reloaded
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sshagent='eval "$(ssh-agent -s)" && ssh-add -K ~/.ssh/github_rsa'
alias sshconfig='nvim -c "norm 12ggVjjjgc" -c "wq" ~/.ssh/config && cat ~/.ssh/config | awk "/switch/ {for(i=0; i<=3; i++) {getline; print}}"'
alias sshkey="cd ~/.ssh && ssh-keygen -t rsa -b 4096 -C 'mark.mcdx@gmail.com'"
alias sshvm="ssh dev.buzzfeed.io"
alias tmuxy='bash ~/tmux.sh'
alias uid='echo $(uuidgen)'
alias updates="softwareupdate --list" # --install --all (or) --install <product name>
alias v='$HOME/code/buzzfeed/mono/scripts/rig_vm'
alias wat='echo "$git_icons"'
alias wut='echo "$git_icons"'

eval "$(pyenv init -)"
eval "$(pipenv --completion)"

# lazyload nvm
# all props goes to http://broken-by.me/lazy-load-nvm/
# grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/
#
# NOTE: this will cause some confusing behaviour when opening fresh terminal prompt
#       in that a previously installed command (e.g. npm install -g dockly) won't exist
#       e.g. executing the `dockly` command will fail unless you execute `nvm` first
#       this is because we're lazy loading nvm and so it won't auto-load its default node version

lazynvm() {
  unset -f nvm node npm
  export NVM_DIR=~/.nvm
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
  lazynvm
  nvm "$@"
}

node() {
  lazynvm
  node "$@"
}

npm() {
  lazynvm
  npm "$@"
}

# shellcheck source=/dev/null
# https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
source ~/.bash-preexec.sh

# preexec executes just BEFORE a command is executed
# preexec() { echo "just typed $1"; }

# precmd executes just AFTER a command is executed, but before the prompt is shown
precmd() { prompt; }

# shellcheck source=/dev/null
# provides a fzf command for searching for single files
# but fzf requires piping to pbcopy to be useful
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# we want Ctrl+f to 'find' files using fzf and copy filename to clipboard
# we use `copy`, which is an alias for trimming newline before using pbcopy
bind -x '"\C-f": fzf --preview="cat {}" --preview-window=top:50%:wrap | copy'

# shellcheck disable=SC2016
# we want Ctrl+g to pass files into vim for editing (-m allows multiple file
# selection using Tab)
bind -x '"\C-g": vim $(fzf -m)'
