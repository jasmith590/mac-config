alias reload!='. ~/.zshrc'

#=====
#Git
#=====
alias gsl='git status | less'

g2s(){
        g2sites && cd $1
}

getip(){
ifconfig | grep -a inet
}
