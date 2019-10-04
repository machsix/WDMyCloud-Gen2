#!/bin/bash

set +e

OLD_CWD=`pwd`
# check changed files
export CHANGED=`git diff-tree --no-commit-id --name-only -r ${TRAVIS_COMMIT}`
# pack package
export COMMITER=`git log -1 --pretty=format:'%an'`
newPack=0
if [ $COMMITER != "Travis CI" ]; then
  for i in */; do
    if [ "$i" != "Aria2" ]; then
      if [ -f "$i/apkg.rc" ]; then
        if grep -q $i <<< "$CHANGED"; then
          cd $i
          find . -name '*.sh' -exec chmod +x '{}' \;
          chmod +x sbin/* > /dev/null 2>&1 || true
          chmod +x bin/*  > /dev/null 2>&1 || true
          echo -e "\e[1m\e[41m\e[97mPackage:   ${i}\e[0m"
          ../mksapkg -E -s -m WDMyCloud
          cd ..
          newPack=1
        fi
      fi
    fi
  done
  if [ $newPack == "1" ]; then
    mkdir -p Release
    mv WDMyCloud* Release/
    cd Release
    for i in *; do
      mv $i ${i%\(*\)} > /dev/null 2>&1 || true
    done
    cd ..
  fi
fi

cd $OLD_CWD
