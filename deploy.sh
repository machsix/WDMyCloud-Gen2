#!/bin/bash

set +e

export TOKEN=$1
# upload rpm back to github
export COMMITER=`git log -1 --pretty=format:'%an'`
if [[ $COMMITER != "Travis CI" ]]; then
  git remote set-url origin https://machsix:${TOKEN}@github.com/machsix/WDMyCloud-Gen2.git
  git fetch
  git config --global user.email "travis@travis-ci.com"
  git config --global user.name "Travis CI"
  git add Release || true
  git commit -m "Pack ${TRAVIS_COMMIT} [skip ci]"
  git push origin HEAD:master
fi
