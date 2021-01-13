#!/bin/bash
set -e -x

test -n "${PV_REPO_URL}"
test -n "${PV_REPO_PATH}"
test -n "${PV_REPO_REV}"
test -n "${PV_INSTALL_PATH}"
test -n "${PV_SCRIPTS_PATH}"

# Install packages
apt-get update
apt-get install --yes apt-transport-https nodejs npm libnss3-dev libgconf-2-4

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

    # For some reason Electron fails to start because it's missing a `patch.txt` file.
    # We'll re-download an archive containing this file.
    # https://github.com/electron-userland/electron-prebuilt/issues/76#issuecomment-204650296
    cd node_modules/electron-prebuilt
    npm run postinstall

    cd "${CWD}"
}

visualizer_build "${PV_REPO_URL}" "${PV_REPO_PATH}" "${PV_REPO_REV}" "${PV_INSTALL_PATH}"

# Install visualizer scripts
cp --recursive --no-preserve=ownership,timestamps "${PV_SCRIPTS_PATH}/." "${PV_INSTALL_PATH}/bin/"
