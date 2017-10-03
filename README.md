# Sharemind SDK virtual machine build configuration

The following packer builders are currently supported:

* VirtualBox

## Build instructions

Requirements:

* [packer](https://packer.io/) (tested with version 1.1.0)
* [VirtualBox](https://www.virtualbox.org/) (tested with version 5.1.22)

Build:

```bash
# Build the base image
cd sharemind-sdk-base
packer build packer.json
cd ..

# Build the SDK from the base image
cd sharemind-sdk
packer build packer.json
```

## Copyright and license

```
Copyright (C) 2017 Cybernetica

Research/Commercial License Usage
Licensees holding a valid Research License or Commercial License
for the Software may use this file according to the written
agreement between you and Cybernetica.

GNU General Public License Usage
Alternatively, this file may be used under the terms of the GNU
General Public License version 3.0 as published by the Free Software
Foundation and appearing in the file LICENSE.GPL included in the
packaging of this file.  Please review the following information to
ensure the GNU General Public License version 3.0 requirements will be
met: http://www.gnu.org/copyleft/gpl-3.0.html.

For further information, please contact us at sharemind@cyber.ee.
```
