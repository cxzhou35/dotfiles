#! /bin/bash

# get current direction
curDir=$(pwd)

# get shell direction
workDir=$(
  cd "$(dirname "$0")"
  pwd
)

cd $workDir

rich "[INFO]Working on $workDir" -p --style "on blue"

# check if there is any changes
if [ -z "$(git status --porcelain)" ]; then
  rich "[INFO]No changes to commit" -p --style "on orange3"
  exit 0
fi

lazygit
# git add -A

if [ $# -gt 0 ]; then
  if [ $# -eq 2 ]; then
    git commit -m "[#$1] $2"
  else
    git commit -m "[+] $@"
  fi
else
  git commit -m "[Default] Sync Local Files"
fi

git push

# check if fail
if [ $? -eq 0 ]; then
  rich "Sync Failed!" -p -a heavy --style "on red"
  exit 1
else
  rich "Sync Success!" -p -a heavy --style "on green"
fi

cd $curDir
