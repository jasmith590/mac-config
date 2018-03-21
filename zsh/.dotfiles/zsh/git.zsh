gitpush(){
	git push beanstalk HEAD
}

# to get current branch us feature_branch=$(current_branch)

git-diff-tar(){
	tar cvzf changes.tar.gz `git diff --name-status HEAD~$1 HEAD~$2 | awk '/^[^D]/ {print $2}'`
}

git-diff(){
	git diff --name-status HEAD~$1 HEAD~$2 | awk '/^[^D]/ {print $2}'
}

glno(){
	git log --name-only
}

gpffo(){
	git pull --ff-only
}

git-delete-branches(){
	git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | xargs -n 1 git branch -d
}

git-ignore(){
	echo ".vscode/" >> .git/info/exclude
	echo ".vscode/ added to local gitignore"
}
