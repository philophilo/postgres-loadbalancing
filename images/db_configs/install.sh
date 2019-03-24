#!/usr/bin/env bash

# install postgresql server
installation() {
    # install wget
    sudo apt-get update && apt-get install -y wget
    # add postgres to sources.list
    sudo su -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main "  >> /etc/apt/sources.list.d/pgdg.list'
    # add key
    sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
    # update and install
    sudo apt-get update && sudo apt-get install -y postgresql-9.6 postgresql-client-9.6
}
installation
