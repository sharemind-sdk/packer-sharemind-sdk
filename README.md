# Sharemind SDK virtual machine build configuration

The following packer builders are currently supported:

* VirtualBox

## Build instructions

Requirements:

* [packer](https://packer.io/) (tested with version 0.8.7)
* [VirtualBox](https://www.virtualbox.org/) (tested with version 4.3.32)

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
