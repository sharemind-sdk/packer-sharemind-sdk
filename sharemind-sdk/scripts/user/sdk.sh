#!/bin/bash
set -e -x

test -n "${SDK_FILES_PATH}"
test -n "${SDK_DESKTOP_ICONS_PATH}"
test -n "${SDK_SM_CONFIG_PATH}"

# Install SDK files
mkdir --parents ~/Sharemind-SDK
cp --recursive --no-preserve=mode,ownership,timestamps "${SDK_FILES_PATH}/." ~/Sharemind-SDK/

# Install Desktop icons
mkdir --parents ~/Desktop
cp --recursive --no-preserve=mode,ownership,timestamps "${SDK_DESKTOP_ICONS_PATH}/." ~/Desktop/

# Install Sharemind configuration
mkdir --parents ~/.config
cp --recursive --no-preserve=mode,ownership,timestamps "${SDK_SM_CONFIG_PATH}/." ~/.config/
# Install Sharemind configurations created by build-sdk
cp /usr/local/sharemind/bin/*.cfg ~/.config/sharemind
# Expand ModelEvaluatorConfiguration configs to full paths
sed -i "s+ModelEvaluatorConfiguration\s\=\s+ModelEvaluatorConfiguration = $(readlink -f ~/.config/sharemind)/+" ~/.config/sharemind/*