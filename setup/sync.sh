#! /bin/bash

# get current direction
curDir=$(pwd)

# get shell direction
workDir=$(
  cd "$(dirname "$0")"
  pwd
)

cd $workDir

echo "[INFO]Working on $workDir"

# check if there is any changes
if [ -z "$(git status --porcelain)" ]; then
  echo "[INFO]No changes to commit"
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
if [ $? -ne 0 ]; then
  echo "[INFO]Sync Failed!"
  exit 1
else
  echo "[INFO]Sync Success!"
fi

cd $curDir
