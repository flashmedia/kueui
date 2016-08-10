#!/usr/bin/env bash

if [ ! -e /etc/vagrant/nodejs ]
then

    echo ">>> setting up nodejs"

    # install nodejs v6+
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt-get install -y nodejs

    # install latest version of npm
    npm install -g npm

    # only run once
    touch /etc/vagrant/nodejs

else

    echo ">>> nodejs already setup..."

fi
