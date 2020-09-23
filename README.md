# Packer Builder vSphere ISO

This project contains the packer build configuration for VMs on VMware vSphere.

## Requirements:

The following software must be installed/present on your local machine before you can use packer to build any of these vSphere images:

  - [Packer](http://www.packer.io/)
  - Optional: [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

  Note: To resolve ansible > 2.7.x issue in [Packer](https://github.com/hashicorp/packer/issues/7667), `ansible_python_interpreter` is used.

## Usage:

Make sure all the required software (listed above) is installed, then cd into one of the distro directories and run:

for Ubuntu 20.04

```
$ cp variables.json.sample variables.json

$ cd ubuntu/20

$ packer build -var-file=../../variables.json \
ubuntu20.json
```

## License

MIT

## Author

These configurations are maintained by Nick Adams.
