#!/bin/bash

# Lista de comandos a ejecutar para cada host en my_dc1_ip.yaml
declare -A comandos_ip=(
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

# Lista de comandos a ejecutar para cada host en my_dc1_mac.yaml
declare -A comandos_mac=(
    ["h1"]="sudo ip addr add 172.16.1.12/24 dev eth1"

    ["h2"]="sudo ip addr add 172.16.1.14/24 dev eth1"

    ["h3"]="sudo ip addr add 172.16.1.16/24 dev eth1"

    ["h4"]="sudo ip addr add 172.16.1.18/24 dev eth1"
)

# Validar el argumento pasado al script
if [ "$1" != "ip" ] && [ "$1" != "mac" ]; then
    echo "El argumento debe ser 'ip' o 'mac'"
    exit 1
fi

# Determinar qué conjunto de comandos usar según el argumento
if [ "$1" == "ip" ]; then
    comandos=("${comandos_ip[@]}")
else
    comandos=("${comandos_mac[@]}")
fi


# Nombre del patrón de contenedor destino
contenedor_patron="clab-my_dc1-h"

# Iterar sobre cada host y ejecutar los comandos correspondientes
for ((index = 1; index <= 4; index++)); do
    contenedor="clab-my_dc1-h$index"
    
    # Ejecutar los comandos para el host actual
    comando="${comandos["h$index"]}"
    docker exec -ti "$contenedor" bash -c "$comando"
done

