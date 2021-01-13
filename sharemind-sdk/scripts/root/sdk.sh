#!/bin/bash
set -e -x

test -n "${SDK_BG_IMG_PATH}"
test -n "${SDK_INSTALL_PATH}"
test -n "${SDK_SCRIPTS_PATH}"

# Install desktop-background
# TODO png -> svg
cp --no-preserve=mode,ownership,timestamps "${SDK_BG_IMG_PATH}" /usr/share/images/desktop-base/sharemind-sdk-wallpaper.png
update-alternatives --install /usr/share/images/desktop-base/desktop-background desktop-background /usr/share/images/desktop-base/sharemind-sdk-wallpaper.png 80
update-alternatives --set desktop-background /usr/share/images/desktop-base/sharemind-sdk-wallpaper.png

# Set up SDK scripts
cp --recursive --preserve=mode "${SDK_SCRIPTS_PATH}/." "${SDK_INSTALL_PATH}/bin/"
