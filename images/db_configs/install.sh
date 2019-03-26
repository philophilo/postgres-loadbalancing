#!/usr/bin/env bash

# install postgresql server
installation() {
    # install wget
    sudo apt-get update
    # add postgres to sources.list
	echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' | sudo tee /etc/apt/sources.list.d/postgresql.list
    # add key
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
    # update and install
    sudo apt-get update && sudo apt-get install -y postgresql-9.6 postgresql-client-9.6
    sudo systemctl enable postgresql
    netstat -plntu
}
installation
