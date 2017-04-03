#!/bin/bash
set -e -x

test -n "${QTCREATOR_SECREC_MIME_PATH}"

# Install packages
apt-get install --yes qtcreator

# Install MIME files
cp --no-preserve=mode,ownership,timestamps "${QTCREATOR_SECREC_MIME_PATH}" /usr/share/mime/packages/
update-mime-database /usr/share/mime

# Make QtCreator a valid program for opening SecreC files
cat <<EOF >> /usr/share/applications/mimeapps.list
[Added Associations]
text/vnd.cyber.secrec=qtcreator.desktop
EOF
