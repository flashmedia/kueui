# Development

## Requirements

You'll need the following to develop and test our images:

- [Vagrant][vagrant]
- Virtualization software, either: [VMware Workstation][vmwareworkstation], [VMware Fusion][vmwarefusion] or [Virtual Box][virtualbox]
- [Git][git]

Once you've created the virtual machine you'll have an environment complete with:

- Docker
- Docker compose
- Git
- Node.js

There are files for editors that should keep the file formatting consistent with what already exists in the repository.

## Setup

- Fork the repository.
- Clone your fork locally.
- Start the vagrant machine by running `vagrant up`.
- To test the images, run `c up` - this is a custom script that has been build to help with every development with docker compose

[vagrant]: https://www.vagrantup.com/
[vmwareworkstation]: https://www.vmware.com/au/products/workstation/
[vmwarefusion]: https://www.vmware.com/au/products/fusion/
[virtualbox]: https://www.virtualbox.org/
[git]: https://git-scm.com/
