#!/bin/bash

# Comandos para el host h2
docker exec -ti clab-my_dc1-h2 sudo ip addr add 172.16.1.12/24 dev eth1
docker exec -ti clab-my_dc1-h2 sudo ip route add 192.168.0.0/16 via 172.16.1.1 dev eth1
docker exec -ti clab-my_dc1-h2 sudo ip route add 172.16.0.0/16 via 172.16.1.1 dev eth1
