# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="ducknorris"
#ZSH_THEME="agnoster"
ZSH_THEME="clean"
DEFAULT_USER="jamiesmith"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sublime brew colorize git-extras osx bower composer gitfast tmux)

# User configuration
DATE=$(date +'20%y-%m-%d')



export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

alias n98="n98-magerun.phar"

alias clearcache="n98 cache:clean"

alias cleareecache="rm -rf var/cache/ var/full_page_cache/ var/session/ media/css/ media/css_secure/ media/js/"

alias g2sites="cd /Volumes/Sites"

alias updatesubs="git submodule foreach git pull"

alias g2projects="cd /Users/jamiesmith/Documents/Projects"
alias g2repos="cd /Users/jamiesmith/Repos"

# --------------------------------------------------------------------
# Completion Styles
# --------------------------------------------------------------------

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#
#NEW completion:
# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

clear-cache(){
        rm -rf var/cache/*
}

clear-ee-cache(){
    sudo rm -rf var/cache/*
    sudo rm -rf /tmp/magento/var/*
    sudo rm -rf var/full_page_cache/*
}

__git_files () {
    _wanted files expl 'local files' _files
}

mac-clean(){
        find . -name '._*' -exec rm -v {} \;
        find . -name '._.*' -exec rm -v {} \;
        find . -name '.DS_Store' -exec rm -v {} \;
}

watch-apache(){
    tail -f /var/log/apache2/error.log
}

watch-exception(){
    tail -f var/log/exception.log
}

watch-system(){
    tail -f var/log/system.log
}

rm-profiler-data(){
    sudo rm -rf /tmp/cachegrind.out.*
}

clear-compiled(){
    rm -rf media/css/*.css media/js/*.js
}

staging(){
    git checkout staging
}

pull-staging(){
    git pull beanstalk staging
}

push-staging(){
    git push beanstalk staging
}

production(){
    git checkout production
}

pull-production(){
    git pull beanstalk production
}

push-production(){
    git push beanstalk production
}

pull-beanstalk(){
    git pull beanstalk
}
status(){
    git status
}

merge-staging(){
    feature_branch=$(current_branch)
    staging
    pull-staging
    git merge $feature_branch
    push-staging
    git checkout $feature_branch
}

merge-production(){
    feature_branch=$(current_branch)
    production
    pull-production
    git merge $feature_branch
    push-production
    git checkout $feature_branch
}

pushed-branch(){
    feature_branch=$(current_branch)
    pushed='pushed/'
    git branch -m $feature_branch $pushed$feature_branch
    production
}

hosts(){
    vim /etc/hosts
}

################################################################################
## APPEND THIS TO YOUR ~/.ZSHRC FILE ###########################################
################################################################################

# Adding custom completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

export DOTFILESDIR=$HOME/.dotfiles

# IMPORTANT! FILL OUT PER USER!
MAGE_USER="jsmith" #Will be used in Magento for creating admin/customers
MAGE_PASS="pass123" #Will be used in Magento for creating admin/customers
MYSQL_USER="root"
MYSQL_PASS="root"

#Include all files that end with .zsh in home directory
config_files=($DOTFILESDIR/**/*.zsh)
# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done
export PATH="/usr/local/sbin:$PATH"
export PATH="~/phantomjs/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NVM_DIR="/Users/jamiesmith/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export RELEASE_OAUTH_TOKEN=bc20cde886b461b1aafe9442a8a3bc5f3ff8256f
export PATH="$PATH:/Users/jamiesmith/.badevops/bin"

export PATH="$HOME/.yarn/bin:$PATH"
autoload -U +X bashcompinit && bashcompinit
for __bootstrap_autofile in "/Users/jamiesmith/.badevops/lib/autocomplete.d/"*; do source "$__bootstrap_autofile"; done
export GOPATH=$HOME/.goprojects
export PATH=$PATH:$GOPATH/bin
