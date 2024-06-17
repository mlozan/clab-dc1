#!/bin/bash

# Lista de comandos a ejecutar para cada host en el caso de configuración de nivel 3
declare -A comandos_ip=(
    ["h1"]="sudo ip addr add 192.168.1.11/24 dev eth1; 
            sudo ip route add 192.168.0.0/16 via 192.168.1.1 dev eth1; 
            sudo ip route add 172.16.0.0/16 via 192.168.1.1 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
    ["h2"]="sudo ip addr add 172.16.1.12/24 dev eth1; 
            sudo ip route add 192.168.0.0/16 via 172.16.1.1 dev eth1; 
            sudo ip route add 172.16.0.0/16 via 172.16.1.1 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
    ["h3"]="sudo ip addr add 192.168.3.2/30 dev eth1; 
            sudo ip route add 192.168.0.0/16 via 192.168.3.1 dev eth1; 
            sudo ip route add 172.16.0.0/16 via 192.168.3.1 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
    ["h4"]="sudo ip addr add 172.16.3.2/24 dev eth1; 
            sudo ip route add 192.168.0.0/16 via 172.16.3.1 dev eth1; 
            sudo ip route add 172.16.0.0/16 via 172.16.3.1 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
)

# Lista de comandos a ejecutar para cada host en el caso de configuración de nivel 2
declare -A comandos_mac=(
    ["h1"]="sudo ip addr add 172.16.1.12/24 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
    ["h2"]="sudo ip addr add 172.16.1.14/24 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
    ["h3"]="sudo ip addr add 172.16.1.16/24 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
    ["h4"]="sudo ip addr add 172.16.1.18/24 dev eth1;
            sudo ifconfig eth0 mtu 8900;
            sudo ifconfig eth1 mtu 8900;"
)

# Validar el argumento pasado al script
if [ "$1" != "ip" ] && [ "$1" != "mac" ]; then
    echo "El argumento debe ser 'ip' o 'mac'"
    exit 1
fi

# Determinar qué conjunto de comandos usar según el argumento
if [ "$1" == "ip" ]; then
    declare -n comandos_ref=comandos_ip
elif [ "$1" == "mac" ]; then
    declare -n comandos_ref=comandos_mac
fi

# Nombre del patrón de contenedor destino
contenedor_patron="clab-my_dc1-"
# Lista de nombres de los hosts
hosts=("h1" "h2" "h3" "h4")

# Iterar sobre cada host y ejecutar los comandos correspondientes
for host in "${hosts[@]}"; do
    contenedor="$contenedor_patron$host"
    comandos="${comandos_ref[$host]}"
    # Ejecutar los comandos para el host actual
    docker exec -ti "$contenedor" bash -c "$comandos"
done
