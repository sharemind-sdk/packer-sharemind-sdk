#!/bin/sh
set -e -x

# Disable clipit question at startup
mkdir --parents "${XDG_CONFIG_HOME:-${HOME}/.config}/clipit"
cat << EOF > "${XDG_CONFIG_HOME:-${HOME}/.config}/clipit/clipitrc"
[rc]
save_history=true
EOF
