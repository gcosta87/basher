#!/bin/bash
#
# functions.sh
# 	Funcones comunes a todos los componetes de Basher
#
# Autor: Gonzalo Gabriel Costa (twitter.com/gcosta87)
# Ver el archivo LICENSE para la informacion del liberación del codigo de este proyecto.
# web: https://github.com/gcosta87/basher

# Recupera un valor almacenado el el archivo de propiedades de la instancia	
# $1 (string): constante PROPERTY_KEY_XXX a leer	
# Ejemplo: readProperty #PROPERTY_KEY_XXX
readProperty(){
	cat "$PROPERTY_FILE" | grep "$1=" | cut -f2 -d'='
}

#calcula el uptime de basher
basherUptime(){
	pid=`readProperty $PROPERTY_KEY_PID` 
	ps -p "$pid" -o etime | tail -n1 | tr -s ' ' | sed -r  's:^\s+::';
}