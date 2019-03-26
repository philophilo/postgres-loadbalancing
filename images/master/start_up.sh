#!/usr/bin/env bash

setup_master() {
	# listent to all addresses
	sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.6/main/postgresql.conf

	# allow authentication all IP addresses
	sudo sed -i -e "s/127.0.0.1\/32/0.0.0.0\/0/" /etc/postgresql/9.6/main/pg_hba.conf

	# Restart the postgres server
	sudo systemctl restart postgresql

	# replication user with replication roles
	sudo -u postgres psql -c "CREATE USER replica REPLICATION;"

	# stop postgresql, allow replication to start
	sudo systemctl stop postgresql

	# Edit some config values in /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#wal_level = minimal/wal_level = hot_standby/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 5/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#wal_keep_segments = 0/wal_keep_segments = 32/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#archive_mode = off/archive_mode = on/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#archive_command = ''/archive_command = 'cp %p \/var\/lib\/postgresql\/9.6\/archive\/%f'/" /etc/postgresql/9.6/main/postgresql.conf

	# create archive, set permissions and owner
	sudo mkdir /var/lib/postgresql/9.6/archive
	sudo chmod 700 /var/lib/postgresql/9.6/main/archive/
	sudo chown postgres.postgres /var/lib/postgresql/9.6/archive/

	# allow replication user
	#sudo sed -i -e "s/#host    replication     postgres/host    replication     replica/" /etc/postgresql/9.6/main/pg_hba.conf
	sudo sed -i -e "$ a host     replication     replica         all                     trust" /etc/postgresql/9.6/main/pg_hba.conf

	# Restart the postgres 
	sudo systemctl start postgresql
	sudo systemctl restart postgresql

	netstat -plntu
}

source install.sh
setup_master
