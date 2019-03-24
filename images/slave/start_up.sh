#!/usr/bin/env bash

setup_slave(){
	# stop postgresql server
	sudo systemctl stop postgresql
	# empty data directory
	sudo rm /var/lib/postgresql/9.6/main/*
	# initialize backup
	sudo -u postgres pg_basebackup -h <MASTER_IP> -D /var/lib/postgresql/9.6/main -U replica -v --xlog-method=stream
	# remove default configurations
	sudo rm /etc/postgresql/9.6/main/pg_hba.conf /etc/postgresql/9.6/main/postgresql.conf
	# set new configurations
	sudo mv ./pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf
	sudo mv ./postgresql.conf /etc/postgresql/9.6/main/postgresql.conf
	# configure recovery
	sudo mv ./recovery.conf /var/lib/postgresql/9.6/main/recovery.conf
	sudo chown postgres.postgres /var/lib/postgresql/9.6/main/recovery.conf
	# start slave server
	sudo systemctl start postgresql
}
setup_slave
