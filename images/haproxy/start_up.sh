#!/usr/bin/env bash

function get_instance_metadata {
  local name="$1"

  curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/${name}"
}

get_values() {
    echo "MASTER_IP=\"$(get_instance_metadata "MASTER_IP")\"" >> .env
    echo "SLAVE1_IP=\"$(get_instance_metadata "SLAVE1_IP")\"" >> .env
    echo "SLAVE2_IP=\"$(get_instance_metadata "SLAVE2_IP")\"" >> .env
}

fill_template() {
    get_values
    . .env
    . supply_values.sh .
}

setup_haproxy() {
    # configure haproxy
    sudo rm -v /etc/haproxy/haproxy.cfg
    sudo mv ./haproxy.cfg /etc/haproxy/haproxy.cfg
    # start service
    sudo systemctl restart haproxy
}
fill_template
setup_haproxy
