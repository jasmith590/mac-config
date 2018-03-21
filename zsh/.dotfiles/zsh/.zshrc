# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh


ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting)

export TERM=xterm-256color 

DATE=$(date +'20%y-%m-%d')

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:


################################################################################
## APPEND THIS TO YOUR ~/.ZSHRC FILE ###########################################
################################################################################

export DOTFILESDIR=$HOME/.dotfiles

# IMPORTANT! FILL OUT PER USER!
MAGE_USER="<username>" #Will be used in Magento for creating admin/customers
MAGE_PASS="<password>" #Will be used in Magento for creating admin/customers
MYSQL_USER="<username>"
MYSQL_PASS="<password>"

#Include all files that end with .zsh in home directory
config_files=($DOTFILESDIR/**/*.zsh)
# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

