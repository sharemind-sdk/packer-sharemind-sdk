#!/bin/bash
set -e -x

echo "Rebooting the machine ..."
nohup /bin/sh -c 'sleep 2; killall sshd; reboot' &
sleep 60
