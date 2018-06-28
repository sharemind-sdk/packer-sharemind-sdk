Building the VM-s requires Packer.

It can be obtained from https://releases.hashicorp.com/packer/ .

Accessing repos in intranet over SSH requires key-based access via ssh-agent.

1. Build the base VM
`cd ../base; packer build packer.json`

2. Build the base-gui VM
`cd ../base-gui; packer build packer.json`

2. Build the Sharemind SDK VM-s
`cd ../sharemind-sdk`
`packer build -color=false -var-file=variables.json packer-appserv.json | tee packer-appserv-log.txt 2>&1`
`packer build -color=false -var-file=variables.json packer-appserv-rmind.json | tee packer-appserv-rmind-log.txt 2>&1`
`packer build -color=false -var-file=variables.json packer-acadserv.json | tee packer-acadserv-log.txt 2>&1`
`packer build -color=false -var-file=variables.json packer-acadserv-rmind.json | tee packer-acadserv-rmind-log.txt 2>&1`
