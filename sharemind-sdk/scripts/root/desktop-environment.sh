#!/bin/bash
set -e -x

test -n "${DE_AUTOLOGIN_USERNAME}"
test -n "${DE_DESKTOP_BG_COLOR}"
test -n "${DE_DESKTOP_BG_MODE}"

# Install dependencies
apt-get install --yes lxde

# /etc/lightdm/lightdm.conf
sed -i "s/^#autologin-user=$/autologin-user=${DE_AUTOLOGIN_USERNAME}/" /etc/lightdm/lightdm.conf
sed -i "s/^#autologin-user-timeout=0$/autologin-user-timeout=0/" /etc/lightdm/lightdm.conf

# /etc/xdg/pcmanfm/LXDE/pcmanfm.conf
sed -i "s/^wallpaper_mode=.*$/wallpaper_mode=${DE_DESKTOP_BG_MODE}/" /etc/xdg/pcmanfm/LXDE/pcmanfm.conf
sed -i "s/^desktop_bg=.*$/desktop_bg=${DE_DESKTOP_BG_COLOR}/" /etc/xdg/pcmanfm/LXDE/pcmanfm.conf

# Hide Trash icon from desktop
sed -i '/^\[desktop\]/a show_trash=0' /etc/xdg/pcmanfm/LXDE/pcmanfm.conf

# /etc/xdg/libfm/libfm.conf
# Disable the execute warning of .desktop files
# This enables the "Don't ask option to launch executable file" checkbox in PCManFM preferences
sed -i '/^\[config\]/a quick_exec=1' /etc/xdg/libfm/libfm.conf