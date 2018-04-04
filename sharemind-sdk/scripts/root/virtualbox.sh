#!/bin/bash
set -e -x

if test -f .vbox_version; then
    # Install dkms for dynamic compiles
    apt-get install --yes dkms

    # If libdbus is not installed, virtualbox will not autostart
    apt-get install --yes --no-install-recommends libdbus-1-3

    # Install the VirtualBox guest additions, assumes "attached"
    mkdir /mnt/vboxguestadditions
    mount -t iso9660 -o loop VBoxGuestAdditions.iso /mnt/vboxguestadditions
    sh /mnt/vboxguestadditions/VBoxLinuxAdditions.run --nox11
    sleep 1
    umount /mnt/vboxguestadditions
    rmdir /mnt/vboxguestadditions
    rm VBoxGuestAdditions.iso

    # Add the sharemind user to the vboxsf group so they can access shared folders with no manual work.
    usermod -a -G vboxsf sharemind
fi
