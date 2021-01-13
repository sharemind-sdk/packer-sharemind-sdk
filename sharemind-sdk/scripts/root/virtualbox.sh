#!/bin/bash
set -e -x

if test -f .vbox_version; then
    # Install dkms for dynamic compiles
    apt-get install --yes dkms

    # If libdbus is not installed, virtualbox will not autostart
    apt-get install --yes --no-install-recommends libdbus-1-3

    # Install current kernel headers needed by guest additions separately
    apt-get install --yes --no-install-recommends linux-headers-$(uname -r)

    # Install the VirtualBox guest additions, assumes "attached"
    mkdir /mnt/vboxguestadditions
    mount -t iso9660 -o loop VBoxGuestAdditions.iso /mnt/vboxguestadditions

    # This script is apparently broken for an eternity.
    # https://stackoverflow.com/questions/25434139/vboxlinuxadditions-run-never-exits-with-0
    # (note: the module is not in `.../extra/...` but in `.../misc/...`
    bash -x /mnt/vboxguestadditions/VBoxLinuxAdditions.run --nox11 || true
    if ! test -f /lib/modules/$(uname -r)/misc/vboxsf.ko; then
        echo "installation of guest additions unsuccessful"
        exit 1
    fi
    sleep 1
    umount /mnt/vboxguestadditions
    rmdir /mnt/vboxguestadditions
    rm VBoxGuestAdditions.iso

    # Add the sharemind user to the vboxsf group so they can access shared folders with no manual work.
    usermod -a -G vboxsf sharemind
fi
