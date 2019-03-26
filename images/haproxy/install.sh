#!/usr/bin/env bash

installation() {
    sudo apt-get update 
    # add haproxy repository
    sudo add-apt-repository ppa:vbernat/haproxy-1.8
    sudo apt-get update
    # install
    sudo apt-get install -y haproxy
}
installation
