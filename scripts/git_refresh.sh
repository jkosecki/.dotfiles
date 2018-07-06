#!/bin/bash


if git rev-parse --git-dir > /dev/null 2>&1; then
	currentBranch=$(git rev-parse --abbrev-ref HEAD)
	git master
	git checkout $currentBranch
	git rebase master
	
	exit 0
else
	echo "Not in GIT repository"
	exit 1
fi


