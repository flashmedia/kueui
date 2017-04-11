#!/usr/bin/env bash

source /vagrant/vagrant/bashurator/init.sh

configure_c() {

    # setup handy script for command dc commands
    if [ ! -e /usr/local/bin/c ]; then
        ln -s /vagrant/vagrant/scripts/c /usr/local/bin/c
    fi

}

# Execute the function above, in an idempotent function.
bashurator.configure "c" configure_c
