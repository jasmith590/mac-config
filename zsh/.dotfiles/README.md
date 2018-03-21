dotfiles
========


## Adding to the repo 

This is a company repo, that means you can add to it as you wish, but make sure to document your changes by writing the function name, parameters and what it does.



## Steps to clone 


1. Create .dotfiles folder
2. Clone this repo into that directory
3. Open the .dofiles/zsh/.zshrc and follow the instructions in that file
4. Done


## .zshrc 


Set your theme here

Set path variables

Set Mage_User, Mage_Pass, Mysql_User, Mysql_Pass

And it also runs through all folders and sub-folders 1 level down in the .dotfiles directory and sources any file that ends in .zsh.



## aliases.zsh 

reload!: reloads the shell without having to restart it. 
gsl: git status | less


## apache.zsh 

watch-apache: uses 'tail' to print the last 10 lines of /var/log/apache2/error.log

restart-apache: Restarts apatche

add-site (parameter: site_name): adds .dev to the end of site_name, creates a file with virtual host in site-available,
enables site, restarts apache2, creates a reference in the /etc/hosts file as site_name.dev

rsync-example: 


## binding.zsh 

Just look at the file. 

Adds IDE like navigation


## completion.zsh 

Completion styles and etc. 

Also uses /etc/hosts, known_hosts and ssh_config for hostname completetion.


## git.zsh 

gitpush: Pushes changes from HEAD to beanstalk

git-diff-tar(parameter: Commit1, Commit2): get changes between two commits and tars them

git-diff(parameter: Commit1, Commit2): displays the changes between two commits


## magento.zsh 

fix-permission: tells git to ignore permission tracking and changes permissions of media/, var/ and app/etc/ to 777

clear-cache: deletes contents of var/cache/\*, /tmp/magento/var/\*, var/full\_page\_cache/\*

clear-session: deletes contents of var/session/\*

watch-exception: calls 'tail' on var/log/exception.log

watch-system: calls 'tail' on var/log/system.log

rm-profiler-data: deletes contents in /tmp/cachegrind.out.\*

clear-compiled: deletes contents in media/css/\*css and media/js/\*.js

reindex-site: reindexes site

magento-base-setup: Sets up basic database for Magento
magento
-sanitize: Cleans up customer, dataflow, log, sales, etc.

magento-delete-customers: deletes customers

magento-database-table-sizes(parameter: database_name): returns table sizes of a given database_name

magento-admin-user-create: Creates admin user

magento-customer-create: creates customer


## mysql.zsh 

my-mysql: logs into mysql using MYSQL_USER and MYSQL_PASS in the .zshrc

mysql-import-sql-file(parameter: database_name, file_name): imports data from file to database

mysql-import-gzip-sql-file(parameter: database_name, file_name): imports data from gzipped filed after gunzipping it. 

mysql-sanitize-file(parameter: database_name, file_name): removes difiners from databse and outputs them to file_name


## utilities.zsh 

__git_files:

mac-clean: cleans up mac

my-machine-info: returns computer information

ssh-search(parameter: query): search ~/.ssh/config for query

baseline: returns the baseline for magento

replace-file(parameter:file_to_replace, query_to_replace, replace_with, file_to_output_to): replaces contents of a file with something else

complete_path(parameter: file_name): returns the complete path for any file

open-zsh(parameter: file_name): opens the .zsh files in the parameter from the .dotfiles repo 