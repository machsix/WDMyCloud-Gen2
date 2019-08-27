#!/bin/bash

set +e

export CHNAGED=`git diff-tree --no-commit-id --name-only -r ${TRAVIS_COMMIT}`
# pack package
export COMMITER=`git log -1 --pretty=format:'%an'`
if [ $COMMITER != "Travis CI" ]; then
  for i in */; do
    if [ "$i" != "Aria2" ]; then
      if [ -f "$i/apkg.rc" ]; then
        if grep -q $i <<< "$CHNAGED"; then
          cd $i
          find . -name '*.sh' -exec chmod +x '{}' \;
          chmod +x sbin/* > /dev/null 2>&1 || true
          chmod +x bin/*  > /dev/null 2>&1 || true
          echo "pack $i"
          ../mksapkg -E -s -m WDMyCloud
          cd ..
        fi
      fi
    fi
  done
  mkdir -p Release
  mv WDMyCloud* Release/ || true
  cd Release
  for i in *; do
    mv $i ${i%\(*\)} > /dev/null 2>&1 || true
  done
fi
