#!/bin/bash

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


