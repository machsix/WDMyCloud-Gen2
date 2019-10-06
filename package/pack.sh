#!/bin/bash

set +e

REPO_DIR=`realpath ../`
FOLDER="package"

if grep -q "/${FOLDER}" <<< `pwd`; then
  OLD_CWD=`pwd`
else
  exit 1
fi

# check changed files
export CHANGED=`git diff-tree --no-commit-id --name-only -r HEAD`
# pack package
export COMMITER=`git log -1 --pretty=format:'%an'`
newPack=0
if [ $COMMITER != "Travis CI" ]; then
  for i in */; do
    PKG_NAME=${i%/}
    if [ -f "${PKG_NAME}/apkg.rc" ]; then
      if grep -q "${FOLDER}/${PKG_NAME}" <<< "$CHANGED"; then
        cd ${PKG_NAME}
        find . -name '*.sh' -exec chmod +x '{}' \;
        chmod +x sbin/* > /dev/null 2>&1 || true
        chmod +x bin/*  > /dev/null 2>&1 || true
        echo -e "\e[1m\e[41m\e[97mPackage:   ${i}\e[0m"
        ../mksapkg -E -s -m WDMyCloud
        cd ..
        newPack=1
      fi
    fi
  done
  if [ $newPack == "1" ]; then
    for i in WDMyCloud*.bin(*); do
      echo -e "\e[1m\e[41m\e[97mPackage:   ${i}\e[0m"
      mv $i ${i%\(*\)} > /dev/null 2>&1 || true
    done
    mkdir -p ${REPO_DIR}/Release
    mv WDMyCloud*.bin ${REPO_DIR}/release/
  fi
fi

cd $OLD_CWD
