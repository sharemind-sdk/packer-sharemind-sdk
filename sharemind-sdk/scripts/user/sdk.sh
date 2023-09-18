#!/bin/bash
set -e -x

test -n "${SDK_FILES_PATH}"
test -n "${SDK_DESKTOP_ICONS_PATH}"
test -n "${SDK_SM_CONFIG_PATH}"

# Install SDK files
mkdir --parents ~/Sharemind-SDK
cp --recursive --no-preserve=mode,ownership,timestamps "${SDK_FILES_PATH}/." ~/Sharemind-SDK/

# Create a link to the SDK files on the Desktop
mkdir --parents ~/Desktop
ln -s "${HOME}/Sharemind-SDK" "${HOME}/Desktop/Sharemind-SDK"

# Install Desktop icons
cp --recursive --no-preserve=mode,ownership,timestamps "${SDK_DESKTOP_ICONS_PATH}/." ~/Desktop/

# Install Sharemind configuration
mkdir --parents ~/.config
cp --recursive --no-preserve=mode,ownership,timestamps "${SDK_SM_CONFIG_PATH}/." ~/.config/

# Copy *_emu configuration files
cp /usr/local/src/sharemind-sdk.git/mod_shared3p_emu/packaging/configs/sharemind/*.conf ~/.config/sharemind
cp /usr/local/src/sharemind-sdk.git/mod_aby_emu/packaging/configs/sharemind/*.conf ~/.config/sharemind
cp /usr/local/src/sharemind-sdk.git/mod_spdz_fresco_emu/packaging/configs/sharemind/*.conf ~/.config/sharemind

# Expand ModelEvaluatorConfiguration lines to full paths for modules that don't support %{CurrentFileDirectory}
# for config in aby_emu.cfg spdz_fresco_emu.cfg; do
#     sed -i "s+ModelEvaluatorConfiguration\s\=\s+ModelEvaluatorConfiguration = $(readlink -f ~/.config/sharemind)/+" ~/.config/sharemind/$config
# done;
