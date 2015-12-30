#!/bin/sh
set -e

test -n "${PV_REPO_URL}"
test -n "${PV_REPO_PATH}"
test -n "${PV_REPO_REV}"
test -n "${PV_INSTALL_PATH}"
test -n "${PV_SCRIPTS_PATH}"

# Install packages
apt-get install --yes git npm nodejs nodejs-legacy libnss3-dev

visualizer_build() {
    local REPO_URL="$1"
    local REPO_PATH="$2"
    local REPO_REV="$3"
    local INSTALL_PATH="$4"

    git clone "${REPO_URL}" "${REPO_PATH}"

    local CWD=`pwd`; cd "${REPO_PATH}"
    git reset --hard "${REPO_REV}"

    cd "${REPO_PATH}"
    npm install "--prefix=${INSTALL_PATH}" -g
    cd "${CWD}"
}

visualizer_build "${PV_REPO_URL}" "${PV_REPO_PATH}" "${PV_REPO_REV}" "${PV_INSTALL_PATH}"

# Install visualizer scripts
cp --recursive --no-preserve=ownership,timestamps "${PV_SCRIPTS_PATH}/." "${PV_INSTALL_PATH}/bin/"
