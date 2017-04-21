#!/usr/bin/env bash

source /vagrant/vagrant/bashurator/init.sh

configure_env() {

    echo ">>> setting up environment variables"

    # make the env-create.sh executable
    chmod a+x /vagrant/vagrant/scripts/env.sh
    /vagrant/vagrant/scripts/env.sh

    # now source them into the current terminal session
    . /etc/profile.d/development.sh

}

# Execute the function above, in an idempotent function.
bashurator.configure "env" configure_env
