#!/bin/bash

# Comandos para el host h1
sudo ip addr add 192.168.1.11/24 dev eth1
sudo ip route add 192.168.0.0/16 via 192.168.1.1 dev eth1
sudo ip route add 172.16.0.0/16 via 192.168.1.1 dev eth1
