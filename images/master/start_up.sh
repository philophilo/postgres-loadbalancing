#!/usr/bin/env bash

setup_master() {
	# set configuration for postgresql
	sudo cp ./postgresql.conf /etc/postgresql/9.6/main/postgresql.conf
	# configure client authentication (host based authentication)
	sudo rm -v /etc/postgresql/9.6/main/pg_hba.conf
	sudo cp ./pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf
	# create replication user with replication privileges
	sudo -u postres psql -c "CREATE USER replica REPLICATION;"
	# setup archiving 
	sudo mkdir -p /var/lib/postgresql/9.6/main/archive/
	sudo chmod 700 /var/lib/postgresql/9.6/main/archive/
	sudo chown -R postgres:postgres /var/lib/postgresql/9.6/main/archive/
	# restart postgres service
	sudo systemctl restart postgresql
}
setup_master
