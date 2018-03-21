__git_files () {
    _wanted files expl 'local files' _files
}

mac-clean(){
        find . -name '._*' -exec rm -v {} \;
        find . -name '._.*' -exec rm -v {} \;
        find . -name '.DS_Store' -exec rm -v {} \;
}

my-machine-info(){
	lsb_release -a
}

ssh-search(){
	less ~/.ssh/config | grep -A 2 $1
}

baseline(){
	restart-apache
	sudo service mysql restart
	n98-magerun.phar db:query "RESET QUERY CACHE;"
	clear-cache
	clear-session
	rm -rf media/catalog/product/cache/*
}

replace-file(){
	sed -e s/$1/$2/g $3 $4
}

complete-path(){
	find `pwd` -name $1
}

#useage example - 'open-zsh apache' will open ~/dotfiles/zsh/apache.zsh
open-zsh(){
	st ~/.dotfiles/zsh/"$1".zsh&
}

