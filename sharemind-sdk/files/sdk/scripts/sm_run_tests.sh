#!/usr/bin/env bash

if [ "x${BUILD_SDK_PREFIX}" = "x" ]; then
    BUILD_SDK_PREFIX="/usr/local/src/sharemind-sdk.git"
fi

echo "Using BUILD_SDK_PREFIX='${BUILD_SDK_PREFIX}'"

STDLIB="${BUILD_SDK_PREFIX}/stdlib"
TESTS="${STDLIB}/tests"

if [ "x${SHAREMIND_INSTALL_PREFIX}" = "x" ]; then
    SHAREMIND_INSTALL_PREFIX="/usr/local/sharemind"
fi

echo "Using SHAREMIND_INSTALL_PREFIX='${SHAREMIND_INSTALL_PREFIX}'"

EMULATOR="${SHAREMIND_INSTALL_PREFIX}/bin/sharemind-emulator"
EMULATOR_CFG=`test -f ${XDG_CONFIG_HOME:-~/.config}/sharemind/emulator.cfg && echo ${XDG_CONFIG_HOME:-~/.config}/sharemind/emulator.cfg`
SCC="${SHAREMIND_INSTALL_PREFIX}/bin/scc"
STDLIB="${SHAREMIND_INSTALL_PREFIX}/lib/sharemind/stdlib"

TMP=`mktemp -d` || exit 1

compile_and_run() {
    for SC in "$@"; do
	echo "${SC}"
        SC_ABSS=`readlink -f "${SC}"`
    
        if [ ! -f "${SC_ABSS}" ]; then
            exit 1
        fi
    
        SC_ABSSP=`dirname "${SC_ABSS}"`
        SC_BN=`basename "${SC}"`
        SB_BN=`echo "${SC_BN}" | sed 's/sc$//' | sed 's/$/sb/'`
        SB="${TMP}/${SB_BN}"
    
        echo "Compiling: '${SC}' to '${SB}'"
        "${SCC}" --include "${TESTS}" --include "${SC_ABSSP}" --include "${STDLIB}" --input "${SC}" --output "${SB}"
        if [ $? -ne 0 ]; then
            continue
        fi
    
        echo "Running: '${SB}'"
        "${EMULATOR}" --conf="${EMULATOR_CFG}" -d "${SB}"
        if [ $? -ne 0 ]; then
            continue
        fi
    done
}

run_all_tests() {
    TEST_SETS=`find "${TESTS}" -mindepth 1 -type d`
    for SET in ${TEST_SETS}; do
        echo "Running testset: `basename ${SET}`"
        FILES=`find ${SET} -maxdepth 1 -type f -name "*.sc"`
        compile_and_run ${FILES}
        if [ $? -ne 0 ]; then
            echo "Error"
            exit 1
        fi
    done
}

if [ "$1" = "" ]; then
    run_all_tests
elif [ -f "$1" ]; then
    compile_and_run "$1"
else
    echo "Usage of sm_run_tests.sh:"
    echo "sm_run_tests.sh [filename.sc]"
    echo "If no filename is specified, all tests will be run."
fi
