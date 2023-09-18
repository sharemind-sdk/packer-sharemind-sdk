#!/bin/bash
set -e -x

# Install zerofree to be used in the "minimize" step
apt-get install --yes zerofree

apt-get clean

# Remove /etc/resolv.conf
rm -f /etc/resolv.conf

# Discard unused blocks on a mounted filesystem
fstrim -a -v
