#!/usr/bin/env bash

if [ ! -e /etc/vagrant/development ]
then

    echo ">>> setting up development"

    # alias the docker-clean-containers script
    if [ ! -e /usr/local/bin/docker-clean-containers ]; then
        ln -s /vagrant/vagrant/scripts/docker-clean-containers /usr/local/bin/docker-clean-containers
    fi

    if [ ! -e /usr/local/bin/docker-clean-images ]; then
        ln -s /vagrant/vagrant/scripts/docker-clean-images /usr/local/bin/docker-clean-images
    fi

    if [ ! -e /usr/local/bin/tag ]; then
        ln -s /vagrant/vagrant/scripts/tag /usr/local/bin/tag
    fi

    # install npm modules (as vagrant user)
    cd /vagrant/kueui/root/app && sudo -H -u vagrant bash -c "npm install"

    # only run once
    touch /etc/vagrant/development

else

    echo ">>> development already setup..."

fi
