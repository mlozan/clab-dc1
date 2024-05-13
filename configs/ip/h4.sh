#!/bin/bash

# Comandos para el host h4
sudo ip addr add 172.16.3.2/24 dev eth1
sudo ip route add 192.168.0.0/16 via 172.16.3.1 dev eth1
sudo ip route add 172.16.0.0/16 via 172.16.3.1 dev eth1
