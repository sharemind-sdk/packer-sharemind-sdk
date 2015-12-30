#!/bin/sh
set -e

test -n "${CLEANUP_ZEROFREE_SYSTEMD_SERVICE}"
test -n "${CLEANUP_ZEROFREE_SERVICE}"

# Install packages
apt-get install --yes zerofree

# Install the zerofree service
cp --no-preserve=ownership,timestamps "${CLEANUP_ZEROFREE_SERVICE}" /etc/init.d/
cp --no-preserve=mode,ownership,timestamps "${CLEANUP_ZEROFREE_SYSTEMD_SERVICE}" /etc/systemd/system/

systemctl enable zerofree.service

# Run zerofree on next boot
touch /zerofree
