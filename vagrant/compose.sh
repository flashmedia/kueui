#!/usr/bin/env bash

if [ ! -e /etc/vagrant/compose ]
then

    echo ">>> setting up compose"

    # install compose
    curl -sL https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # now alias so we don't have to type docker-compose all the time, just dc
    if [ ! -e /usr/local/bin/dc ]; then
        ln -s /usr/local/bin/docker-compose /usr/local/bin/dc
    fi

    # setup handy script for command dc commands
    if [ ! -e /usr/local/bin/c ]; then
        ln -s /vagrant/vagrant/scripts/c /usr/local/bin/c
    fi

    # only run once
    touch /etc/vagrant/compose

else

    echo ">>> compose is already setup"

fi
