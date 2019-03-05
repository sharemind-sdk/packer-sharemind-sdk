#!/bin/bash
set -e -x

# Delete SSH host keys
rm -f /etc/ssh/ssh_host_*

# Add a cron entry to generate new SSH keys on boot and remove that line after execution
CRONCMD="@reboot /usr/sbin/dpkg-reconfigure openssh-server"
CRONLINE="$CRONCMD; crontab -l -u root | grep -v '$CRONCMD;' | crontab -u root -"

(crontab -l || true; echo $CRONLINE) | crontab -u root -
