#!/bin/bash
set -e -x

test -n "${QTCREATOR_CONFIG_PATH}"
test -n "${SM_INSTALL_PATH}"

# Configure qtcreator
mkdir --parents ~/.config
cp --recursive --no-preserve=mode,ownership,timestamps "${QTCREATOR_CONFIG_PATH}/." ~/.config/
cp --recursive --no-preserve=mode,ownership,timestamps "${SM_INSTALL_PATH}/share/qtcreator"  ~/.config/QtProject/
