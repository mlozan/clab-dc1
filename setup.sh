#!/bin/bash

# Lista de comandos a ejecutar para cada host
declare -A comandos=(
    ["h1"]="sudo ip addr add 192.168.1.11/24 dev eth1;
           sudo ip route add 192.168.0.0/16 via 192.168.1.1 dev eth1;
           sudo ip route add 172.16.0.0/16 via 192.168.1.1 dev eth1;"

    ["h2"]="sudo ip addr add 172.16.1.12/24 dev eth1;
           sudo ip route add 192.168.0.0/16 via 172.16.1.1 dev eth1;
           sudo ip route add 172.16.0.0/16 via 172.16.1.1 dev eth1;"

    ["h3"]="sudo ip addr add 192.168.3.2/30 dev eth1;
           sudo ip route add 192.168.0.0/16 via 192.168.3.1 dev eth1;
           sudo ip route add 172.16.0.0/16 via 192.168.3.1 dev eth1;"

    ["h4"]="sudo ip addr add 172.16.3.2/24 dev eth1;
           sudo ip route add 192.168.0.0/16 via 172.16.3.1 dev eth1;
           sudo ip route add 172.16.0.0/16 via 172.16.3.1 dev eth1;"
)

# Nombre del patrón de contenedor destino
contenedor_patron="clab-my_dc1-"

# Lista de nombres de los hosts
hosts=("h1" "h2" "h3" "h4")

# Iterar sobre cada host y ejecutar los comandos correspondientes
for host in "${!comandos[@]}"; do
    contenedor="clab-my_dc1-$host"
    
    # Ejecutar los comandos para el host actual
    for comando in "${comandos[$host]}"; do
        docker exec -ti "$contenedor" bash -c "$comando"
    done
done
