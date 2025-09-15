#!/bin/bash

# Update X-git repo weekly using cron
# Args: Git Directory

UPDATE_DATE=`date +%Y_%m_%d`
PATH_TO_REPO="$HOME/workspace/sys"

cd $PATH_TO_REPO

# Check if Modified, new file or deleted
# git status | grep modified | cut -f4 -d" "
# git add . before commit

# Untracked files

git commit -a -m "Auto Git Update $UPDATE_DATE"
git push
