#!/bin/sh
set -e -x

if test -f .vbox_version; then
    # Install dkms for dynamic compiles
    apt-get install --yes dkms

    # If libdbus is not installed, virtualbox will not autostart
    apt-get install --yes --no-install-recommends libdbus-1-3

    # Install the VirtualBox guest additions, assumes "attached"
    mkdir /mnt/vboxguestadditions
    mount -t iso9660 -o loop VBoxGuestAdditions.iso /mnt/vboxguestadditions
    # TODO fix this.
    sh /mnt/vboxguestadditions/VBoxLinuxAdditions.run || true
    umount /mnt/vboxguestadditions || true
    rmdir /mnt/vboxguestadditions || true
    rm VBoxGuestAdditions.iso || true
fi
