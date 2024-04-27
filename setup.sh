#!/bin/bash

# Carpeta base donde se encuentran las carpetas eBGP, iBGP e interfaces
base_folder="configs"

# Nombres de las carpetas dentro de la carpeta base
carpetas=("interfaces" "eBGP" "iBGP" )

# Nombres de los archivos dentro de cada carpeta
archivos=("l1" "l2" "l3" "l4" "s1" "s2" "bl1" "bl2")

# Nombre del contenedor destino
contenedor="clab-my_dc1-l1"

# Lista de nombres de los hosts
hosts=("h1" "h2" "h3" "h4")

# Iterar sobre cada carpeta y archivo
for carpeta in "${carpetas[@]}"; do
    # Crear la carpeta dentro del contenedor si no existe
    docker exec "$contenedor" mkdir -p "/tmp/$carpeta"

    for archivo in "${archivos[@]}"; do
        # Construir la ruta completa del archivo
        archivo_path="$base_folder/$carpeta/$archivo"

        # Copiar el archivo al contenedor si existe
        if [ -f "$archivo_path" ]; then
            docker cp "$archivo_path" "$contenedor:/tmp/$carpeta/$archivo"
            docker exec "$contenedor" sr_cli source "/tmp/$carpeta/$archivo"
        else
            echo "El archivo $archivo no se encontró en la carpeta $carpeta"
        fi
    done
done



# Iterar sobre cada host
for host in "${hosts[@]}"; do
    # Obtener la dirección IP correspondiente
    case $host in
        "h1") ip="100.64.1.24/31" ;;
        "h2") ip="100.64.1.26/31" ;;
        "h3") ip="100.64.1.28/31" ;;
        "h4") ip="100.64.1.30/31" ;;
    esac
    
    # Ejecutar los comandos en el host
    docker exec "clab-my_dc1-$host" ip addr add "$ip" dev eth1
    docker exec "clab-my_dc1-$host" ip link set eth1 up
done