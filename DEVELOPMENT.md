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
- Start the vagrant machine by running `vagrant up --provider=virtualbox`.

Once the VM is created, continue with the process:

- Execute `vagrant ssh` to be provided with a bash shell within the virtual machine.
- Get into the `/vagrant` directory, by executing `cd /vagrant`.

Now install the node modules in all required directories inside `vagrant` as follow:

- Execute `c npm all install`.

Finally run the docker containers to have the application up and running:

- Log into Docker with `docker login -u <username>` (You will be prompted to provide password).
- Execute `c pull && c build` to use Docker compose to build the Docker containers.
- Execute `c up && c logs` to start the containers and view the logs.

Now you have everything required to run the application, and the application itself will be running.

To access the KUE UI on this vagrant instance, browse to the following URLs:

- http://kueui.repcoservice.local:6001/api
- http://kueui.repcoservice.local:6001/kue


[vagrant]: https://www.vagrantup.com/
[vmwareworkstation]: https://www.vmware.com/au/products/workstation/
[vmwarefusion]: https://www.vmware.com/au/products/fusion/
[virtualbox]: https://www.virtualbox.org/
[git]: https://git-scm.com/
