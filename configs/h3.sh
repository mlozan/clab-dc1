#!/bin/bash

# Comandos para el host h3
docker exec -ti clab-my_dc1-h3 sudo ip addr add 192.168.3.2/30 dev eth1
docker exec -ti clab-my_dc1-h3 sudo ip route add 192.168.0.0/16 via 192.168.3.1 dev eth1
docker exec -ti clab-my_dc1-h3 sudo ip route add 172.16.0.0/16 via 192.168.3.1 dev eth1
