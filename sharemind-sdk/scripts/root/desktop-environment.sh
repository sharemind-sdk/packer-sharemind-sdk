#!/bin/sh
set -e

test -n "${DE_AUTOLOGIN_USERNAME}" || false
test -n "${DE_DESKTOP_BG_COLOR}" || false
test -n "${DE_DESKTOP_BG_MODE}" || false

# Install dependencies
apt-get install --yes lxde

# /etc/lightdm/lightdm.conf
sed -i "s/^#autologin-user=$/autologin-user=${DE_AUTOLOGIN_USERNAME}/" /etc/lightdm/lightdm.conf
sed -i "s/^#autologin-user-timeout=0$/autologin-user-timeout=0/" /etc/lightdm/lightdm.conf

# /etc/alternatives/libgksu-gconf-defaults
sed -i 's#/apps/gksu/sudo-mode false#/apps/gksu/sudo-mode true#' /etc/alternatives/libgksu-gconf-defaults
update-gconf-defaults

# /etc/xdg/pcmanfm/LXDE/pcmanfm.conf
sed -i "s/^wallpaper_mode=.*$/wallpaper_mode=${DE_DESKTOP_BG_MODE}/" /etc/xdg/pcmanfm/LXDE/pcmanfm.conf
sed -i "s/^desktop_bg=.*$/desktop_bg=${DE_DESKTOP_BG_COLOR}/" /etc/xdg/pcmanfm/LXDE/pcmanfm.conf

cat <<EOF >> /etc/xdg/pcmanfm/LXDE/pcmanfm.conf

[desktop]
show_trash=0
EOF
