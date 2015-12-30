#!/bin/sh
set -e

test -n "${SM_REPO_URL}"
test -n "${SM_REPO_PATH}"
test -n "${SM_REPO_REV}"
test -n "${SM_BUILD_PATH}"
test -n "${SM_INSTALL_PATH}"
test -n "${SM_CONFIG_PATH}"

# Install packages
apt-get install --yes cmake git make gcc g++ libbz2-dev libcrypto++-dev libbison-dev flex libmpfr-dev libtbb-dev libhdf5-dev
apt-get install --yes libboost-filesystem-dev libboost-iostreams-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev
apt-get install --yes --no-install-recommends doxygen
apt-get install --yes help2man

sharemind_build() {
    local REPO_URL="$1"
    local REPO_PATH="$2"
    local REPO_REV="$3"
    local BUILD_PATH="$4"
    local INSTALL_PATH="$5"
    local CONFIG_PATH="$6"

    git clone "${REPO_URL}" "${REPO_PATH}"

    local CWD=`pwd`; cd "${REPO_PATH}"
    git reset --hard "${REPO_REV}"

    cp --no-preserve=mode,ownership,timestamps "${CONFIG_PATH}" "${REPO_PATH}/config.local"
    sed -i "s#SET(SHAREMIND_INSTALL_PREFIX \"\${CMAKE_CURRENT_SOURCE_DIR}/prefix\")#SET(SHAREMIND_INSTALL_PREFIX \"${INSTALL_PATH}\")#" "${REPO_PATH}/config.local"

    mkdir --parents "${BUILD_PATH}"
    cd "${BUILD_PATH}"
    cmake "${REPO_PATH}"

    make

    cd "${CWD}"
}

sharemind_build "${SM_REPO_URL}" "${SM_REPO_PATH}" "${SM_REPO_REV}" "${SM_BUILD_PATH}" "${SM_INSTALL_PATH}" "${SM_CONFIG_PATH}"

# /etc/bash.bashrc
cat << EOF >> /etc/bash.bashrc
if [ -z "\$PATH" ]; then
    PATH="${SM_INSTALL_PATH}/bin"
else
    PATH="${SM_INSTALL_PATH}/bin:\$PATH"
fi
export PATH
EOF

# /etc/ld.so.conf
echo "${SM_INSTALL_PATH}/lib" > /etc/ld.so.conf.d/sharemind.conf
ldconfig

# /etc/manpath.config
cat <<EOF >> /etc/manpath.config
MANDATORY_MANPATH ${SM_INSTALL_PATH}/share/man
MANPATH_MAP ${SM_INSTALL_PATH}/bin ${SM_INSTALL_PATH}/share/man
MANDB_MAP ${SM_INSTALL_PATH}/share/man /var/cache/man/local
EOF
