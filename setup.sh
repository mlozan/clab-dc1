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

# Carpeta base donde se encuentran las carpetas eBGP, iBGP e interfaces
base_folder="configs"

# Nombre del patrón de contenedor destino
contenedor_patron="clab-my_dc1-"

# Nombres de las carpetas dentro de la carpeta base
carpetas=("interfaces" "eBGP" "iBGP" "EVPN")

# Nombres de los nodos (que también se utilizarán para el nombre del contenedor)
nodos=("l1" "l2" "l3" "l4" "s1" "s2" "bl1" "bl2")

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

# Iterar sobre cada carpeta y nodo
for carpeta in "${carpetas[@]}"; do
    # Iterar sobre cada nodo
    for nodo in "${nodos[@]}"; do
        # Nombre del contenedor correspondiente al nodo
        contenedor="clab-my_dc1-$nodo"

        # Crear la carpeta dentro del contenedor si no existe
        docker exec "$contenedor" mkdir -p "/tmp/$carpeta"

        # Construir la ruta completa del archivo
        archivo_path="$base_folder/$carpeta/$nodo"

        # Copiar el archivo al contenedor si existe
        if [ -f "$archivo_path" ]; then
            docker cp "$archivo_path" "$contenedor:/tmp/$carpeta/$nodo"
            docker exec "$contenedor" sr_cli source "/tmp/$carpeta/$nodo"
        else
            echo "El archivo $nodo no se encontró en la carpeta $carpeta"
        fi
    done
done
