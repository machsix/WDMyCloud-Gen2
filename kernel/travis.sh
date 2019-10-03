#!/bin/bash
set +e
OLD_CWD=`pwd`
REPO_DIR=${TRAVIS_BUILD_DIR}
echo $REPO_DIR
export CHNAGED=`git diff-tree --no-commit-id --name-only -r ${TRAVIS_COMMIT}`
export COMMITER=`git log -1 --pretty=format:'%an'`
if [ $COMMITER != "Travis CI" ]; then
  if grep -q "kernel/build-kernel.sh" <<< "$CHNAGED"; then
    KERNEL_DIR=${REPO_DIR}/kernel
    mkdir -p ${KERNEL_DIR}/temp
    cd ${KERNEL_DIR}
    chmod +x *.sh
    ./prepare-kernel.sh ${KERNEL_DIR}/temp
    ./build-kernel.sh ${KERNEL_DIR}/temp
    mv ${KERNEL_DIR}/temp/build/uImage* ${KERNEL_DIR}/
    rm -rf ${KERNEL_DIR}/temp
  fi
fi
cd ${OLD_CWD}
