#!/bin/sh
set -e

test -n "${QTCREATOR_CONFIG_PATH}" || false

# Configure qtcreator
mkdir --parents ~/.config
cp --recursive --no-preserve=mode,ownership,timestamps "${QTCREATOR_CONFIG_PATH}/." ~/.config/
