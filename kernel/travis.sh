#!/bin/bash
set +e
OLD_CWD=`pwd`
REPO_DIR=${TRAVIS_BUILD_DIR}
echo $REPO_DIR
export CHANGED=`git diff-tree --no-commit-id --name-only -r ${TRAVIS_COMMIT}`
export COMMITER=`git log -1 --pretty=format:'%an'`
if [ $COMMITER != "Travis CI" ]; then
  if grep -qE "kernel/build-kernel\.sh|kernel/kernel\.config" <<< $CHANGED; then
    KERNEL_DIR=${REPO_DIR}/kernel
    mkdir -p ${KERNEL_DIR}/temp
    cd ${KERNEL_DIR}
    chmod +x *.sh
    ./prepare-kernel.sh ${KERNEL_DIR}/temp
    ./build-kernel.sh ${KERNEL_DIR}/temp

    version=`cat ${KERNEL_DIR}/temp/build/version`
    if [ -d ${KERNEL_DIR}/${version} ]; then
      rm -rf ${KERNEL_DIR}/${version}
    fi
    mkdir -p ${KERNEL_DIR}/${version}
    mv -f ${KERNEL_DIR}/temp/build/${version}/uImage        ${KERNEL_DIR}/${version}/
    mv -f ${KERNEL_DIR}/temp/build/${version}/lib/modules   ${KERNEL_DIR}/${version}/
    cd ${KERNEL_DIR}/${version}
    tar czvf modules.tar.gz modules
    rm -rf modules
    rm -rf ${KERNEL_DIR}/temp
  fi
fi
cd ${OLD_CWD}
