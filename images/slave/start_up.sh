#!/usr/bin/env bash

create_recovery_file() {
cat << 'EOF' | sudo tee -a /var/lib/postgresql/9.6/main/recovery.conf >> /dev/null
standby_mode = 'on'
primary_conninfo = 'host=35.233.117.11 port=5432 user=replication password=password'
trigger_file = '/var/lib/postgresql/9.6/trigger'
restore_command = 'cp /var/lib/postgresql/9.6/archive/%f "%p"'
EOF
sudo su - postgres -c "chmod 600 /var/lib/postgresql/9.6/main/recovery.conf"
sudo su - postgres -c "chown postgres.postgres /var/lib/postgresql/9.6/main/recovery.conf"
}

setup_slave() {
	# stop postgresql, allow replication to start
	sudo systemctl stop postgresql

	# listent to all addresses
	sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.6/main/postgresql.conf

	# allow authentication all IP addresses
	sudo sed -i -e "s/127.0.0.1\/32/0.0.0.0\/0/" /etc/postgresql/9.6/main/pg_hba.conf

	# Edit some config values in /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#wal_level = minimal/wal_level = hot_standby/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 5/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#wal_keep_segments = 0/wal_keep_segments = 32/" /etc/postgresql/9.6/main/postgresql.conf
	sudo sed -i -e "s/#hot_standby = off/hot_standby = on/" /etc/postgresql/9.6/main/postgresql.conf

	# Restart the postgres 
	sudo systemctl start postgresql
	sudo systemctl restart postgresql
    sudo su - postgres -c "mv /var/lib/postgresql/9.6/main/ /var/lib/postgresql/9.6/ main-bekup"
    sudo su - postgres -c "mkdir /var/lib/postgresql/9.6/main/"
    sudo su - postgres -c "chmod 700 /var/lib/postgresql/9.6/main/"

	# initialize backup
	echo "35.233.117.11:5432:replica:postgres:password" > /var/lib/postgresql/.pgpass
	echo "35.233.117.11:5432:replica:postgres:password" > .pgpass
	sudo chmod 600 /var/lib/postgresql/.pgpass
	sudo chmod 600 .pgpass
	sudo chown postgres.postgres /var/lib/postgresql/.pgpass
    sudo -u postgres pg_basebackup -h 35.233.117.11 -D /var/lib/postgresql/9.6/main -U replica -v --xlog-method=stream
	# configure recovery
    create_recovery_file
	# start slave server
	sudo systemctl start postgresql
}

source install.sh
setup_slave
